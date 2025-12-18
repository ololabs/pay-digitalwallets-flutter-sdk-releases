// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import Flutter
import PassKit
import OloDigitalWalletsSDK
import UIKit

public class PayDigitalWalletsSdkPlugin: NSObject, FlutterPlugin, ODWApplePayLauncherDelegate {
    private let _applePayConfiguredSemaphore = DispatchSemaphore(value: 1)
    private let _applePaySemaphore = DispatchSemaphore(value: 1)
    
    private var _applePayLauncher: ODWApplePayLauncher = ODWApplePayLauncher()
    private var _applePayPaymentData: ODWPaymentDataProtocol? = nil
    
    private var _hasEmittedDigitalWalletReadyEvent = false
    
    private static var _methodChannel: FlutterMethodChannel? = nil
    
    //NOTE: Not private for testing purposes
    internal var _applePayResult: FlutterResult? = nil
    internal var _isUnitTestMode: Bool = false
    
    // WARNING: NEVER ACCESS/MODIFY THESE VARIABLE DIRECTLY. USE THREAD-SAFE GETTERS AND SETTERS
    private var _applePayConfig: ODWConfiguration? = nil
    
    var applePayConfig: ODWConfiguration? {
        get {
            return controlledReturn(with: _applePayConfiguredSemaphore) {
                return self._applePayConfig
            }
        }
        
        set(newValue) {
            let previousReadyState = applePayReady
            
            controlledExecute(with: _applePayConfiguredSemaphore) {
                self._applePayConfig = newValue
                self._applePayLauncher.configuration = newValue
            }
            
            self.emitDigitalWalletReadyEvent(previousReadyState)
        }
    }
    
    var applePayConfigured: Bool {
        get { applePayConfig != nil }
    }
    
    var applePayReady: Bool {
        get {
            return applePayConfigured && _applePayLauncher.canMakePayments()
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: DataKeys.DigitalWalletMethodChannelKey, binaryMessenger: registrar.messenger())
        let instance = PayDigitalWalletsSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Store the channel reference so events can be emitted
        PayDigitalWalletsSdkPlugin._methodChannel = channel
        
        let messenger = registrar.messenger()
        registrar.register(
            ApplePayButtonFactory(messenger: messenger),
            withId: DataKeys.DigitalWalletButtonViewKey
        )
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case DataKeys.ConfigureMethodKey:
            configure(call: call, result: result)
        case DataKeys.GetPaymentDataMethodKey:
            getPaymentData(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func configure(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let baseError = "Unable to configure Apple Pay"
        
        _applePayLauncher.delegate = self
        
        dispatchToBackgroundThread(with: _applePaySemaphore) {
            self.applePayConfig = nil
            
            guard let newConfiguration = self.getApplePayConfig(
                args: call.arguments as? Dictionary<String, Any>,
                result: result,
                baseError: baseError
            ) else {
                return
            }
            
            self.applePayConfig = newConfiguration
            result(nil)
        }
    }
    
    internal func getApplePayConfig(
        args: [String : Any?]?,
        result: @escaping FlutterResult,
        baseError: String
    ) -> ODWConfiguration? {
        do {
            guard let applePayArgs = args else {
                let message = "\(baseError): Missing parameter '\(DataKeys.ApplePayMerchantIdParameterKey)'"
                result(FlutterError(code: ErrorCodes.MissingParameter, message: message, details: nil))
                return nil
            }
            
            let merchantId = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.ApplePayMerchantIdParameterKey,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result
            )
            
            guard merchantId.isEmpty == false else {
                let message = "\(baseError): Value for '\(DataKeys.ApplePayMerchantIdParameterKey)' cannot be empty"
                result(FlutterError(code: ErrorCodes.EmptyMerchantId, message: message, details: nil))
                return nil
            }
            
            let companyLabel = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.ApplePayCompanyLabelParameterKey,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result
            )
            
            guard companyLabel.isEmpty == false else {
                let message = "\(baseError): Value for '\(DataKeys.ApplePayCompanyLabelParameterKey)' cannot be empty"
                result(FlutterError(code: ErrorCodes.EmptyCompanyLabel, message: message, details: nil))
                return nil
            }
            
            let currencyCode = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.DigitalWalletCurrencyCodeParameterKey,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result
            )
            
            guard currencyCode.count == PayDigitalWalletsSdkPlugin.validCurrencyCodeLength else {
                let message = "\(baseError): Value for '\(DataKeys.DigitalWalletCurrencyCodeParameterKey)' must be \(PayDigitalWalletsSdkPlugin.validCurrencyCodeLength) characters long"
                result(FlutterError(code: ErrorCodes.InvalidCurrencyCode, message: message, details: nil))
                return nil
            }
            
            let countryCode = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.DigitalWalletCountryCodeParameterKey,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result
            )
            
