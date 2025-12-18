# iOS Native Tests

This directory contains native iOS tests for the pay_digitalwallets_sdk plugin.

## Setup (One-Time)

To run these tests in Xcode, you need to add a test target to the Runner project:

1. Open `Runner.xcworkspace` in Xcode
2. Select the Runner project in the navigator
3. Click the **+** button at the bottom of the targets list
4. Select **iOS** → **Unit Testing Bundle**
5. Name it `RunnerTests`
6. Set the target to be tested: `Runner`
7. Click **Finish**

8. Add test files to the target:
   - In the project navigator, select `RunnerTests` folder
   - Drag the `.swift` test files into the RunnerTests group
   - Make sure they're added to the `RunnerTests` target (check the target membership in the file inspector)

9. Configure the test target:
   - Select the `RunnerTests` target
   - Go to **Build Settings**
   - Search for "Defines Module" and set it to **Yes**

10. Run pod install to update dependencies:
    ```bash
    cd example/ios
    pod install
    ```

## Running Tests

- In Xcode: Select the `RunnerTests` scheme and press **Cmd+U**
- Command line: `xcodebuild test -workspace Runner.xcworkspace -scheme RunnerTests -destination 'platform=iOS Simulator,name=iPhone 14'`

## Test Files

- `PayDigitalWalletsSdkPluginTests.swift` - Tests for plugin configuration (`getApplePayConfig`)
- `PKPaymentNetworkExtensionsTests.swift` - Tests for payment network conversion logic
