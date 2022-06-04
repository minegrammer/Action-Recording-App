import 'package:flutter/material.dart';

import 'login.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Record extends StatefulWidget {
  Record(this.userInfo);
  UserInfo userInfo;

  @override
  State<StatefulWidget> createState() {
    return _Record(userInfo);
  }
}

class _Record extends State<Record> {
  var _labelText = '日付を選択してください';

  _Record(this.userInfo);
  UserInfo userInfo;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime(DateTime.now().year + 2)
    );
    if (selected != null) {
      setState(() {
        _labelText = (DateFormat.yMMMd()).format(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('記録画面'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: 100, //上
            bottom: 100, //下
            left: 0, //左
            right: 0, //右
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '記録する',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                _labelText,
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.date_range,size: 30),
                onPressed: () => _selectDate(context),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 180,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {


                  },
                  child: Text(
                    '記録する',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}