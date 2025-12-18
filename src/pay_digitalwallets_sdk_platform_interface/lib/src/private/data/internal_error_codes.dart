// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
// Note: Error codes coming from the native platform that should NEVER occur
// due to how the Flutter language works. If we do get these errors, it is a
// bug in our SDK bridge code.
class InternalErrorCodes {
  static const missingParameter = "MissingParameter";
  static const unexpectedParameterType = "UnexpectedParameterType";

  static const all = {missingParameter, unexpectedParameterType};
}
