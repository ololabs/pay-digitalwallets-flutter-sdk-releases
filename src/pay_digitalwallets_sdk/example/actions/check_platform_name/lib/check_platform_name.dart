// Copyright © 2025 Olo Inc. All rights reserved.
// This software is made available under the MIT License (See LICENSE file)
import 'package:check_platform_name/check_platform_name.dart';
import 'package:fluttium/fluttium.dart';

export 'src/check_platform_name.dart';

/// Will be executed by Fluttium on startup.
void register(Registry registry) {
  registry.registerAction('checkPlatformName', CheckPlatformName.new);
}
