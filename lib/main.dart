import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_app/src/providers/user_provider.dart';
import 'package:flutter_view_app/src/screen/home/home_screen.dart';
//import 'package:flutter_view_app/src/screen/home/home_screen.dart';
import 'package:flutter_view_app/src/screen/login/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Data',
        initialRoute: 'login',
        routes: {
          'login': (context) => const LoginScreen(),
          'home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
