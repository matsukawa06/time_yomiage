import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:time_yomiage/admob/ad_helper.dart';
import 'package:time_yomiage/common/common_const.dart';
import 'package:time_yomiage/presentation/controller/theme_controller.dart';
import 'package:time_yomiage/presentation/ui/home_page/util/util_widget.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// settingページ
///
class SettingPage extends ConsumerWidget {
  SettingPage({super.key});

  final BannerAd myBanner = AdHelper().setBannerAd();

  //=========================================
  // 画面描画
  //=========================================
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    // 広告の読み込み
    myBanner.load();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('設定'),
      ),
      // SafeAreaでWrapしておけば、端末によるノッチをいい感じに調整してくれる
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: size.width * 0.9,
            child: _body(ref),
          ),
        ),
      ),
    );
  }

  ///
  /// settingページのbody部
  ///
  Widget _body(WidgetRef ref) {
    Future<PackageInfo> getPackageInfo() {
      return PackageInfo.fromPlatform();
    }

    return FutureBuilder(
      future: getPackageInfo(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasError) {
          return const Text('ERROR');
        } else if (!snapshot.hasData) {
          return const Text('Loading...');
        }
        final data = snapshot.data!;
        return Column(
          children: [
            // App設定
            _appSetting(context, ref),
            const SpaceBox.height(value: 32),
            // App情報
            _appInfo(context, data),
            const SpaceBox.height(value: 80),
            // Admob広告の表示
            AdHelper().setAdContainer(context, AdWidget(ad: myBanner)),
          ],
        );
      },
    );
  }

  ///
  /// App設定
  ///
  Widget _appSetting(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            // ダークモード選択エリア
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ダークモード',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: ref.watch(themeController).isDark,
                  onChanged: (bool value) {
                    ref.read(themeController).brightnessToggle();
                  },
                )
              ],
            ),
            // ボリュームスライダー
            createSlider(context, ref, SliderType.volume),
            // 速度スライダー
            createSlider(context, ref, SliderType.speechRate),
            // ピッチスライダー
            createSlider(context, ref, SliderType.pitch),
          ],
        ),
      ),
    );
  }

  //
  // スライダー作成
  //
  Widget createSlider(BuildContext context, WidgetRef ref, SliderType type) {
    String title;
    double value;

    switch (type) {
      case SliderType.volume:
        title = 'ボリューム';
        value = ref.watch(themeController).volume;
        break;
      case SliderType.speechRate:
        title = '速度';
        value = ref.watch(themeController).speechRate;
        break;
      case SliderType.pitch:
        title = 'ピッチ';
        value = ref.watch(themeController).pitch;
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          onChanged: (value) {
            ref.read(themeController).changeSlider(value, type);
          },
        ),
      ],
    );
  }

  ///
  /// App情報
  ///
  Widget _appInfo(BuildContext context, PackageInfo data) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          // アプリ情報
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            child: InkWell(
              onTap: () async => showAboutDialog(
                context: context,
                applicationName: 'カウントダウンリスト',
                applicationVersion: 'Ver. ${data.version}',
              ),
              child: const ListTile(
                title: Text('アプリ情報'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          // 利用規約
          InkWell(
            onTap: () async => _launchURL('https://naonari.com/kiyaku.html'),
            child: const ListTile(
              title: Text('利用規約・プライバシーポリシー'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// 利用規約のページをブラウザで表示する
  ///
  void _launchURL(String url) async {
    // const url = 'https://naonari.com/kiyaku.html';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not Launch $url';
    }
  }
}
