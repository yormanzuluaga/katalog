import 'package:shared_preferences/shared_preferences.dart';

class DB {
  DB._internal();
  static final DB _instance = DB._internal();
  static DB get instance => _instance;

  late SharedPreferences _sharedPreferences;
  SharedPreferences get prefs => _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}