import 'package:flutter/material.dart';

import 'login.dart';

class Add extends StatefulWidget {
  Add(this.userInfo);
  UserInfo userInfo;

  final GoogleClass google = GoogleClass();
  final ListItemStorage listItemStorage = ListItemStorage();

  @override
  _Add createState() => _Add(userInfo);
}

class _Add extends State<Add> {

  _Add(this.userInfo);
  UserInfo userInfo;

  String inputText = '';

  void writeListItems(listItems) {
    print('デバイスファイルに書き込みする処理');
    widget.listItemStorage.writeListItem(listItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('追加する'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'アクションを追加する',
              style: TextStyle(fontSize: 30),
            ),
            Padding(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'アクションの入力',
                ),
                onChanged: (text) {
                  setState(() {
                    inputText = text;
                  });
                },
              ),
              padding: EdgeInsets.all(20.0),
            ),
            SizedBox(
              width: 180,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  //widget.userInfo.listItems.add(inputText);
                  writeListItems(widget.userInfo.listItems..add(inputText));
                  Navigator.pop(context,userInfo);
                },
                child: Text(
                  '追加する',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}