// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
class DataKeys {
  // Prefix Keys
  static const bridgePrefix = "com.olo.flutter.payDigitalWalletsSdk";

  // View Registration Keys
  static const digitalWalletButtonViewType = "DigitalWalletButton";
  static const digitalWalletButtonViewTypeKey =
      '$bridgePrefix/$digitalWalletButtonViewType';

  // Method Channel Keys
  static const digitalWalletButtonBaseMethodChannelKey =
      '$digitalWalletButtonViewTypeKey:';

  // Event Handler Keys
  static const digitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent";
  static const digitalWalletButtonClickedEventHandlerKey =
      "digitalWalletButtonClickedEvent";

  // Native Method Parameter Keys
  static const creationParameters = "creationParams";
  static const enabledParameterKey = "enabled";
  static const refreshUiMethod = "refreshUI";
}
