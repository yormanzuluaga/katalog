import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentpitch_test/core/database/db.dart';
import 'package:talentpitch_test/core/helper/preferences_helper_user.dart';

class PlayListStore {
  PlayListStore._internal();

  static final PlayListStore _instance = PlayListStore._internal();

  static PlayListStore get instance => _instance;

  String _playList = '';

  String get playList => _playList;

  final SharedPreferences _sharedPreferences = DB.instance.prefs;

  Future<void> init() async {
    _playList = _sharedPreferences.getString(PreferencesHelperUser.playList) ?? '';
  }

  Future<void> savedPlayLaist({
    required String playList,
  }) async {
    await _sharedPreferences.remove(PreferencesHelperUser.playList);
    _playList = playList;
    await _sharedPreferences.setString(PreferencesHelperUser.playList, playList);
  }

  Future<void> removerPlayLaist() async {
    _playList = '';
    await _sharedPreferences.setString(PreferencesHelperUser.playList, "");
  }
}
