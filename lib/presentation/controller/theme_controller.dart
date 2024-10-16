import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_yomiage/common/common_const.dart';
import 'package:time_yomiage/common/shared_preferences.dart';
import 'package:time_yomiage/presentation/controller/tts_controller.dart';

///
/// テーマ変更用の状態クラス
///
final themeController = ChangeNotifierProvider<ThemeController>(
  (ref) => ThemeController(ref),
);

class ThemeController extends ChangeNotifier {
  // コンストラクタ
  ThemeController(this.ref) {
    _getShaed();
  }
  final Ref ref;

  // ダークモード関連
  ThemeMode mode = ThemeMode.light;
  bool isDark = false;
  // 読み上げ共通設定関連
  double volume = 1.0;
  double speechRate = 1.0;
  double pitch = 1.0;
  // List voiceName = [];

  // 端末保存情報の取得
  Future _getShaed() async {
    var prefs = await SharedPreferences.getInstance();
    // ダークモード
    isDark = prefs.getBool(keyIsDark) ?? false;
    _lightOrDarkSetting();

    // ボリューム
    var prefsVolume = prefs.getDouble(keyVolume);
    if (prefsVolume != null) {
      _volumeSetting(prefsVolume);
    }
    // 速度
    var prefsSpeechRate = prefs.getDouble(keySpeechRate);
    if (prefsSpeechRate != null) {
      _speechRateSetting(prefsSpeechRate);
    }
    // ピッチ
    var prefsPitch = prefs.getDouble(keyPitch);
    if (prefsPitch != null) {
      _pitchSetting(prefsPitch);
    }

    notifyListeners();
  }

  // トグルでダークモードを切り替える関数を定義する
  brightnessToggle() {
    isDark = !isDark;
    _lightOrDarkSetting();
    // SharedPreferencesに保存
    Shared().saveValue(keyIsDark, TypeValue.bool, isDark);
    notifyListeners();
  }

  // ダークモードでの設定内容
  _lightOrDarkSetting() {
    mode = isDark ? ThemeMode.dark : ThemeMode.light;
    // fontColor = isDark ? Colors.white : Colors.black;
  }

  // ボリュームスライダー変更
  changeVolumeSlider(double e) {
    _volumeSetting(e);
    Shared().saveValue(keyVolume, TypeValue.double, e);
    notifyListeners();
  }

  // ボリュームの設定変更
  _volumeSetting(double e) {
    ref.read(ttsController).changeVolume(e);
    volume = e;
  }

  // 速度スライダー変更
  changeSpeechRateSlider(double e) {
    _speechRateSetting(e);
    Shared().saveValue(keySpeechRate, TypeValue.double, e);
    notifyListeners();
  }

  // 速度の設定変更
  _speechRateSetting(double e) {
    ref.read(ttsController).changeSpeechRate(e);
    speechRate = e;
  }

  // ピッチスライダー変更
  changePitchSlider(double e) {
    _pitchSetting(e);
    Shared().saveValue(keyPitch, TypeValue.double, e);
    notifyListeners();
  }

  // ピッチの設定変更
  _pitchSetting(double e) {
    ref.read(ttsController).changePitch(e);
    pitch = e;
  }

  // // 声リスト作成
  // setVoicesList(FlutterTts e) async {
  //   List voices = await e.getVoices;
  //   for (var item in voices) {
  //     var map = item as Map<Object?, Object?>;
  //     if (map["locale"].toString().toLowerCase().contains("ja")) {
  //       voiceName.add(map["name"]);
  //     }
  //   }
  // }
}
