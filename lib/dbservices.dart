import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crud/dataclass.dart';

CollectionReference dbNote = FirebaseFirestore.instance.collection("DbNotes");

class database {
  static Stream<QuerySnapshot> getData() {
    return dbNote.snapshots();
  }

  static Future<void> addData({required item itemTemp}) async {
    DocumentReference docRef = dbNote.doc(itemTemp.title);

    await docRef
        .set(itemTemp.toJson())
        .whenComplete(() => print("Data Inserted"))
        .catchError((e) => print(e));
  }

  static Future<void> editData({required item itemTemp}) async {
    DocumentReference docRef = dbNote.doc(itemTemp.title);

    await docRef
        .update(itemTemp.toJson())
        .whenComplete(() => print("Data Updated"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteData({required String temptitle}) async {
    DocumentReference docRef = dbNote.doc(temptitle);

    await docRef
        .delete()
        .whenComplete(() => print("Data Deleted"))
        .catchError((e) => print(e));
  }
}
