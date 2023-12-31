//import 'package:bygrocerriesadminpanel/home.dart';
import 'package:bygrocerriesadminpanel/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    ),
  );
}
