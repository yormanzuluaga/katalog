import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talentpitch_test/app/routes/router_config.dart';
import 'package:talentpitch_test/app/routes/routes_names.dart';
import 'package:talentpitch_test/core/database/db.dart';
import 'package:talentpitch_test/core/helper/preferences_helper_user.dart';

class UserStore {
  UserStore._internal();

  static final UserStore _instance = UserStore._internal();

  static UserStore get instance => _instance;

  String _uid = '';
  String _userName = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _country = '';
  String _mobile = '';
  String _accessStore = "";
  String _avatar = '';
  String _city = '';
  String _collaborator = '';
  String _createdAt = '';
  String _updatedAt = '';

  String _user = '';

  String get uid => _uid;
  String get userName => _userName;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get country => _country;
  String get mobile => _mobile;
  String get avatar => _avatar;
  String get city => _city;
  String get collaborator => _collaborator;
  String get createdAt => _createdAt;
  String get accessStore => _accessStore;

  String get updatedAt => _updatedAt;

  String get user => _user;

  final SharedPreferences _sharedPreferences = DB.instance.prefs;

  Future<void> init() async {
    _uid = _sharedPreferences.getString(PreferencesHelperUser.uid) ?? '';
    _userName =
        _sharedPreferences.getString(PreferencesHelperUser.userName) ?? '';
    _firstName =
        _sharedPreferences.getString(PreferencesHelperUser.firstName) ?? '';
    _lastName =
        _sharedPreferences.getString(PreferencesHelperUser.lastName) ?? "";
    _email = _sharedPreferences.getString(PreferencesHelperUser.email) ?? "";
    _accessStore =
        _sharedPreferences.getString(PreferencesHelperUser.accessStore) ?? "";

    _country =
        _sharedPreferences.getString(PreferencesHelperUser.country) ?? "";
    _mobile = _sharedPreferences.getString(PreferencesHelperUser.mobile) ?? "";

    _avatar = _sharedPreferences.getString(PreferencesHelperUser.avatar) ?? "";
    _city = _sharedPreferences.getString(PreferencesHelperUser.city) ?? '';
    _collaborator =
        _sharedPreferences.getString(PreferencesHelperUser.collaborator) ?? "";
    _createdAt =
        _sharedPreferences.getString(PreferencesHelperUser.createdAt) ?? '';
    _updatedAt =
        _sharedPreferences.getString(PreferencesHelperUser.updatedAt) ?? '';

    _user = _sharedPreferences.getString(PreferencesHelperUser.user) ?? '';
  }

