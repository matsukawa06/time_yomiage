import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_yomiage/common/shared_preferences.dart';

///
/// テーマ変更用の状態クラス
///
final themeController = ChangeNotifierProvider<ThemeController>(
  (ref) => ThemeController(),
);

class ThemeController extends ChangeNotifier {
  // SharedPreferences用のキー文字列
  final String _keyIsDark = 'isDark';
  // final String _keyMainColor = 'mainColor';

  // ダークモード関連
  ThemeMode mode = ThemeMode.light;
  bool isDark = false;

  // コンストラクタ
  ThemeController() {
    _getShaed();
  }

  // 端末保存情報の取得
  Future _getShaed() async {
    var prefs = await SharedPreferences.getInstance();
    // ダークモード
    isDark = prefs.getBool(_keyIsDark) ?? false;
    _lightOrDarkSetting();
    notifyListeners();
  }

  // トグルでダークモードを切り替える関数を定義する
  brightnessToggle() {
    isDark = !isDark;
    _lightOrDarkSetting();
    // SharedPreferencesに保存
    Shared().saveBoolValue(_keyIsDark, isDark);
    notifyListeners();
  }

  // ダークモードでの設定内容
  _lightOrDarkSetting() {
    mode = isDark ? ThemeMode.dark : ThemeMode.light;
    // fontColor = isDark ? Colors.white : Colors.black;
  }
}
