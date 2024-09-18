import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:time_yomiage/presentation/controller/theme_controller.dart';

final ttsController = ChangeNotifierProvider<TtsController>(
  (ref) => TtsController(ref),
);

class TtsController extends ChangeNotifier {
  TtsController(this.ref);
  final Ref ref;
  late FlutterTts tts;

  // TTSの初期化
  initTts() {
    tts = FlutterTts();
    tts.setLanguage("ja-JP");
    tts.setVolume(ref.read(themeController).volume);
    tts.setSpeechRate(0.5);
    tts.setPitch(1.0);
  }

  // TTS再生
  speakTts(String p) {
    tts.speak(p);
  }

  // ボリュームスライダー変更
  changeVolume(double e) {
    tts.setVolume(e);
  }

  // 速度スライダー変更
  changeSpeechRate(double e) {
    tts.setSpeechRate(e);
  }

  // ピッチスライダー変更
  changePitch(double e) {
    tts.setPitch(e);
  }
}
