import 'package:flutter/material.dart';
import 'package:flutter_install_test/main.dart';
import 'package:flutter_install_test/screen/test2_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestScreen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TestScreen',
            textAlign: TextAlign.center,
          ),
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
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              print('keys: ${box.keys.toList()}');
              print('values: ${box.values.toList()}');
            },
            child: Text('박스 프린트하기'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              box.put(
                1000, 'sadfsdfsafsafsd',
              );
            },
            child: Text('데이터 넣기'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              print(box.get("룰루랄라"));
            },
            child: Text('특정 값 가져오기'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);

              box.delete('룰루랄라');
            },
            child: Text('삭제하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => Test2Screen()),
              );
            },
            child: Text('다음 화면'),
          ),
        ],
      ),
    );
  }
}
