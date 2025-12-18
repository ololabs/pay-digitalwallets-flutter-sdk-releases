# Olo Digital Wallets Flutter SDK

## Table of Contents

- [Olo Digital Wallets Flutter SDK](#olo-digital-wallets-flutter-sdk)
  - [Table of Contents](#table-of-contents)
  - [About the Flutter SDK](#about-the-flutter-sdk)
  - [Setup](#setup)
    - [Android-Specific Setup Steps](#android-specific-setup-steps)
      - [Supported Versions](#supported-versions)
      - [Activity Setup](#activity-setup)
    - [iOS-Specific Setup Steps](#ios-specific-setup-steps)
      - [Supported Versions](#supported-versions-1)
      - [CocoaPods Setup](#cocoapods-setup)
  - [Getting Started](#getting-started)
    - [Digital Wallets (Apple Pay & Google Pay)](#digital-wallets-apple-pay--google-pay)
  - [Handling Exceptions](#handling-exceptions)
    - [Example](#example)
  - [Native View Widgets](#native-view-widgets)
    - [Differences from Standard Flutter Widgets](#differences-from-standard-flutter-widgets)
      - [Sizing Differences](#sizing-differences)
    - [Available Widgets](#available-widgets)
      - [Digital Wallet Button Widget](#digital-wallet-button-widget)

## About the Flutter SDK

The Olo Digital Wallets Flutter SDK allows app developers to easily add digital wallet payment options (currently Apple Pay & Google Pay) to their checkout flow.

**IMPORTANT:** The primary purpose of the SDK is to facilitate payments with Olo's ordering ecosystem. It _should_ work with any processor that accepts Apple Pay and Google Pay, but functionality outside of Olo's ordering ecosystem has not been tested and is not guaranteed.

Use of the plugin is subject to the terms of the [MIT License](https://github.com/ololabs/pay-digitalwallets-flutter-sdk-releases/blob/main/LICENSE).

This SDK documentation provides information on how to use the Digital Wallets Flutter SDK in a Flutter app.

## Setup

### Android-Specific Setup Steps

#### Supported Versions

The minimum supported version is [Android API 26](https://developer.android.com/tools/releases/platforms#8.0). The Android app's minimum API version must be set to 26 or higher.

#### Activity Setup

By default, when generating a new app, Flutter creates an activity (usually named `MainActivity`) that inherits from
[FlutterActivity](https://api.flutter.dev/javadoc/io/flutter/embedding/android/FlutterActivity.html). In order to use
Google Pay with the Olo Digital Wallets SDK, the activity in the app needs to inherit from
[FlutterFragmentActivity](https://api.flutter.dev/javadoc/io/flutter/embedding/android/FlutterFragmentActivity.html).

To switch the base activity type, find the application's `MainActivity` class and change it to inherit from `FlutterFragmentActivity`
```kotlin
class MainActivity: FlutterFragmentActivity() {
}
```

Attempting to initialize Google Pay when [FlutterFragmentActivity](https://api.flutter.dev/javadoc/io/flutter/embedding/android/FlutterFragmentActivity.html)
is not used will result in an error. A message will also be logged to the debug console.

> **_NOTE:_** In some non-standard uses of Flutter (such as hosting Flutter within a native Android app), it may not be possible to use
> [FlutterFragmentActivity](https://api.flutter.dev/javadoc/io/flutter/embedding/android/FlutterFragmentActivity.html). If this is the case,
> [FragmentActivity](https://developer.android.com/reference/androidx/fragment/app/FragmentActivity) can be used instead. Another
> consideration for non-standard uses of Flutter is that Android apps can have multiple activities. In cases where multiple activities are used,
> it does not matter which activity the SDK is initialized in, but Google Pay **_must_** be initialized in the same activity where it is going
> to be used. **_This is not a concern for standard Flutter apps because only one activity is used in the app._**

### iOS-Specific Setup Steps

#### Supported Versions

The minimum supported version is [iOS 13](https://support.apple.com/en-us/HT210393#13). The iOS app's
settings must be set to target iOS 13 or newer.

#### CocoaPods Setup

Add the following lines at the top of your app's Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/ololabs/podspecs.git'
```

Open a terminal, navigate to your app's iOS folder (usually `<projectName>/ios`), and run the following command:

```bash
pod install
```

## Getting Started

Here is a high-level overview on how to integrate the SDK into an app:

### Digital Wallets (Apple Pay & Google Pay)

This SDK is used for processing payments via Apple Pay and Google Pay. The SDK provides a [DigitalWalletButton](#digital-wallet-button-widget) widget and returns a `PaymentData` instance that is then used to submit a basket with Olo's Ordering API. Specific details can be found below.

1. Import the SDK
    ```dart
    import 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk.dart';
    ```
1. Configure the SDK (see [PayDigitalWalletsSdk.configure()](https://pub.dev/documentation/pay_digitalwallets_sdk/latest/pay_digitalwallets_sdk/PayDigitalWalletsSdk/configure.html))
1. Get payment data from the digital wallet
    1. Set [PayDigitalWalletsSdk.onDigitalWalletReady](https://pub.dev/documentation/pay_digitalwallets_sdk/latest/pay_digitalwallets_sdk/PayDigitalWalletsSdk/onDigitalWalletReady.html) and wait for the callback to indicate digital wallets can be used
    1. Add a [DigitalWalletButton](#digital-wallet-button-widget) to your app
    1. Get payment data via [PayDigitalWalletsSdk.getPaymentData()](https://pub.dev/documentation/pay_digitalwallets_sdk/latest/pay_digitalwallets_sdk/PayDigitalWalletsSdk/getPaymentData.html)
1. Submit the payment data to a backend server to process the payment/order. _(for ordering with Olo, use the [Olo Ordering API](https://developer.olo.com/docs/load/olopay#section/Submitting-a-Basket-via-the-Ordering-API))

## Handling Exceptions

When calling functions in the SDK, there is a chance that the call will fail. When this happens the returned error object will be a [PlatformException](https://api.flutter.dev/flutter/services/PlatformException-class.html) and will contain `code` and `message` properties indicating why the method call failed.

Refer to the documentation for each method for information on possible error codes that will be returned if there is an error.

### Example

```dart
try {
  final paymentData = await sdk.getPaymentData(paymentParams);
  // Handle payment data
} on PlatformException catch (e) {
  // Handle other errors
  print('Payment error: ${e.message}');
}
```

## Native View Widgets

Widgets in the Olo Digital Wallets SDK host native Android and iOS views to provide platform-specific digital wallet buttons.

### Differences from Standard Flutter Widgets

Widgets in the Olo Digital Wallets SDK host native Android and iOS views, which behave differently than standard Flutter widgets. Details of these differences can be found below.

#### Sizing Differences

One of the biggest differences is that native widgets need to have a specific height defined. The [DigitalWalletButton][#digital-wallet-button-widget] widget is wrapped with a [ConstrainedBox](https://api.flutter.dev/flutter/widgets/ConstrainedBox-class.html) with a default height that works in most scenarios. It is possible to pass in constraints if the default values need to be changed.

The widget will resize its view to fit within bounds specified. The native view for the [DigitalWalletButton](#digital-wallet-button-widget) may have a maximum height that it cannot exceed, in this case it will center itself within the Flutter constraints specified. Please refer to the widget documentation for information regarding recommended heights and sizing approaches.

### Available Widgets

#### Digital Wallet Button Widget

- [DigitalWalletButton](https://pub.dev/documentation/pay_digitalwallets_sdk/latest/pay_digitalwallets_sdk/DigitalWalletButton-class.html) - This widget displays a native Apple Pay or Google Pay button (depending on the device) that can be used to start the digital wallet payment sheet. The button automatically adapts to the platform and displays the appropriate branding.
