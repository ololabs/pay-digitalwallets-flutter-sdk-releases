// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
/// This is the main library for the Digital Wallets Flutter SDK and contains all classes, enums, and data types used by the SDK.
/// The main entry point for working with the SDK is the [PayDigitalWalletsSdk] class.
///
/// To use this library in your code, import it as follows
/// ```dart
/// import 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk.dart';
/// ```
///
/// For convenience in working with the documentation, additional sub-libraries are provided that break out the classes
/// into the following categories:
/// - [pay_digitalwallets_sdk_data_classes](https://pub.dev/documentation/pay_digitalwallets_sdk_platform_interface/latest/pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_classes) lists all data classes and enums in the SDK
/// - [pay_digitalwallets_sdk_data_types](https://pub.dev/documentation/pay_digitalwallets_sdk_platform_interface/latest/pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_types) lists all custom data types defined in the SDK
/// - [pay_digitalwallets_sdk_widgets] lists all widget and controller classes defined in the SDK
library;

// EXPORT ALL FILES NEEDED BY THE SDK
export 'package:pay_digitalwallets_sdk/src/public/pay_digitalwallets_sdk.dart';
export 'package:pay_digitalwallets_sdk/pay_digitalwallets_sdk_widgets.dart';
export 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_classes.dart';
export 'package:pay_digitalwallets_sdk_platform_interface/pay_digitalwallets_sdk_data_types.dart';
