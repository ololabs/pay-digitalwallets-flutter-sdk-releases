# Olo Digital Wallets Flutter SDK

The Olo Digital Wallets Flutter SDK allows easily adding digital wallet payment options (currently Apple Pay & Google Pay) to an app's checkout flow.

**IMPORTANT:** The primary purpose of the SDK is to facilitate payments with Olo's ordering ecosystem. It _should_ work with any processor that accepts Apple Pay and Google Pay, but functionality outside of Olo's ordering ecosystem has not been tested and is not guaranteed.

## Documentation/Links

- **[Pub.dev Listing](https://pub.dev/packages/pay_digitalwallets_sdk)** - Setup, usage, and API reference
- **[Pub.dev Example](https://pub.dev/packages/pay_digitalwallets_sdk/example)** - Copy-pasteable example
- **[Olo Developer Portal Documentation](https://developer.olo.com/docs/load/digital-wallets)** - Requires an Olo Developer Account

## Packages

- **[pay_digitalwallets_sdk](./src/pay_digitalwallets_sdk)** - Main SDK package (start here)
- **[pay_digitalwallets_sdk_platform_interface](./src/pay_digitalwallets_sdk_platform_interface)** - Platform interface
- **[pay_digitalwallets_sdk_android](./src/pay_digitalwallets_sdk_android)** - Android implementation
- **[pay_digitalwallets_sdk_ios](./src/pay_digitalwallets_sdk_ios)** - iOS implementation

## License

MIT License - see [LICENSE](LICENSE) for details.
