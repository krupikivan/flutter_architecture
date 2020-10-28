import 'package:flutter/material.dart';
import 'package:flutter_architecture/views/style/theme/style.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData.light().copyWith(
      primaryColor: PrimaryColor,
      accentColor: AccentColor,
      backgroundColor: Colors.white,
    );
  }
}
