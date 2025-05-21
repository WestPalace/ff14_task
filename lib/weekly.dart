import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';

class Weekly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> list2 = [
      "冒険者小隊",
      "ジャンボくじテンダー",
      "クロの空想帳",
      "お得意様取引",
      "ファッションチェック",
      "リスキーモブハン",
      "ドマ復興",
      "週制限系",
      "(攻略手帳)",
    ];
    List<bool> checkList2 = List.filled(9, false);
    return MaterialApp(
      title: 'Daily Tasks',
      home: Home(list2, checkList2),
    );
  }
}

class Home extends StatelessWidget{
  List<String> list2;
  List<bool> checkList2;
  Home(this.list2, this.checkList2);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Tasks'),
        backgroundColor: Colors.redAccent,
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 5) {
            print('swiped');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return MyApp();
            }));
          }
        },
        child: ListView.separated(
          itemBuilder:  (BuildContext context, int index) {
            return _messageItem(list2[index], checkList2[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return separatorItem();
          },
          itemCount: list2.length,
        ),
      ),
    );
  }

  Widget separatorItem() {
    return Container(
      height: 5,
      color: Colors.redAccent,
    );
  }

  Widget _messageItem(String title2, bool check2) {
    return Container(
      decoration: new BoxDecoration(
          border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
      ),
      child: CheckBoxes(title2, check2),
    );
  }
}

class CheckBoxesState extends State<CheckBoxes> {
  String boxTitleState2;
  bool boxCheckState2;
  CheckBoxesState(this.boxTitleState2, this.boxCheckState2);
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime latestTime = DateTime.now();
      _getTime('Time').then((value) {
        setState(() {
          latestTime = value;
        });
      });
      DateTime now = DateTime.now();
      _setTime('Time', now.toString());
      DateTime latestTuesday = latestTime.add(Duration(days: (9 - latestTime.weekday) % 7));
      DateTime latestTuesday17 = DateTime(latestTuesday.year, latestTuesday.month, latestTuesday.day, 17);
      if (now.isAfter(latestTuesday17) || (now.weekday == 2 && now.hour == 17 && now.minute == 0 && now.second == 0)) {
        setState(() {
          boxCheckState2 = false;
          _setPrefItems(boxTitleState2, boxCheckState2);
        });
      }
    });
    // 初期化時にShared Preferencesに保存している値を読み込む
    _getPrefItems(boxTitleState2, boxCheckState2);
  }
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        boxTitleState2,
        style: TextStyle(
            color: Colors.black,
            fontSize: 18.0
        ),
      ),
      value: boxCheckState2,
      activeColor: Colors.redAccent,
      onChanged: (newValue) {
        setState(() {
          boxCheckState2 = newValue!;
        });
        _setPrefItems(boxTitleState2, boxCheckState2);
      },
    );
  }

  _getPrefItems(String title, bool check) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      boxCheckState2 = prefs.getBool(title) ?? false;
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
  String boxTitle2;
  bool boxCheck2;
  CheckBoxes(this.boxTitle2, this.boxCheck2);

  @override
  CheckBoxesState createState() => new CheckBoxesState(boxTitle2, boxCheck2);
}


// class Home extends StatelessWidget{
//   List<String> list;
//   List<bool> checkList;
//   Home(this.list, this.checkList);
//   @override
//   Widget build(BuildContext context){
//     _getPrefItems(list, checkList);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Weekly Tasks'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: GestureDetector(
//         onHorizontalDragUpdate: (details) {
//           if (details.delta.dx > 5) {
//             print('swiped');
//             Navigator.of(context)
//                 .push(MaterialPageRoute(builder: (context) {
//               return MyApp();
//             }));
//           }
//         },
//         child: ListView.separated(
//           itemBuilder:  (BuildContext context, int index) {
//             return _messageItem(list[index], checkList[index]);
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return separatorItem();
//           },
//           itemCount: list.length,
//         ),
//       ),
//     );
//   }
//
//   Widget separatorItem() {
//     return Container(
//       height: 5,
//       color: Colors.redAccent,
//     );
//   }
//
//   Widget _messageItem(String title, bool checkList) {
//     return Container(
//       decoration: new BoxDecoration(
//           border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
//       ),
//       child: CheckBoxes(title, checkList),
//     );
//   }
//
//   _getPrefItems(List<String> list, List<bool> checkList) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     for (int i = 0; i < list.length; i++) {
//       checkList[i] = prefs.getBool(list[i]) ?? false;
//     }
//   }
// }
//
// class CheckBoxesState extends State<CheckBoxes> {
//   String title;
//   bool checkList;
//   CheckBoxesState(this.title, this.checkList);
//   @override
//   Widget build(BuildContext context) {
//     return CheckboxListTile(
//       title: Text(
//         title,
//         style: TextStyle(
//             color: Colors.black,
//             fontSize: 18.0
//         ),
//       ),
//       value: checkList,
//       activeColor: Colors.redAccent,
//       onChanged: (newValue) {
//         setState(() {
//           checkList = newValue!;
//           _setPrefItems(title, checkList);
//         });
//       },
//     );
//   }
//
//   _setPrefItems(String title, bool checkList) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool(title, checkList);
//   }
// }
//
// class CheckBoxes extends StatefulWidget {
//   String title;
//   bool checkList;
//   CheckBoxes(this.title, this.checkList);
//
//   @override
//   CheckBoxesState createState() => new CheckBoxesState(title, checkList);
// }
