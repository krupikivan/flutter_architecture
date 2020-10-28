import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  factory Preferences() {
    return _instancia;
  }

  Preferences._internal();

  SharedPreferences _prefs;

  static final Preferences _instancia = Preferences._internal();

  Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token
  String get token => _prefs.getString('token') ?? '';

  set token(String value) => _prefs.setString('token', value);

  // Id
  String get id => _prefs.getString('id') ?? '';

  set id(String value) => _prefs.setString('id', value);

  void clear() {
    _prefs.remove('id');
    _prefs.remove('token');
  }
}