            guard countryCode.count == PayDigitalWalletsSdkPlugin.validCountryCodeLength else {
                let message = "\(baseError): Value for '\(DataKeys.DigitalWalletCountryCodeParameterKey)' must be \(PayDigitalWalletsSdkPlugin.validCountryCodeLength) characters long"
                result(FlutterError(code: ErrorCodes.InvalidCountryCode, message: message, details: nil))
                return nil
            }
            
            let fullBillingAddressRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletFullBillingAddressRequired,
                withDefault: PayDigitalWalletsSdkPlugin.defaultFullBillingAddressRequired,
                baseError: baseError,
                result: result
            )
            
            let phoneNumberRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletPhoneNumberRequired,
                withDefault: PayDigitalWalletsSdkPlugin.defaultPhoneNumberRequired,
                baseError: baseError,
                result: result
            )
            
            let fullNameRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletFullNameRequired,
                withDefault: PayDigitalWalletsSdkPlugin.defaultFullNameRequired,
                baseError: baseError,
                result: result
            )
            
            let fullPhoneticNameRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletFullPhoneticNameRequired,
                withDefault: PayDigitalWalletsSdkPlugin.defaultFullPhoneticNameRequired,
                baseError: baseError,
                result: result
            )
            
            let emailRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletEmailRequired,
                withDefault: PayDigitalWalletsSdkPlugin.defaultEmailRequired,
                baseError: baseError,
                result: result
            )
            
            let allowedCardNetworkStrings: [String] = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletAllowedCardNetworksParameterKey,
                withDefault: PayDigitalWalletsSdkPlugin.defaultAllowedCardNetworks,
                baseError: baseError,
                result: result
            )
            
            let allowedCardNetworks = PKPaymentNetwork.convert(allowedCardNetworkStrings)
            
            if (allowedCardNetworks.isEmpty) {
                result(FlutterError(
                    code: ErrorCodes.NoAllowedPaymentNetworks,
                    message: "\(baseError): '\(DataKeys.DigitalWalletAllowedCardNetworksParameterKey)' must contain at least one valid card network for Apple Pay",
                    details: nil
                ))
                return nil
            }
            
            return ODWConfiguration(
                merchantId: merchantId,
                companyLabel: companyLabel,
                currencyCode: currencyCode,
                countryCode: countryCode,
                emailRequired: emailRequired,
                phoneNumberRequired: phoneNumberRequired,
                fullNameRequired: fullNameRequired,
                fullPhoneticNameRequired: fullPhoneticNameRequired,
                fullBillingAddressRequired: fullBillingAddressRequired,
                allowedCardNetworks: allowedCardNetworks
            )
        } catch {
            return nil
        }
    }
    
    private func getPaymentData(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let baseError = "Unable to get payment data"
        
        guard applePayConfigured else {
            let error = "\(baseError): Apple Pay has not been configured"
            result(FlutterError(code: ErrorCodes.SdkNotConfigured, message: error, details: nil))
            return
        }
        
        guard let args = call.arguments as? Dictionary<String, Any> else {
            let message = "\(baseError): Missing parameter \(DataKeys.DigitalWalletAmountParameterKey)"
            
            result(FlutterError(
                code: ErrorCodes.MissingParameter,
                message: message,
                details: nil
            ))
            return
        }
        
        dispatchToQos(on: .userInteractive, with: _applePaySemaphore, autoRelease: false) {
            var amount: NSDecimalNumber
            var validateLineItems: Bool
            var lineItems: [PKPaymentSummaryItem]? = nil
            do {
                let amountString = try args.getStringOrErrorResult(
                    for: DataKeys.DigitalWalletAmountParameterKey,
                    baseError: baseError,
                    acceptEmptyValue: false,
                    result: result
                )
                
                guard amountString.isValidDecimalNumber() else {
                    let error = "\(baseError): Value for '\(DataKeys.DigitalWalletAmountParameterKey)' is not a valid number"
                    result(FlutterError(code: ErrorCodes.InvalidParameter, message: error, details: nil))
                    self.applePayCleanup()
                    return
                }
                
                amount = NSDecimalNumber(string: amountString)
                
                validateLineItems = try args.getOrErrorResult(
                    for: DataKeys.DigitalWalletValidateLineItemsKey,
                    baseError: baseError,
                    result: result
                )
                
                lineItems = try self.getLineItemsFromFlutterArgs(
                    args: args,
                    baseError: baseError,
                    result: result
                )
            } catch {
                self.applePayCleanup()
                return
            }
            
            guard amount.doubleValue >= 0 else {
                let error = "\(baseError): Value for '\(DataKeys.DigitalWalletAmountParameterKey)' cannot be negative"
                result(FlutterError(code: ErrorCodes.InvalidParameter, message: error, details: nil))
                self.applePayCleanup()
                return
            }
            
            // NOTE: This canMakePayments() check is moved here so we can
            //       test the logic around parameters passed into this call.
            //       We cannot write unit tests for anything beyond this point.
            guard self.applePayReady else {
                let error = "\(baseError): Apple Pay is not ready"
                result(FlutterError(code: ErrorCodes.DigitalWalletNotReady, message: error, details: nil))
                self.applePayCleanup()
                return
            }
            
            guard !self._isUnitTestMode else {
                let error = "Apple Pay is not supported in unit test mode"
                result(FlutterError(code: "ApplePayUnitTestModeError", message: error, details: nil))
                self.applePayCleanup()
                return
            }
            
            var errorMessage: String
            var errorCode: String = ""
            do {
                try self._applePayLauncher.present(forAmount: amount, with: lineItems ?? [], validateLineItems: validateLineItems, completion: nil)
                self._applePayResult = result
                return
            } catch ODWApplePayLauncherError.applePayNotSupported {
                errorCode = ErrorCodes.ApplePayUnsupported
                errorMessage = "Apple Pay is not supported on this device"
            } catch ODWApplePayLauncherError.configurationNotSet {
                errorCode = ErrorCodes.SdkNotConfigured
                errorMessage = "Apple Pay has not been configured"
            } catch ODWApplePayLauncherError.delegateNotSet {
                errorCode = ErrorCodes.SdkNotConfigured
                errorMessage = "Apple Pay has not been configured"
            } catch ODWApplePayLauncherError.emptyMerchantId {
                errorCode = ErrorCodes.UnexpectedError
                errorMessage = "Merchant ID cannot be empty"
            } catch ODWApplePayLauncherError.emptyCompanyLabel {
                errorCode = ErrorCodes.UnexpectedError
                errorMessage = "Company label cannot be empty"
            } catch ODWApplePayLauncherError.invalidCountryCode {
                errorCode = ErrorCodes.UnexpectedError
                errorMessage = "Country code cannot be empty"
            } catch ODWApplePayLauncherError.lineItemTotalMismatch {
                errorCode = ErrorCodes.LineItemTotalMismatch
                errorMessage = "The total of the line items does not match the total amount"
            } catch {
                errorCode = ErrorCodes.GeneralError
                errorMessage = "Unexpected error occurred"
            }
            
            let errorData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: "\(baseError): \(errorMessage)",
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue,
                DataKeys.DigitalWalletErrorCodeKey: errorCode
            ]
            
            result(errorData)
            self.applePayCleanup()
        }
    }
    
    private func getLineItemsFromFlutterArgs(
        args: [String : Any],
        baseError: String,
        result: @escaping FlutterResult
    ) throws -> [PKPaymentSummaryItem]? {
        do {
            var lineItems: [PKPaymentSummaryItem]? = nil
            if let flutterLineItems: [Dictionary<String, Any?>] = try args.getOrErrorResult(
                for: DataKeys.DigitalWalletLineItemsKey,
                withDefault: nil,
                baseError: baseError,
                result: result
            ), !flutterLineItems.isEmpty {
                lineItems = []
                try flutterLineItems.forEach { item in
                    let itemAmountString: String = try item.getStringOrErrorResult(
                        for: DataKeys.DigitalWalletLineItemAmountKey,
                        baseError: baseError,
                        acceptEmptyValue: false,
                        result: result
                    )
                    
                    guard  itemAmountString.isValidDecimalNumber() else {
                        result(FlutterError(
                            code: ErrorCodes.InvalidParameter,
                            message: "\(baseError): Value for '\(DataKeys.DigitalWalletLineItemAmountKey)' is not a valid number",
                            details: nil
                        ))
                        throw OloError.UnexpectedTypeError
                    }
                    
                    let itemAmount = NSDecimalNumber(string: itemAmountString)
                    
                    lineItems!.append(
                        PKPaymentSummaryItem(
                            label: try item.getStringOrErrorResult(
                                for: DataKeys.DigitalWalletLineItemLabelKey,
                                baseError: baseError,
                                acceptEmptyValue: false,
                                result: result
                            ),
                            amount: itemAmount,
                            type: try item.getStringOrErrorResult(
                                for: DataKeys.DigitalWalletLineItemStatusKey,
                                withDefault: DataKeys.DigitalWalletLineItemFinalStatusKey,
                                baseError: baseError,
                                acceptEmptyValue: true,
                                result: result
                            ) == DataKeys.DigitalWalletLineItemFinalStatusKey ? .final : .pending
                        )
                    )
                }
            }
            return lineItems
        } catch let error {
            throw error
        }
    }
    
    private func applePayCleanup() {
        _applePayPaymentData = nil
        _applePayResult = nil
        _applePaySemaphore.signal()
    }
    
    private func emitDigitalWalletReadyEvent(_ previousState: Bool) {
        let newState = self.applePayReady
        
        // Filter out redundant emitting of this event if the actual state value hasn't changed, but only if it is not
        // the first time the event has been emitted
        if _hasEmittedDigitalWalletReadyEvent && newState == previousState {
            return
        }
        
        _hasEmittedDigitalWalletReadyEvent = true
        dispatchToMainThread {
            PayDigitalWalletsSdkPlugin._methodChannel?.invokeMethod(
                DataKeys.DigitalWalletReadyEventHandlerKey,
                arguments: [DataKeys.DigitalWalletReadyParameterKey: newState]
            )
        }
    }
    
    public func applePaymentCreated(_ launcher: any OloDigitalWalletsSDK.ODWApplePayLauncherProtocol, _ payment: any OloDigitalWalletsSDK.ODWPaymentDataProtocol) -> NSError? {
        guard _applePayResult != nil else {
            return NSError(domain: "PayDigitalWalletsSdk", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Unexpected error: Saved method call resolver is nil"
            ])
        }
        
        _applePayPaymentData = payment
        
        // NOTE: This will trigger a success flow in the Apple Pay Sheet
        return nil
    }
    
    public func applePaymentCompleted(_ launcher: any OloDigitalWalletsSDK.ODWApplePayLauncherProtocol, _ status: OloDigitalWalletsSDK.ODWPaymentStatus, error: (any Error)?) {
        guard let applePayResult = _applePayResult else {
            // If there is no saved resolver there is nothing to be done except return
            applePayCleanup()
            return
        }
        
        // Nil data means the user canceled, so let's initialize to that, and update applePayData for all other
        // scenarios
        var applePayData: Dictionary<String, Any>? = nil
        
        if status == .error {
            var errorMessage = "An unexpected error occurred"
            if error != nil && error as? ODWApplePayLauncherError != ODWApplePayLauncherError.applePayNotSupported {
                errorMessage = error!.localizedDescription
            }
            
            applePayData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: errorMessage,
                DataKeys.DigitalWalletErrorCodeKey: ErrorCodes.GeneralError,
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue
            ]
        } else if status == .success && _applePayPaymentData == nil {
            applePayData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: "Unexpected error: Payment data is nil",
                DataKeys.DigitalWalletErrorCodeKey: ErrorCodes.GeneralError,
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue
            ]
        } else if status == .success && _applePayPaymentData != nil {
            applePayData = _applePayPaymentData!.toDictionary()
        }
        
        applePayCleanup()
        applePayResult(applePayData)
    }
    
    // Default values
    private static let defaultProductionEnvironment = true
    private static let defaultFullBillingAddressRequired = false
    private static let defaultPhoneNumberRequired = false
    private static let defaultFullNameRequired = false
    private static let defaultFullPhoneticNameRequired = false
    private static let defaultEmailRequired = false
    private static let defaultAllowedCardNetworks: [String] = []
    
    private static let validCountryCodeLength = 2
    private static let validCurrencyCodeLength = 3
}
