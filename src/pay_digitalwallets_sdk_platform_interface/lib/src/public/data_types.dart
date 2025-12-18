// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
/// Callback signature for when the ready status of digital wallets changes
///
/// [isReady] determines whether or not digital wallets are ready to process payments
typedef DigitalWalletReadyChanged = void Function(bool isReady);

/// Callback signature for when a [DigitalWalletButton](https://pub.dev/documentation/pay_digitalwallets_sdk/latest/pay_digitalwallets_sdk/DigitalWalletButton-class.html) has been clicked
typedef OnDigitalWalletButtonClicked = void Function();
