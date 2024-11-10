import 'package:flutter/material.dart';
import 'package:zubicalculator/pages/home_page.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Secret Vault'),
        ),
        body: const Center(
          child: Text('Exit Vault'),
        ),
      ),
    );
  }
}
