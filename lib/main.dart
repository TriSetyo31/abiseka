import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/firebase_options.dart';
import 'package:login_flutter/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
var app= await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
FirebaseFirestore.instanceFor(app: app);
  runApp(MaterialApp(
    title: "BelajarFlutter.com",
    home: LoginScreen(),
  ));
}
