// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
package com.olo.flutter.digitalwallets.data

class DataKeys {
    companion object {
        private const val BridgePrefix = "com.olo.flutter.payDigitalWalletsSdk"
        private const val DigitalWalletButtonViewType = "DigitalWalletButton"
        const val DigitalWalletButtonViewKey = "$BridgePrefix/$DigitalWalletButtonViewType"
        const val DigitalWalletMethodChannelKey = "$BridgePrefix/sdk"
        const val DigitalWalletButtonBaseMethodChannelKey = "$BridgePrefix/$DigitalWalletButtonViewType:"

        const val DigitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent"
        const val DigitalWalletButtonClickedEventHandlerKey = "digitalWalletButtonClickedEvent"

        // Method Call Keys
        const val ConfigureMethodKey = "configure"
        const val GetPaymentDataMethodKey = "getPaymentData"
        const val RefreshUiMethod = "refreshUI"

        // Method Call Parameter Keys
        const val DigitalWalletErrorMessageParameterKey = "errorMessage"
        const val DigitalWalletErrorCode = "digitalWalletErrorCode"
        const val DigitalWalletTypeParameterKey = "digitalWalletType"
        const val DigitalWalletTypeParameterValue = "googlePay"
        const val DigitalWalletReadyParameterKey = "isReady"
        const val EnabledParameterKey = "enabled"
        const val CreationParameters = "creationParams"

        // Google Pay Button Configuration Keys
        const val GooglePayButtonThemeKey = "GooglePayButtonTheme"
        const val GooglePayButtonTypeKey = "GooglePayButtonType"
        const val GooglePayButtonCornerRadiusKey = "GooglePayButtonCornerRadius"
        const val GooglePayButtonThemeDark = "dark"
        const val GooglePayButtonTypeCheckout = "checkout"

        // Google Pay Initialization Keys
        const val GPayProductionEnvironmentKey = "googlePayProductionEnvironment"
        const val GPayAllowedCardNetworksKey = "allowedCardNetworks"
        const val GPayCurrencyMultiplierKey = "googlePayCurrencyMultiplier"
        const val GPayCountryCodeKey = "countryCode"
        const val GPayGatewayParametersJsonKey = "googlePayGatewayParametersJson"
        const val GPayExistingPaymentMethodRequiredKey = "existingPaymentMethodRequired"
        const val GPayEmailRequiredKey = "emailRequired"
        const val GPayPhoneNumberRequiredKey = "phoneNumberRequired"
        const val GPayFullNameRequiredKey = "fullNameRequired"
        const val GPayCompanyNameKey = "companyLabel"
        const val GPayFullBillingAddressRequiredKey = "fullBillingAddressRequired"
        const val GPayCurrencyCodeKey = "currencyCode"
        const val GPayAmountKey = "amount"
        const val GPayCheckoutStatusKey = "googlePayCheckoutStatus"
        const val GPayTotalPriceLabelKey = "totalPriceLabel"
        const val GPayLineItemsKey = "lineItems"
        const val GPayValidateLineItems = "validateLineItems"

        // Line Item Keys
        const val LineItemLabelKey = "lineItemLabel"
        const val LineItemAmountKey = "lineItemAmount"
        const val LineItemTypeKey = "lineItemType"
        const val LineItemStatusKey = "lineItemStatus"

        // Payment Data Keys
        const val TokenKey = "token"
        const val DescriptionKey = "description"
        const val CardTypeKey = "cardType"
        const val OloCardTypeDescriptionKey = "oloCardTypeDescription"
        const val CardDetailsKey = "cardDetails"
        const val LastFourKey = "lastFour"
        const val BillingAddressKey = "billingAddress"
        const val EmailKey = "email"
        const val FullNameKey = "fullName"
        const val PhoneNumberKey = "phoneNumber"

        // Address Keys
        const val Address1Key = "address1"
        const val Address2Key = "address2"
        const val Address3Key = "address3"
        const val LocalityKey = "locality"
        const val AdministrativeAreaKey = "administrativeArea"
        const val SortingCodeKey = "sortingCode"
        const val PostalCodeKey = "postalCode"
        const val CountryCodeKey = "countryCode"

        // Normalized Card Types From Dart
        const val CardTypeAmericanExpress = "americanexpress"
        const val CardTypeDiscover = "discover"
        const val CardTypeMasterCard = "mastercard"
        const val CardTypeVisa = "visa"
        const val CardTypeJcb = "jcb"
        const val CardTypeInterac = "interac"
    }
}