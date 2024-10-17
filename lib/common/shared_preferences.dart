import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_yomiage/common/common_const.dart';

///
/// SharedPreferencesを使用する共通クラス
///
class Shared {
  ///
  /// ローカル設定を保存する
  ///
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

  ///
  /// ローカル設定を取得する
  ///
  Future<dynamic> getValue(String key, TypeValue type) async {
    var prefs = await SharedPreferences.getInstance();
    dynamic retValue;
    switch (type) {
      case TypeValue.int:
        retValue = prefs.getInt(key);
      case TypeValue.double:
        retValue = prefs.getDouble(key);
      case TypeValue.string:
        retValue = prefs.getString(key);
      case TypeValue.bool:
        retValue = prefs.getBool(key);
    }

    return retValue;
  }
}
