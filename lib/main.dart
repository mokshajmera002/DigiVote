import 'package:firebase_core/firebase_core.dart';
import 'package:new_digivote/login.dart';
import 'firebase_options.dart';
import 'package:new_digivote/widgets/themes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:new_digivote/auth.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  //sdafafdgfd
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: authpage(),//authpage(),
      themeMode: ThemeMode.system,
      theme: mytheme.lightTheme(context),
      darkTheme: mytheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
