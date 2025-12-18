// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pay_digitalwallets_sdk_platform_interface/src/public/factories/platform_exception_factory.dart';

/// @nodoc
@protected
extension OloMethodChannel on MethodChannel {
  /// @nodoc
  Future<Map<K, V>?> invokeOloMapMethod<K, V>(
    String method, [
    dynamic arguments,
  ]) async {
    try {
      return await invokeMapMethod(method, arguments);
    } on MissingPluginException catch (e) {
      throw PlatformExceptionFactory.createFromError(error: e);
    }
  }

  /// @nodoc
  Future<T?> invokeOloMethod<T>(String method, [dynamic arguments]) async {
    try {
      return await invokeMethod(method, arguments);
    } on MissingPluginException catch (e) {
      throw PlatformExceptionFactory.createFromError(error: e);
    }
  }
}
