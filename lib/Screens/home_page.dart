import 'dart:convert';

import 'package:encrypt_app_demo/AES/aes_encryption.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AESEncryption encryption = new AESEncryption();
  List accounts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encrypt"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              buildListView(),
              buildBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return accounts.length > 0
        ? Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.pink[50],
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      accounts[index]["accID"].toString(),
                      style: TextStyle(color: Colors.pink),
                    ),
                    subtitle: Text(
                      accounts[index]["accName"].toString(),
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                );
              },
            ),
          )
        : Expanded(child: Container());
  }

  Widget buildBtn() => Padding(
        padding: const EdgeInsets.all(25.00),
        child: ElevatedButton(
          child: Text('Load Data'),
          onPressed: () {
            readJson(true);
          },
        ),
      );

  Future<void> readJson(bool shouldEncrypt) async {
    final response1 = jsonEncode(<String, List<dynamic>>{
      "account": [
        {"accID": "account1", "accName": "name1"},
        {"accID": "account2", "accName": "name2"},
        {"accID": "account3", "accName": "name3"}
      ]
    });

    final data = await json.decode(response1);
    setState(() {
      accounts = data["account"];
    });
    performEncryption(response1);
  }

  performEncryption(response) async {
    var encrypted = encryption.encryptMsg(response.toString()).base16;
    print(encrypted);
    var decrypted = encryption.decryptMsg(encryption.getCode(encrypted));
    print(decrypted);
    final data1 = await json.decode(decrypted);
    setState(() {
      accounts = data1["account"];
    });
  }
}
