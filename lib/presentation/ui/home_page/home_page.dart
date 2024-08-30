import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:time_yomiage/presentation/ui/home_page/provider/home_page_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MyHomePage> {
  String nowtime = DateFormat('HH:mm:ss').format(DateTime.now()).toString();
  late FlutterTts tts;
  bool isSpeak = false;
  var secondsList = ['10', '20', '30', '40', '50'];

  //=========================================
  // 業務ロジック
  //=========================================
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), _onTimer);
    tts = FlutterTts();
    tts.setLanguage("ja-JP");
    tts.setVolume(ref.read(homePageProvider).volume);
    tts.setSpeechRate(0.5);
    tts.setPitch(1.0);
  }

  void _onTimer(Timer timer) {
    DateTime dt = DateTime.now();
    var newTime = DateFormat('HH:mm:ss').format(dt);
    setState(() {
      // 画面の時計更新
      nowtime = newTime;
    });
    // 音声開始していなかったら処理終了
    if (!ref.watch(homePageProvider).isSpeechPlay) return;
    // 音声再生処理
    _speak(dt);
  }

  // 音声再生処理
  void _speak(DateTime dt) {
    var nowSecond = DateFormat('ss').format(dt);
    if (nowSecond == "00") {
      // 読み上げ中は処理終了
      if (isSpeak) return;
      // 0秒の時は時間を読み上げ
      speakTime();
      // 読み上げ中に変更
      isSpeak = true;
    } else if (secondsList.contains(nowSecond)) {
      // 秒読み上げしない場合は処理終了
      if (!ref.watch(homePageProvider).isSecondSwitch) return;
      // 読み上げ中は処理終了
      if (isSpeak) return;
      // 秒を読み上げ
      speakSecond(nowSecond);
      // 読み上げ中に変更
      isSpeak = true;
    } else {
      isSpeak = false;
    }
  }

  // 秒を読み上げ
  void speakSecond(String pScends) {
    tts.speak('$pScends秒');
  }

  // 時間を読み上げ
  Future<void> speakTime() async {
    var newTime = DateFormat('HH:mm').format(DateTime.now());
    for (int i = 0; i < 2; i++) {
      tts.speak(newTime);
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  //=========================================
  // 画面描画
  //=========================================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('時間読み上げ'),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 現在時刻
              Text(
                nowtime,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // 音声再生・停止ボタン
              playStopButton(),
              Container(
                margin: const EdgeInsets.only(top: 40, left: 15, right: 15),
                child: Column(
                  children: [
                    // 秒読み上げスイッチ
                    secondSwitch(),
                    // ボリュームスライダー
                    volumeSlider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 音声再生・停止ボタン
  Widget playStopButton() {
    String buttonLabel;
    if (ref.watch(homePageProvider).isSpeechPlay) {
      buttonLabel = '音声停止';
    } else {
      buttonLabel = '音声開始';
    }

    return FilledButton.icon(
      onPressed: () {
        ref.read(homePageProvider).clickSpeakButton();
      },
      icon: ref.watch(homePageProvider).isSpeechPlay
          ? const Icon(Icons.stop)
          : const Icon(Icons.play_circle_outline),
      label: Text(
        buttonLabel,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  // 秒読み上げスイッチ
  Widget secondSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '秒読み上げ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Switch(
          value: ref.watch(homePageProvider).isSecondSwitch,
          onChanged: (value) {
            setState(() {
              ref.read(homePageProvider).changeSecondSwitch();
            });
          },
        ),
      ],
    );
  }

  // ボリュームスライダー
  Widget volumeSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'ボリューム',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Slider(
          value: ref.watch(homePageProvider).volume,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          onChanged: (value) {
            setState(() {
              ref.read(homePageProvider).changeVolumeSlider(value);
              tts.setVolume(value);
            });
          },
        ),
      ],
    );
  }
}
