import 'package:flutter/material.dart';

///
/// settingページ
///
class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('設定'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      child: Text('てすと'),
    );
  }
}
