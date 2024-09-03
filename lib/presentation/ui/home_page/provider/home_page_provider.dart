import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageProvider = ChangeNotifierProvider(
  (ref) => HomePageProvider(ref),
);

class HomePageProvider extends ChangeNotifier {
  HomePageProvider(this.ref);
  final Ref ref;

  bool isSpeechPlay = false;
  bool isSecondSwitch = true;
  int hourTimes = 1;
  double volume = 1.0;
  double speechRate = 1.0;
  double pitch = 1.0;
  // List voiceName = [];

  // 音声再生・停止ボタンクリック処理
  clickSpeakButton() {
    isSpeechPlay = !isSpeechPlay;
    notifyListeners();
  }

  // 時間読み上げ繰り返しリスト変更
  changeHourTimesList(int e) {
    hourTimes = e;
    notifyListeners();
  }

  // 秒読み上げスイッチ変更
  changeSecondSwitch() {
    isSecondSwitch = !isSecondSwitch;
  }

  // ボリュームスライダー変更
  changeVolumeSlider(double e) {
    volume = e;
  }

  // 速度スライダー変更
  changeSpeechRateSlider(double e) {
    speechRate = e;
  }

  // ピッチスライダー変更
  changePitchSlider(double e) {
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
