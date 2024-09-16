import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:time_yomiage/presentation/controller/theme_controller.dart';
import 'package:time_yomiage/presentation/ui/home_page/home_page.dart';

void main() {
  // 向き指定
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // 縦固定
    DeviceOrientation.portraitUp,
  ]);
  // Admob用のプラグイン初期化
  MobileAds.instance.initialize();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color _seedColor = Color(0x00ffffff);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return MaterialApp(
          title: 'Time Yomiage',
          theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: _seedColor,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: _seedColor,
          ),
          themeMode: ref.watch(themeController).mode,
          home: const MyHomePage(),
        );
      },
    );
  }
}
