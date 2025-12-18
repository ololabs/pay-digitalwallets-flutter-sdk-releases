// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'dart:async' show unawaited;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pay_digitalwallets_sdk/src/private/data/data_keys.dart';
import 'package:pay_digitalwallets_sdk/src/private/data/digital_wallet_creation_params.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/extensions/method_channel_extensions.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/factories/platform_exception_factory.dart';
import 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk.dart';

/// A button for initiating digital wallet payments.
///
/// On Android, it will display a native Google Pay button and on iOS it will
/// display a native Apple Pay button.
///
/// Use the [onClicked] event handler to call
/// [PayDigitalWalletsSdk.getPaymentData] and launch the digital wallet
/// payment sheet flow.
///
/// ### Sizing Considerations:
///
/// This widget hosts native Android and iOS buttons. The native views are
/// wrapped by a [ConstrainedBox] with default `constraints` set to
///  `BoxConstraints(maxHeight: 45)`. This can be customized using the
/// `constraints` property.
///
/// If the height of the Flutter container exceeds the height of the native
/// button, the native button will be centered vertically in the Flutter
/// container.
///
/// ### Example Implementation
///
/// ```dart
/// Future<void> onDigitalWalletButtonClicked() async {
///   DigitalWalletPaymentParameters paymentParams = DigitalWalletPaymentParameters(
///     amount: 1.23,
///   );
///
///   try {
///     // Present the Apple Pay or Google Pay payment sheet and generate a
///     // payment data object
///     PaymentData? paymentData =
///       await _payDigitalWalletsSdk?.getPaymentData(paymentParams);
///
///     if (paymentData == null) {
///       // Handle user canceled state
///     } else {
///       // Use paymentData to submit an order to Olo's Ordering API:
///       // https://developer.olo.com/docs/load/olopay#section/Submitting-a-Basket-via-the-Ordering-API
///     }
///   } on PlatformException catch (e) {
///     // Handle errors
///   }
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   if (_digitalWalletsReady)
///     DigitalWalletButton(
///       onClicked: onDigitalWalletButtonClicked,
///     ),
/// }
/// ```
class DigitalWalletButton extends StatefulWidget {
  /// Creates a new instance of this widget
  ///
  /// Use [onClicked] to handle button clicks.
  ///
  /// Use [enabled] to control whether or not the button should respond to user
  /// clicks
  ///
  /// The [constraints] property can be used to set the height of this widget.
  /// Note that the native button will be centered vertically if the height of
  /// this widget exceeds the height of the native button.
  ///
  /// Use [applePay] to configure the look and feel of the Apple Pay button and
  /// [googlePay] to configure the look and feel of the Google Pay button.
  const DigitalWalletButton({
    super.key,
    this.onClicked,
    this.applePay = const ApplePayButtonConfiguration.only(),
    this.constraints = const BoxConstraints(maxHeight: 45),
    this.enabled = true,
    this.googlePay = const GooglePayButtonConfiguration.only(),
  });

  /// Property to set the native view's height and width
  ///
  /// Default value is `BoxConstraints(maxHeight: 45)`
  final BoxConstraints constraints;

  /// Whether or not the button should be enabled and allow click events
  final bool enabled;

  /// A callback function to be executed when the digital wallet button is
  /// clicked
  final OnDigitalWalletButtonClicked? onClicked;

  /// Configuration parameters for displaying an Apple Pay Button
  final ApplePayButtonConfiguration applePay;

  /// Configuration parameters for displaying a Google Pay button
  final GooglePayButtonConfiguration googlePay;

  @override
  State<StatefulWidget> createState() => _DigitalWalletButtonState();
}

class _DigitalWalletButtonState extends State<DigitalWalletButton> {
  MethodChannel? _channel;
  DigitalWalletCreationParams? _pendingParams;

  void onButtonClickedHandler() {
    widget.onClicked?.call();
  }

  Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case DataKeys.digitalWalletButtonClickedEventHandlerKey:
        return onButtonClickedHandler();
      default:
        assert(false, "No method name keys matched, no event callbacks called");
        return;
    }
  }

  Future<void> platformViewCreatedCallback(id) async {
    _channel = MethodChannel(
      '${DataKeys.digitalWalletButtonBaseMethodChannelKey}$id',
    );
    _channel!.setMethodCallHandler(onMethodCall);

    if (_pendingParams != null) {
      final params = _pendingParams!;
      _pendingParams = null;
      unawaited(refreshUI(params));
    }
  }

  Future<void> refreshUI(DigitalWalletCreationParams params) async {
    try {
      if (_channel == null) {
        _pendingParams = params;
        return;
      }

      return await _channel!.invokeOloMethod(DataKeys.refreshUiMethod, {
        DataKeys.creationParameters: params.toMap(),
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  @override
  void didUpdateWidget(covariant DigitalWalletButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldParams = DigitalWalletCreationParams(
      applePayConfig: oldWidget.applePay,
      googlePayConfig: oldWidget.googlePay,
      enabled: oldWidget.enabled,
    );

    final newParams = DigitalWalletCreationParams(
      applePayConfig: widget.applePay,
      googlePayConfig: widget.googlePay,
      enabled: widget.enabled,
    );

    if (!newParams.isEqualTo(oldParams)) {
      unawaited(refreshUI(newParams));
    }
  }

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    _pendingParams = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = DataKeys.digitalWalletButtonViewTypeKey;

    final params = DigitalWalletCreationParams(
      applePayConfig: widget.applePay,
      googlePayConfig: widget.googlePay,
      enabled: widget.enabled,
    ).toMap();

    return ConstrainedBox(
      constraints: widget.constraints,
      child: Builder(
        builder: (context) {
          if (Platform.isAndroid) {
            return AndroidView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: params,
              onPlatformViewCreated: platformViewCreatedCallback,
            );
          } else if (Platform.isIOS) {
            return UiKitView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: params,
              onPlatformViewCreated: platformViewCreatedCallback,
            );
          } else {
            return Text(
                'Digital Wallets Button is not supported on this platform.');
          }
        },
      ),
    );
  }
}
