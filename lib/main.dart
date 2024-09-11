import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Yomiage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 56, 194, 141)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
