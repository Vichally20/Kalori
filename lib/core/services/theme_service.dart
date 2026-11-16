import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kalori/core/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart';

/// Light / dark / follow-the-phone appearance, stored on the device.
///
/// Keeps the static [KaloriColors] palette in step with the theme Flutter shows,
/// and rebuilds the whole app when the effective brightness changes.
class ThemeService extends GetxService with WidgetsBindingObserver {
  static const String _fileName = 'kalori_settings.json';

  final Rx<ThemeMode> mode = ThemeMode.system.obs;

  /// Whether the dark palette is in use right now.
  bool get isDark {
    return switch (mode.value) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
    };
  }

  Future<ThemeService> init() async {
    final saved = await _read();
    mode.value = ThemeMode.values.firstWhere((m) => m.name == saved?['themeMode'], orElse: () => ThemeMode.system);
    _applyPalette();
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> setMode(ThemeMode value) async {
    if (value == mode.value) {
      return;
    }
    mode.value = value;
    _applyPalette();
    Get.changeThemeMode(value);
    await Get.forceAppUpdate();
    await _write(<String, dynamic>{'themeMode': value.name});
  }

  /// Follows the phone switching between light and dark while set to System.
  @override
  void didChangePlatformBrightness() {
    if (mode.value != ThemeMode.system) {
      return;
    }
    final wasDark = KaloriColors.isDark;
    _applyPalette();
    if (wasDark != KaloriColors.isDark) {
      Get.forceAppUpdate();
    }
  }

  void _applyPalette() {
    final dark = isDark;
    KaloriColors.use(dark ? KaloriPalette.dark : KaloriPalette.light);
    SystemChrome.setSystemUIOverlayStyle(
      (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: KaloriColors.surfaceContainerLowest,
        systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_fileName');
  }

  Future<Map<String, dynamic>?> _read() async {
    try {
      final file = await _file();
      if (!await file.exists()) {
        return null;
      }
      final decoded = jsonDecode(await file.readAsString());
      return decoded is Map<String, dynamic> ? decoded : null;
    } on Exception {
      return null;
    }
  }

  Future<void> _write(Map<String, dynamic> json) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(json), flush: true);
  }
}
