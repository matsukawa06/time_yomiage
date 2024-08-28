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
  var secondsList = ['10', '20', '30', '40', '50'];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), _onTimer);
    tts = FlutterTts();
    tts.setLanguage("ja-JP");
    tts.setVolume(1.0);
    tts.setSpeechRate(0.5);
    tts.setPitch(1.0);
  }

  void _onTimer(Timer timer) {
    DateTime dt = DateTime.now();
    var newTime = DateFormat('HH:mm:ss').format(dt);
    setState(() {
      nowtime = newTime;
    });
    // 再生中かをチェック
    if (ref.watch(homePageProvider).isSpeak) {
      var nowSecond = DateFormat('ss').format(dt);
      if (nowSecond == "00") {
        speakTime();
      } else if (secondsList.contains(nowSecond)) {
        speakSecond(nowSecond);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homePageP = ref.watch(homePageProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('時間読み上げ'),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                nowtime,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              FilledButton.icon(
                onPressed: () {
                  ref.read(homePageProvider).clickSpeakButton();
                },
                icon: ref.watch(homePageProvider).isSpeak
                    ? const Icon(Icons.stop)
                    : const Icon(Icons.play_circle_outline),
                label:
                    ref.watch(homePageProvider).isSpeak ? const Text('音声停止') : const Text('音声開始'),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => homePageP.incrementCounter(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void speakSecond(String pScends) {
    tts.speak('$pScends秒');
  }

  Future<void> speakTime() async {
    var newTime = DateFormat('HH:mm').format(DateTime.now());
    for (int i = 0; i < 2; i++) {
      tts.speak(newTime);
      await Future.delayed(const Duration(seconds: 3));
    }
    // tts.speak('$newTime');
  }
}
