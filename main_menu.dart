import 'package:competency/record.dart';
import 'package:flutter/material.dart';

import 'add.dart';
import 'login.dart';
import 'view_records.dart';

class MainMenu extends StatefulWidget {

  //final UserInfo userInfo = UserInfo();
  final ListItemStorage listItemStorage = ListItemStorage();
  MainMenu(this.userInfo);
  UserInfo userInfo;

  @override
  _MainMenu createState() => _MainMenu(userInfo);
}

class _MainMenu extends State<MainMenu>  {

  _MainMenu(this.userInfo);
  UserInfo userInfo;

  var deleteNumber = 0;

  void writeListItems(listItems) {
    print('デバイスファイルに書き込みする処理');
    widget.listItemStorage.writeListItem(listItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メインメニュー'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            //icon: const Icon(Icons.android_outlined),
            icon : Text('削除'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('削除する項目の選択'),
                  content: TextField(
                    onChanged: (value) {
                      setState(() {
                        deleteNumber = value as int;
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          userInfo.listItems.removeAt(deleteNumber);
                        });
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          userInfo.listItems = [];
                        });
                        writeListItems(widget.userInfo.listItems);
                        Navigator.pop(context);
                      },
                      child: Text('全部消す'),
                    ),
                  ],
                ),
              );
            },
          )
        ]
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 30.0,
                mainAxisSpacing: 30.0,
                crossAxisCount: 3,
              ),
              itemCount: userInfo.listItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('${userInfo.listItems[index]}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ViewRecords(userInfo)
                              ));
                            },
                            child: Text('閲覧'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Record(userInfo)
                              ));
                            },
                            child: Text('記録'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    userInfo.listItems[index],
                    style: TextStyle(fontSize: 30),
                  ),
                  style: ElevatedButton.styleFrom(elevation: 20),
                );
              }
          )
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()  {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Add(userInfo)
            )).then((value) {
              // 再描画
              setState(() {});
            });
          },
          child: Icon(Icons.add)
      ),
    );
  }
}



