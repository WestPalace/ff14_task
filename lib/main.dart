import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weekly.dart';
import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('ja_JP');
  //debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list1 = [
      "ルレ(レべ，アラは経験値大)",
      "部族クエ",
      "リーヴ",
      "地図掘り",
      "リテイナーベンチャー",
      "グラカン納品(★は経験値大)",
      "ミニくじテンダー(カード→MGPも可)",
      "モブハン",
      "無人島",
    ];
    List<bool> checkList1 = List.filled(9, false);
    return MaterialApp(
      title: 'Daily Tasks',
      home: Home(list1, checkList1),
    );
  }
}

class Home extends StatelessWidget{
  List<String> list1;
  List<bool> checkList1;
  Home(this.list1, this.checkList1);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Tasks'),
        backgroundColor: Colors.blueAccent,
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < -5) {
            print('swiped');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return Weekly();
            }));
          }
        },
        child: ListView.separated(
          itemBuilder:  (BuildContext context, int index) {
            return _messageItem(list1[index], checkList1[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return separatorItem();
          },
          itemCount: list1.length,
        ),
      ),
    );
  }

  Widget separatorItem() {
    return Container(
      height: 5,
      color: Colors.blueAccent,
    );
  }

  Widget _messageItem(String title1, bool check1) {
    return Container(
      decoration: new BoxDecoration(
          border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
      ),
      child: CheckBoxes(title1, check1),
    );
  }
}

class CheckBoxesState extends State<CheckBoxes> {
  String boxTitleState1;
  bool boxCheckState1;
  CheckBoxesState(this.boxTitleState1, this.boxCheckState1);
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime latestTime = DateTime.now();
      _getTime('latestTime').then((value) {
        setState(() {
          latestTime = value;
        });
      });
      DateTime now = DateTime.now();
      _setTime('latestTime', now.toString());
      if (now.minute != latestTime.minute || (now.hour == 0 && now.minute == 0 && now.second == 0)) {
        setState(() {
          boxCheckState1 = false;
          _setPrefItems(boxTitleState1, boxCheckState1);
        });
      }
    });
    // 初期化時にShared Preferencesに保存している値を読み込む
    _getPrefItems(boxTitleState1, boxCheckState1);
  }
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        boxTitleState1,
        style: TextStyle(
            color: Colors.black,
            fontSize: 18.0
        ),
      ),
      value: boxCheckState1,
      activeColor: Colors.blueAccent,
      onChanged: (newValue) {
        setState(() {
          boxCheckState1 = newValue!;
        });
        _setPrefItems(boxTitleState1, boxCheckState1);
      },
    );
  }

  _getPrefItems(String title, bool check) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      boxCheckState1 = prefs.getBool(title) ?? false;
    });
  }

  _setPrefItems(String title, bool check) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(title, check);
  }

  Future<DateTime> _getTime(String title) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String i = '0000-00-00 00:00:00';
    setState(() {
      i = prefs.getString(title) ?? '0000-00-00 00:00:00';
    });
    return DateTime.parse(i);
  }

  _setTime(String title, String time) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(title, time);
  }
}

class CheckBoxes extends StatefulWidget {
  String boxTitle1;
  bool boxCheck1;
  CheckBoxes(this.boxTitle1, this.boxCheck1);

  @override
  CheckBoxesState createState() => new CheckBoxesState(boxTitle1, boxCheck1);
}
