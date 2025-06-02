
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/camp.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CampAdapter());
  runApp(DAMPApp());
}

class DAMPApp extends StatelessWidget {
  const DAMPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAMP - Drink Monitor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
