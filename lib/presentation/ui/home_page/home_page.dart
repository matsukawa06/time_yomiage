import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:time_yomiage/admob/ad_helper.dart';
import 'package:time_yomiage/presentation/ui/home_page/provider/home_page_provider.dart';
import 'package:time_yomiage/presentation/ui/home_page/util/util_widget.dart';
import 'package:time_yomiage/presentation/ui/setting_page/setting_page.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MyHomePage> {
  String nowtime = DateFormat('HH:mm:ss').format(DateTime.now()).toString();
  bool isSpeak = false;
  var secondsList = ['10', '20', '30', '40', '50'];
  final BannerAd myBanner = AdHelper().setBannerAd();
  late AdWidget adWidget;

  //=========================================
  // 業務ロジック
  //=========================================
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), _onTimer);
    ref.read(homePageProvider).init();
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
      _speakTime();
      // 読み上げ中に変更
      isSpeak = true;
    } else if (secondsList.contains(nowSecond)) {
      // 秒読み上げしない場合は処理終了
      if (!ref.watch(homePageProvider).isSecondSwitch) return;
      // 読み上げ中は処理終了
      if (isSpeak) return;
      // 秒を読み上げ
      _speakSecond(nowSecond);
      // 読み上げ中に変更
      isSpeak = true;
    } else {
      isSpeak = false;
    }
  }

  // 時間を読み上げ
  Future<void> _speakTime() async {
    var newTime = DateFormat('HH:mm').format(DateTime.now());
    int hourTimes = ref.watch(homePageProvider).hourTimes;
    for (int i = 0; i < hourTimes; i++) {
      // tts.speak(newTime);
      ref.read(homePageProvider).speakTts(newTime);
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  // 秒を読み上げ
  void _speakSecond(String pScends) {
    // tts.speak('$pScends秒');
    ref.read(homePageProvider).speakTts('$pScends秒');
  }

  //=========================================
  // 画面描画
  //=========================================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // 広告の読み込み
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(''),
        actions: [_settingIcon(context)],
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: size.width * 0.9,
            child: _bodyMain(context),
          ),
        ),
      ),
    );
  }

  // 設定ページ遷移アイコン
  Widget _settingIcon(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return SettingPage();
            },
          ),
        );
      },
      icon: Icon(
        Icons.settings,
        size: 25,
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }

  // メインコンテンツ
  Column _bodyMain(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // 現在時刻
        Text(
          nowtime,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SpaceBox.height(value: 32),
        // 音声再生・停止ボタン
        _playStopButton(),
        // 各種設定
        Container(
          margin: const EdgeInsets.only(top: 80, left: 15, right: 15),
          child: Column(
            children: [
              // 時間読み上げ回数リスト
              _hourTimesList(),
              // 秒読み上げスイッチ
              _secondSwitch(),
            ],
          ),
        ),
        const SpaceBox.height(value: 80),
        // Admob広告の表示
        AdHelper().setAdContainer(context, adWidget),
      ],
    );
  }

  // 音声再生・停止ボタン
  Widget _playStopButton() {
    String buttonLabel;
    IconData buttonIconData;
    Color buttonColor;

    if (ref.watch(homePageProvider).isSpeechPlay) {
      buttonLabel = '読み上げ停止';
      buttonIconData = Icons.stop_circle_outlined;
      buttonColor = Theme.of(context).colorScheme.error;
    } else {
      buttonLabel = '読み上げ開始';
      buttonIconData = Icons.play_circle_outline;
      buttonColor = Theme.of(context).colorScheme.primary;
    }

    return FilledButton.icon(
      onPressed: () {
        ref.read(homePageProvider).clickSpeakButton();
      },
      icon: Icon(buttonIconData, size: 46),
      label: Container(
        margin: const EdgeInsets.all(15),
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontSize: 26,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: buttonColor,
      ),
    );
  }

  // 時間読み上げ回数リスト
  Widget _hourTimesList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '時間読み上げ繰り返し',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        DropdownButton(
          items: const [
            DropdownMenuItem(value: 1, child: Text('１回')),
            DropdownMenuItem(value: 2, child: Text('２回')),
          ],
          value: ref.watch(homePageProvider).hourTimes,
          onChanged: (int? value) {
            ref.read(homePageProvider).changeHourTimesList(value!);
          },
        )
      ],
    );
  }

  // 秒読み上げスイッチ
  Widget _secondSwitch() {
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
}
