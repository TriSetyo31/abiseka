
import 'dart:convert';
import 'dart:ffi';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_flutter/models/model_user.dart';

class FirestoreHelper {
  static CollectionReference user = FirebaseFirestore.instance.collection('user');
  static Future<void> createAbsensi(double? lat, double? longi, String? email,
      String? displayName, String? tip, String? fileBlob) async {
    user
        .add({
          'Nama': "$displayName",
          'latitude': "$lat",
          'longitude': "$longi",
          'E-mail': "$email",
          'Created':DateTime.now().millisecondsSinceEpoch,
          'tipe': tip,
          'fileBlob': fileBlob,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<List<ModelUser>> getUser() async {
    List<ModelUser> dataResult = [];

    await user.get().then((value) {
      if (value.docs != null) {
        value.docs.forEach((doc) {
          dataResult.add(ModelUser(
            nama: doc["Nama"],
            created: doc["Created"].toString(),
            eMail: doc["E-mail"],
            latitude: doc["latitude"],
            longitude: doc["longitude"],
            tipe: doc["tipe"],
            fileBlob: doc["fileBlob"],
          ));
        });
      }
    });
    dataResult.sort((a, b) {
      int itema=int.tryParse((a.created).toString())??0;
      int itemb=int.tryParse((b.created).toString())??0;
      return itemb.compareTo(itema);
    },);
    return dataResult;
  }
}
