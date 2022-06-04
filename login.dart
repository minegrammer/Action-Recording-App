import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

import 'main_menu.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class LoginPage extends StatefulWidget {
  final IdStorage idStorage = IdStorage();
  final ListItemStorage listItemStorage = ListItemStorage();


  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage>  {

  final GoogleClass google = GoogleClass();
  final UserInfo userInfo = UserInfo();

  // 起動時に実行
  @override
  void initState() {
    super.initState();
    widget.idStorage.readId().then((String value) {
      print("sheetIdの読み込み");
      setState(() {
        userInfo.sheetId = value;
        print("今sheetIdは" + userInfo.sheetId.toString());
      });
    });
    widget.listItemStorage.readListItem().then((List<String> value) {
      print("listItemsの読み込み");
      setState(() {
        userInfo.listItems = value;
        print("今listItemsは" + userInfo.listItems.toString());
      });
    });
  }
  void writeSheetId(id) {
    widget.idStorage.writeId(id);
  }
  void writeListItems(listItems) {
    widget.listItemStorage.writeListItem(listItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン画面'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 100,
          child: ElevatedButton(
            onPressed: () async {
              print("ログイン開始");

              // Google login
              final account = await google.signInWithGoogle();

              //
              final authHeaders = await account!.authHeaders;
              final authenticateClient = GoogleAuthClient(authHeaders);

              print('sheetIdは' + userInfo.sheetId);

              if (userInfo.sheetId == "0") {
                //userInfo.sheetId = await google.createSpreadSheet(authenticateClient);
                //writeSheetId(userInfo.id);
                print('sheetを新規作成しました。');
              } else {
                print('既存のsheetIdを使用');
              }

              // userInfo class
              userInfo.account =  account;
              userInfo.authenticateClient =  authenticateClient;

              // アクションのリストの初期値
              //final listItems = ['運動','食事','勉強','筋トレ','学会','会話'];
              //userInfo.actions.addAll(listItems);
              //print('現在のlistItemsは' + userInfo.listItems.length.toString() + '個ある');

              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MainMenu(userInfo)
              ));
            },
            child: Text(
              'login',
              style: TextStyle(fontSize: 30),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// A class that holds a user's account and data
class UserInfo {
  late GoogleSignInAccount account;
  late GoogleAuthClient authenticateClient;
  late String sheetId;
  late List<String> listItems;
  late String sheetRange ;
}

class GoogleClass{
  Future signInWithGoogle() async {
    final signIn.GoogleSignIn googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    print("User account $account");
    return account;
  }
  Future createSpreadSheet(GoogleAuthClient authenticateClient) async {
    final driveApi = drive.DriveApi(authenticateClient);
    var driveFile = drive.File();
    driveFile.name = "copy_spreadsheet";
    driveFile.mimeType = 'application/vnd.google-apps.spreadsheet';
    final result = await driveApi.files.create(driveFile);
    // final result = await driveApi.files.copy(driveFile, "1hmoAYEVUeEmBC909TPSISlPrLCOz6f7bbPG490fgk_w");
    return result.id;
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();
  GoogleAuthClient(this._headers);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}


//Class for sheetId
class IdStorage {
  Future<String> readId() async {
    try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "0";
    }
  }
  Future<File> writeId(String id) async {
    final file = await _localFile;
    print("id書き込み");
    // Write the file
    return file.writeAsString(id);
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    print("sheetIdファイルの作成");
    return File('$path/sheetId.txt');
  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print("idのpathの取得");
    List<FileSystemEntity> files;
    files = directory.listSync(recursive: true,followLinks: false);
    for (var file in files) {
      print(file);
    }
    return directory.path;
  }
}


//Class for days
class ListItemStorage {
  Future<List<String>> readListItem() async {
    try {
      final file = await _localFile;
      // Read the file
      List<String> contents = (await file.readAsString()).replaceAll('[', "").replaceAll(']', "").split(', ');
      print('読み込んだ値');
      print(contents);
      print(contents.length);
      print(contents[0]);
      print(contents.first);
      print(contents.isEmpty);

      contents = [];
      print(contents);
      print(contents.length);
      print(contents[0]);
      print(contents.first);
      print(contents.isEmpty);

      if (contents[0] == ' ') {
        print('からのリストに置換');
        contents = [];
      }
      if (contents == [ ]) {
        print('リスト');
      }
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      print('読み込みエラー');
      return [];
    }
  }
  Future<File> writeListItem(List<String> listItems) async {
    final file = await _localFile;
    print("listItems書き込み");
    print(listItems);
    var Fileitems = file.writeAsString('$listItems');
    print('$listItems');
    // Write the file
    //return file.writeAsString('$listItems');
    return Fileitems;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    print("listItemsファイルの作成");
    return File('$path/listItems.txt');
  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print("listItemsのpathの取得");
    return directory.path;
  }
}