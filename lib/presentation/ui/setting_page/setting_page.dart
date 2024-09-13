import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// settingページ
///
class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('設定'),
      ),
      body: _body(ref),
    );
  }

  // settingページのbody部
  Widget _body(WidgetRef ref) {
    Future<PackageInfo> getPackageInfo() {
      return PackageInfo.fromPlatform();
    }

    return Container(
      padding: const EdgeInsets.all(28),
      child: FutureBuilder(
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
              // App情報
              _appInfo(context, data),
            ],
          );
        },
      ),
    );
  }

  /// App情報
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