  Future<void> logInSession({
    required String uid,
    required String userName,
    required String firstName,
    required String lastName,
    required String email,
    required String accessStore,
    required String country,
    required String mobile,
    required String avatar,
    required String city,
    required String collaborator,
    required String createdAt,
    required String updatedAt,
  }) async {
    await _sharedPreferences.remove(PreferencesHelperUser.uid);
    _uid = uid;
    await _sharedPreferences.setString(PreferencesHelperUser.uid, uid);

    await _sharedPreferences.remove(PreferencesHelperUser.userName);
    _userName = userName;
    await _sharedPreferences.setString(
        PreferencesHelperUser.userName, userName);
    await _sharedPreferences.remove(PreferencesHelperUser.firstName);
    _firstName = firstName;
    await _sharedPreferences.setString(
        PreferencesHelperUser.firstName, firstName);
    await _sharedPreferences.remove(PreferencesHelperUser.lastName);
    _lastName = lastName;
    await _sharedPreferences.setString(
        PreferencesHelperUser.lastName, lastName);
    await _sharedPreferences.remove(PreferencesHelperUser.mobile);
    _mobile = mobile;
    await _sharedPreferences.setString(PreferencesHelperUser.mobile, mobile);
    await _sharedPreferences.remove(PreferencesHelperUser.email);
    _email = email;
    await _sharedPreferences.setString(PreferencesHelperUser.email, email);
    await _sharedPreferences.remove(PreferencesHelperUser.country);

    _country = country;
    await _sharedPreferences.setString(PreferencesHelperUser.country, country);
    await _sharedPreferences.remove(PreferencesHelperUser.accessStore);

    _accessStore = accessStore;
    await _sharedPreferences.setString(
        PreferencesHelperUser.accessStore, accessStore);
    await _sharedPreferences.remove(PreferencesHelperUser.avatar);

    _avatar = avatar;
    await _sharedPreferences.setString(PreferencesHelperUser.avatar, avatar);
    await _sharedPreferences.remove(PreferencesHelperUser.collaborator);

    _collaborator = collaborator;
    await _sharedPreferences.setString(
        PreferencesHelperUser.collaborator, collaborator);
    await _sharedPreferences.remove(PreferencesHelperUser.city);

    _city = city;
    await _sharedPreferences.setString(PreferencesHelperUser.city, city);
    await _sharedPreferences.remove(PreferencesHelperUser.createdAt);

    _createdAt = createdAt;
    await _sharedPreferences.setString(
        PreferencesHelperUser.createdAt, createdAt);
    await _sharedPreferences.remove(PreferencesHelperUser.updatedAt);
    _updatedAt = updatedAt;
    await _sharedPreferences.setString(
        PreferencesHelperUser.updatedAt, updatedAt);
  }

  Future<void> logOutSession() async {
    _uid = '';
    await _sharedPreferences.setString(PreferencesHelperUser.uid, "");
    _userName = '';
    await _sharedPreferences.setString(PreferencesHelperUser.userName, "");
    _firstName = '';
    await _sharedPreferences.setString(PreferencesHelperUser.firstName, "");

    _lastName = '';
    await _sharedPreferences.setString(PreferencesHelperUser.lastName, "");

    _email = '';
    await _sharedPreferences.setString(PreferencesHelperUser.email, "");

    _accessStore = '';
    await _sharedPreferences.setString(PreferencesHelperUser.accessStore, "");

    _country = '';
    await _sharedPreferences.setString(PreferencesHelperUser.country, "");

    _mobile = '';
    await _sharedPreferences.setString(PreferencesHelperUser.mobile, "");

    _avatar = '';
    await _sharedPreferences.setString(PreferencesHelperUser.avatar, "");

    _city = '';
    await _sharedPreferences.setString(PreferencesHelperUser.city, "");

    _collaborator = '';
    await _sharedPreferences.setString(PreferencesHelperUser.collaborator, "");

    _createdAt = '';
    await _sharedPreferences.setString(PreferencesHelperUser.createdAt, "");

    _updatedAt = '';
    await _sharedPreferences.setString(PreferencesHelperUser.updatedAt, "");
  }

  Future<void> setUser({required String user}) async {
    await deleteUser();
    _user = user;
    await _sharedPreferences.setString(PreferencesHelperUser.user, user);
  }

  Future<void> outUser() async {
    _user = '';
    await _sharedPreferences.setString(PreferencesHelperUser.user, '');
    rootNavigatorKey.currentContext!.go(RoutesNames.login);
  }

  Future<void> deleteUser() async {
    await _sharedPreferences.remove(PreferencesHelperUser.user);
  }

  Future<void> updateUserInfo({
    String? firstName,
    String? lastName,
    String? mobile,
  }) async {
    if (firstName != null) {
      _firstName = firstName;
      await _sharedPreferences.setString(
          PreferencesHelperUser.firstName, firstName);
    }

    if (lastName != null) {
      _lastName = lastName;
      await _sharedPreferences.setString(
          PreferencesHelperUser.lastName, lastName);
    }

    if (mobile != null) {
      _mobile = mobile;
      await _sharedPreferences.setString(PreferencesHelperUser.mobile, mobile);
    }
  }
}
