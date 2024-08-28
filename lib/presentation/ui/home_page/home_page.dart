import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_yomiage/presentation/ui/home_page/provider/home_page_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MyHomePage> {
  String nowtime = DateFormat('HH:mm:ss').format(DateTime.now()).toString();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), _onTimer);
  }

  void _onTimer(Timer timer) {
    var newTime = DateFormat('HH:mm:ss').format(DateTime.now());
    setState(() {
      nowtime = newTime;
    });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              nowtime,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${homePageP.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => homePageP.incrementCounter(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//   @override
//   Widget build(BuildContext context, ref) {
//     final homePageP = ref.watch(homePageProvider);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('時間読み上げ'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '${homePageP.counter}',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => homePageP.incrementCounter(),
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
