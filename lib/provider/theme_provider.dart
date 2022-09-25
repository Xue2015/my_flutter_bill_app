import 'package:flutter/material.dart';
import 'package:flutter_bill_app/db/hi_cache.dart';
import 'package:flutter_bill_app/util/color.dart';
import 'package:flutter_bill_app/util/hi_constants.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;

  ThemeMode getThemeMode() {
    String theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }

    return _themeMode!;
  }

  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
      primaryColor: isDarkMode ? HiColor.dark_bg : white,
      accentColor: isDarkMode ? primary[50] : white,
      indicatorColor: isDarkMode ? primary[50] : white,
      scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white,
    );
    return themeData;
  }
}
