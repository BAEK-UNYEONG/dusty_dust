import 'package:flutter/material.dart';
import 'package:flutter_install_test/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Test2Screen extends StatefulWidget {
  const Test2Screen({Key? key}) : super(key: key);

  @override
  State<Test2Screen> createState() => _Test2ScreenState();
}

class _Test2ScreenState extends State<Test2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test2Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(
            valueListenable: Hive.box(testBox).listenable(),
            builder: (context, box, widget) {
              print(box.values.toList());

              return Column(
                children: box.values
                    .map(
                      (e) => Text(e.toString()),
                )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
