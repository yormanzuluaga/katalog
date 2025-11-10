import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentpitch_test/core/database/db.dart';
import 'package:talentpitch_test/core/helper/preferences_helper.dart';

class LoginStore {
  LoginStore._internal();

  static final LoginStore _instance = LoginStore._internal();

  static LoginStore get instance => _instance;
  int _currentStore = 0;
  String _accessToken = "";
  String _refreshToken = "";
  String _dataPendingJoinTeam = "";
  String _firebaseToken = "";

  int get currentStore => _currentStore;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  String get dataPendingJoinTeam => _dataPendingJoinTeam;

  String get firebaseToken => _firebaseToken;

  final SharedPreferences _sharedPreferences = DB.instance.prefs;

  Future<void> init() async {
    _currentStore = _sharedPreferences.getInt(PreferencesHelper.currentStore) ?? 0;
    _accessToken = _sharedPreferences.getString(PreferencesHelper.token) ?? "";
    _refreshToken = _sharedPreferences.getString(PreferencesHelper.refreshToken) ?? "";
    _dataPendingJoinTeam = _sharedPreferences.getString(PreferencesHelper.dataPendingJoinTeam) ?? "";
    _firebaseToken = _sharedPreferences.getString(PreferencesHelper.firebaseToken) ?? "";
  }

  Future<void> logOutSession() async {
    _currentStore = 0;
    await _sharedPreferences.setInt(PreferencesHelper.currentStore, 0);
    _accessToken = "";
    await _sharedPreferences.setString(PreferencesHelper.token, "");
    _refreshToken = "";
    await _sharedPreferences.setString(PreferencesHelper.refreshToken, "");
    _dataPendingJoinTeam = "";
    await _sharedPreferences.setString(PreferencesHelper.dataPendingJoinTeam, "");
    _firebaseToken = "";
    await _sharedPreferences.setString(PreferencesHelper.firebaseToken, "");
    await _sharedPreferences.setInt(PreferencesHelper.scannerDelay, 1000);
    await _sharedPreferences.setBool(PreferencesHelper.isWelcomePackOpenedInDevice, false);
  }

  Future<void> logInSession({required int currentStore, required String accessToken, required String refreshToken}) async {
    _currentStore = currentStore;
    await _sharedPreferences.setInt(PreferencesHelper.currentStore, currentStore);
    _accessToken = accessToken;
    await _sharedPreferences.setString(PreferencesHelper.token, accessToken);
    _refreshToken = refreshToken;
    await _sharedPreferences.setString(PreferencesHelper.refreshToken, refreshToken);
  }

  Future<void> setFirebaseToken(String firebaseToken) async {
    _firebaseToken = firebaseToken;
    await _sharedPreferences.setString(PreferencesHelper.firebaseToken, firebaseToken);
  }

  Future<void> setAccessToken(String accessToken) async {
    await removerAccessToken();
    _accessToken = accessToken;
    await _sharedPreferences.setString(PreferencesHelper.token, accessToken);
  }

  Future<void> setRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    await _sharedPreferences.setString(PreferencesHelper.refreshToken, refreshToken);
  }

  Future<void> setDataPendingJoinTeam(String dataPendingJoinTeam) async {
    _dataPendingJoinTeam = dataPendingJoinTeam;
    await _sharedPreferences.setString(PreferencesHelper.dataPendingJoinTeam, dataPendingJoinTeam);
  }

  Future<void> removeDataPendingJoinTeam() async {
    _dataPendingJoinTeam = '';
    await _sharedPreferences.remove(PreferencesHelper.dataPendingJoinTeam);
  }

  Future<void> removerAccessToken() async {
    _accessToken = '';
    await _sharedPreferences.remove(PreferencesHelper.token);
  }
}
