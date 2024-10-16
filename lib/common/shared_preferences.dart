import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_yomiage/common/common_const.dart';

///
/// SharedPreferencesを使用する共通クラス
///
class Shared {
  ///
  /// ローカル設定を保存する
  ///
  Future saveIntValue(String key, int value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future saveBoolValue(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future saveStringValue(String key, String value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future saveDoubleValue(String key, double value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  Future saveValue(String key, TypeValue type, var value) async {
    var prefs = await SharedPreferences.getInstance();
    switch (type) {
      case TypeValue.int:
        prefs.setInt(key, value);
      case TypeValue.double:
        prefs.setDouble(key, value);
      case TypeValue.string:
        prefs.setString(key, value);
      case TypeValue.bool:
        prefs.setBool(key, value);
      default:
    }
  }
}
