import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zubicalculator/pages/confirm_pin_page.dart';
import 'package:zubicalculator/pages/home_page.dart';
import 'package:zubicalculator/pages/setup_pin_page.dart';
import 'package:zubicalculator/pages/vault_page.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zubi Calculator',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/calculator',
      routes: {
        '/setPin': (context) => const SetPinPage(),
        '/confirmPin': (context) => const ConfirmPinPage(pin: ''),
        '/calculator': (context) => const HomePage(),
        '/vault': (context) => const VaultPage(),
      },
    );
  }
}
