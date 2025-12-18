// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
class DataKeys {
  // Prefix Keys
  static const bridgePrefix = "com.olo.flutter.payDigitalWalletsSdk";
  static const digitalWalletMethodChannelKey = '$bridgePrefix/sdk';

  // Event Handler Keys
  static const digitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent";
  static const digitalWalletButtonClickedEventHandlerKey =
      "digitalWalletButtonClickedEvent";

  // Native Method Keys
  static const configureMethodKey = "configure";
  static const getPaymentDataMethodKey = "getPaymentData";

  // Native Method Parameter Keys
  static const digitalWalletReadyParameterKey = "isReady";
  static const companyLabelKey = "companyLabel";
  static const digitalWalletCountryCodeParameterKey = "countryCode";
  static const currencyCodeKey = "currencyCode";
  static const emailRequiredKey = "emailRequired";
  static const phoneNumberRequiredKey = "phoneNumberRequired";
  static const fullNameRequiredKey = "fullNameRequired";
  static const fullBillingAddressRequiredKey = "fullBillingAddressRequired";
  static const allowedCardNetworksKey = "allowedCardNetworks";
  static const applePayMerchantIdParameterKey = "merchantId";
  static const applePayFullPhoneticNameRequiredParameterKey =
      "fullPhoneticNameRequired";
  static const googlePayGatewayParametersJsonParameterKey =
      "googlePayGatewayParametersJson";
  static const googlePayProductionEnvironmentParameterKey =
      "googlePayProductionEnvironment";
  static const googlePayExistingPaymentMethodRequiredParameterKey =
      "existingPaymentMethodRequired";
  static const googlePayCurrencyMultiplierParameterKey =
      "googlePayCurrencyMultiplier";

  // Card type enum values
  static const visaFieldValue = "Visa";
  static const amexFieldValue = "Amex";
  static const discoverFieldValue = "Discover";
  static const masterCardFieldValue = "Mastercard";
  static const unsupportedCardFieldValue = "Unsupported";

  // PaymentData keys
  static const pdTokenKey = "token";
  static const pdLastFourKey = "lastFour";
  static const pdCardTypeKey = "cardType";
  static const pdOloCardDescriptionKey = "oloCardDescription";
  static const pdCardDetailsKey = "cardDetails";
  static const pdEmailKey = "email";
  static const pdPhoneNumberKey = "phoneNumber";
  static const pdFullNameKey = "fullName";
  static const pdFullPhoneticNameKey = "fullPhoneticName";
  static const pdBillingAddressKey = "billingAddress";

  // Address keys
  static const address1Key = "address1";
  static const address2Key = "address2";
  static const address3Key = "address3";
  static const administrativeAreaKey = "administrativeArea";
  static const countryCodeKey = "countryCode";
  static const localityKey = "locality";
  static const postalCodeKey = "postalCode";
  static const sortingCodeKey = "sortingCode";

  // Digital Wallet Line Item Keys
  static const lineItemAmountKey = "lineItemAmount";
  static const lineItemTypeKey = "lineItemType";
  static const lineItemLabelKey = "lineItemLabel";
  static const lineItemStatusKey = "lineItemStatus";
  static const lineItemSubtotalLabelKey = "Subtotal";
  static const lineItemTaxLabelKey = "Tax";

  // Apple Pay Button Configuration Keys
  static const applePayButtonStyleKey = "ApplePayButtonStyle";
  static const applePayButtonTypeKey = "ApplePayButtonType";
  static const applePayButtonCornerRadiusKey = "ApplePayButtonCornerRadius";

  // Apple Pay Button Style Keys
  static const applePayButtonStyleWhite = "white";
  static const applePayButtonStyleWhiteOutline = "whiteOutline";
  static const applePayButtonStyleBlack = "black";
  static const applePayButtonStyleAutomatic = "automatic";

  // Apple Pay Button Type Keys
  static const applePayButtonTypePlain = "plain";
  static const applePayButtonTypeBuy = "buy";
  static const applePayButtonTypeAddMoney = "addMoney";
  static const applePayButtonTypeBook = "book";
  static const applePayButtonTypeCheckout = "checkout";
  static const applePayButtonTypeContinue = "continue";
  static const applePayButtonTypeContribute = "contribute";
  static const applePayButtonTypeDonate = "donate";
  static const applePayButtonTypeInStore = "inStore";
  static const applePayButtonTypeOrder = "order";
  static const applePayButtonTypeReload = "reload";
  static const applePayButtonTypeRent = "rent";
  static const applePayButtonTypeSetUp = "setUp";
  static const applePayButtonTypeSubscribe = "subscribe";
  static const applePayButtonTypeSupport = "support";
  static const applePayButtonTypeTip = "tip";
  static const applePayButtonTypeTopUp = "topUp";

  // Google Pay Button Configuration Keys
  static const googlePayButtonThemeKey = "GooglePayButtonTheme";
  static const googlePayButtonTypeKey = "GooglePayButtonType";
  static const googlePayButtonCornerRadiusKey = "GooglePayButtonCornerRadius";

  // Google Pay Button Theme Keys
  static const googlePayButtonThemeLight = "light";
  static const googlePayButtonThemeDark = "dark";

  // Google Pay Button Type Keys
  static const googlePayButtonTypeBuy = "buy";
  static const googlePayButtonTypeBook = "book";
  static const googlePayButtonTypeCheckout = "checkout";
  static const googlePayButtonTypeDonate = "donate";
  static const googlePayButtonTypeOrder = "order";
  static const googlePayButtonTypePay = "pay";
  static const googlePayButtonTypeSubscribe = "subscribe";
  static const googlePayButtonTypePlain = "plain";

  // Google Pay Line Item Keys
  // - DO NOT EDIT THESE VALUES - THEY MAP DIRECTLY TO VALUES IN THE OLO DIGITAL WALLETS SDK
  static const googlePayLineItemTypeKey = "Line_Item";
  static const googlePaySubtotalTypeKey = "Subtotal";
  static const googlePayTaxTypeKey = "Tax";
  static const finalStatus = "Final";
  static const pendingStatus = "Pending";

  // PaymentParameters keys
  static const paymentAmountKey = "amount";
  static const googlePayCheckoutStatusKey = "googlePayCheckoutStatus";
  static const totalPriceLabelKey = "totalPriceLabel";
  static const lineItemsKey = "lineItems";
  static const validateLineItemsKey = "validateLineItems";

  // GooglePayCheckoutStatus enum values
  static const estimatedDefault = "EstimatedDefault";
  static const finalDefault = "FinalDefault";
  static const finalImmediatePurchase = "FinalImmediatePurchase";

  // Error keys
  static const errorMessageKey = "errorMessage";
  static const errorCodeKey = "errorCode";
  static const digitalWalletTypeKey = "digitalWalletType";
}
