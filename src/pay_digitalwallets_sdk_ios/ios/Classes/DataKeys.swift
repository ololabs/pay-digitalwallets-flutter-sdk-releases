// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
//
//  DataKeys.swift
//  Pods
//
//  Created by Richard Dowdy on 11/7/25.
//

public class DataKeys {
    // Prefix Keys
    public static let BridgePrefix = "com.olo.flutter.payDigitalWalletsSdk"
    public static let DigitalWalletButtonViewType = "DigitalWalletButton"
    
    // Method Channel Keys
    public static let DigitalWalletMethodChannelKey = "\(BridgePrefix)/sdk"
    public static let DigitalWalletButtonBaseMethodChannelKey = "\(BridgePrefix)/\(DigitalWalletButtonViewType):"
    
    // View Registration Keys
    public static let DigitalWalletButtonViewKey = "\(BridgePrefix)/\(DigitalWalletButtonViewType)"
    
    // Event Handler Keys
    public static let DigitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent"
    public static let DigitalWalletButtonClickedEventHandlerKey = "digitalWalletButtonClickedEvent"
    
    // Method Call Keys
    public static let ConfigureMethodKey = "configure"
    public static let GetPaymentDataMethodKey = "getPaymentData"
    public static let RefreshUiMethodKey = "refreshUI"

    // Method Call Parameter Keys
    public static let CreationParameters = "creationParams"
    public static let EnabledParameterKey = "enabled"
    public static let DigitalWalletAmountParameterKey = "amount"
    public static let DigitalWalletAllowedCardNetworksParameterKey = "allowedCardNetworks"
    public static let DigitalWalletCountryCodeParameterKey = "countryCode"
    public static let DigitalWalletCurrencyCodeParameterKey = "currencyCode"
    public static let DigitalWalletErrorMessageParameterKey = "errorMessage"
    public static let DigitalWalletErrorCodeKey = "errorCode"
    public static let DigitalWalletTypeParameterKey = "digitalWalletType"
    public static let DigitalWalletTypeParameterValue = "applePay"
    public static let ApplePayMerchantIdParameterKey = "merchantId"
    public static let ApplePayCompanyLabelParameterKey = "companyLabel"
    public static let DigitalWalletReadyParameterKey = "isReady"
    public static let DigitalWalletFullBillingAddressRequired = "fullBillingAddressRequired"
    public static let DigitalWalletPhoneNumberRequired = "phoneNumberRequired"
    public static let DigitalWalletFullNameRequired = "fullNameRequired"
    public static let DigitalWalletFullPhoneticNameRequired = "fullPhoneticNameRequired"
    public static let DigitalWalletEmailRequired = "emailRequired"
    public static let DigitalWalletLineItemsKey = "lineItems"
    public static let DigitalWalletValidateLineItemsKey = "validateLineItems"
    public static let DigitalWalletLineItemLabelKey = "lineItemLabel"
    public static let DigitalWalletLineItemAmountKey = "lineItemAmount"
    public static let DigitalWalletLineItemStatusKey = "lineItemStatus"
    public static let DigitalWalletLineItemFinalStatusKey = "Final"

    // PaymentData keys
    public static let PaymentDataTokenKey = "token"
    public static let PaymentDataLastFourKey = "lastFour"
    public static let PaymentDataCardTypeKey = "cardType"
    public static let PaymentDataOloCardDescriptionKey = "oloCardDescription"
    public static let PaymentDataCardDetailsKey = "cardDetails"
    public static let PaymentDataEmailKey = "email"
    public static let PaymentDataPhoneNumberKey = "phoneNumber"
    public static let PaymentDataFullNameKey = "fullName"
    public static let PaymentDataFullPhoneticNameKey = "fullPhoneticName"
    public static let PaymentDataBillingAddressKey = "billingAddress"

    // Address keys
    public static let AddressLine1Key = "address1"
    public static let AddressLine2Key = "address2"
    public static let AddressLine3Key = "address3"
    public static let AddressAdministrativeAreaKey = "administrativeArea"
    public static let AddressCountryCodeKey = "countryCode"
    public static let AddressLocalityKey = "locality"
    public static let AddressPostalCodeKey = "postalCode"
    public static let AddressSortingCodeKey = "sortingCode"

    // Apple Pay Button Configuration Keys
    public static let ApplePayButtonStyleKey = "ApplePayButtonStyle"
    public static let ApplePayButtonTypeKey = "ApplePayButtonType"
    public static let ApplePayButtonCornerRadiusKey = "ApplePayButtonCornerRadius"
    
    // Apple Pay Button Style Keys
    public static let ApplePayButtonStyleWhite = "white"
    public static let ApplePayButtonStyleWhiteOutline = "whiteOutline"
    public static let ApplePayButtonStyleBlack = "black"
    public static let ApplePayButtonStyleAutomatic = "automatic"

    // Apple Pay Button Type Keys
    public static let ApplePayButtonTypePlain = "plain"
    public static let ApplePayButtonTypeBuy = "buy"
    public static let ApplePayButtonTypeAddMoney = "addMoney"
    public static let ApplePayButtonTypeBook = "book"
    public static let ApplePayButtonTypeCheckout = "checkout"
    public static let ApplePayButtonTypeContinue = "continue"
    public static let ApplePayButtonTypeContribute = "contribute"
    public static let ApplePayButtonTypeDonate = "donate"
    public static let ApplePayButtonTypeInStore = "inStore"
    public static let ApplePayButtonTypeOrder = "order"
    public static let ApplePayButtonTypeReload = "reload"
    public static let ApplePayButtonTypeRent = "rent"
    public static let ApplePayButtonTypeSetUp = "setUp"
    public static let ApplePayButtonTypeSubscribe = "subscribe"
    public static let ApplePayButtonTypeSupport = "support"
    public static let ApplePayButtonTypeTip = "tip"
    public static let ApplePayButtonTypeTopUp = "topUp"
}
