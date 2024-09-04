import 'package:flutter/material.dart';

///
/// MaterialColorを作成する
///
MaterialColor createMaterialColor(Color color) {
  //渡されたカラーを分解
  final r = color.red;
  final g = color.green;
  final b = color.blue;

  //カラーの濃さのベースをなるリストを作成
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  //50~900のカラーパレット(Map)を作成
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

const MaterialColor materialWhite = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

///
/// Widget間のスペース（マージン）をSpaceBoxで調整する
///
class SpaceBox extends SizedBox {
  const SpaceBox({super.key, double super.width = 8, double super.height = 8});

  const SpaceBox.width({super.key, double value = 8}) : super(width: value);
  const SpaceBox.height({super.key, double value = 8}) : super(height: value);
}

///
/// DBに登録した文字列をColorに変換して返却する
///
Color stringToColor(String pStr) {
  if (pStr == '') {
    return Colors.blue;
  } else {
    String valueString = pStr.split('(0x')[1].split(')')[0];
    return Color(int.parse(valueString, radix: 16));
  }
}

///
/// リストの２つ目以降にborderを作成
///
Widget createBorder(int index, double pWidth) {
  return Container(
    decoration: index != 0
        ? BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: pWidth),
            ),
          )
        : null,
  );
}

///
/// Dividerの共通設定
///
Widget commonDivider() {
  return const Divider(
    height: 0.5, // 線が占める高さ
    thickness: 2, // 線の太さ
    indent: 20, // 左端のスペース
    endIndent: 20, // 右端のスペース
  );
}
