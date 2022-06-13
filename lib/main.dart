// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/dataclass.dart';
import 'package:flutter_crud/dbservices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: "Firebase CRUD",
      home: MyNotes(),
    ),
  );
}

class MyNotes extends StatelessWidget {
  MyNotes({Key? key}) : super(key: key);
  final contollerTitle = TextEditingController();
  final contollerDesc = TextEditingController();
  bool isDisabled = false;
  int jumData = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Note"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Data"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: contollerTitle,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      controller: contollerDesc,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('CANCEL'),
                    onPressed: () {
                      contollerTitle.text = "";
                      contollerDesc.text = "";
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('OK'),
                    onPressed: () {
                      jumData++;
                      final dtBaru = item(
                          title: contollerTitle.text, desc: contollerDesc.text);
                      database.addData(itemTemp: dtBaru);
                      contollerTitle.text = "";
                      contollerDesc.text = "";
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: database.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
              itemBuilder: (context, index) {
                DocumentSnapshot data = snapshot.data!.docs[index];
                String LvTitle = data['isititle'];
                String LvDesc = data['isidesc'];
                jumData = snapshot.data!.docs.length;
                return Dismissible(
                  key: Key(data['isititle']),
                  background: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    color: Colors.red,
                    child: Icon(Icons.delete_forever),
                  ),
                  secondaryBackground: Container(
                    color: Colors.transparent,
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return false;
                    } else {
                      return true;
                    }
                  },
                  onDismissed: (direction) {
                    database.deleteData(temptitle: LvTitle);
                    jumData--;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Data Deleted')));
                  },
                  child: ListTile(
                    onTap: () {
                      contollerTitle.text = LvTitle;
                      contollerDesc.text = LvDesc;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Edit Description"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  enabled: false,
                                  controller: contollerTitle,
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Title',
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                TextField(
                                  controller: contollerDesc,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Description",
                                  ),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                child: Text('CANCEL'),
                                onPressed: () {
                                  contollerTitle.text = "";
                                  contollerDesc.text = "";
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                                child: Text('OK'),
                                onPressed: () {
                                  jumData++;
                                  final dtBaru = item(
                                    title: LvTitle,
                                    desc: contollerDesc.text,
                                  );
                                  database.editData(itemTemp: dtBaru);
                                  contollerTitle.text = "";
                                  contollerDesc.text = "";
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onLongPress: () {
                      database.deleteData(temptitle: LvTitle);
                      jumData--;
                    },
                    title: Text(LvTitle),
                    subtitle: Text(LvDesc),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 8.0,
              ),
              itemCount: snapshot.data!.docs.length,
            );
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.pinkAccent,
              ),
            ),
          );
        },
      ),
    );
  }
}
