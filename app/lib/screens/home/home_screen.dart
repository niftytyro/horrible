import 'package:app/services/storage.dart';
import 'package:app/services/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = storage.name ?? "";
  @override
  void initState() {
    super.initState();
    getUser().then((value) {
      setState(() {
        name = value["name"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text("Hello $name 👋"),
      )),
    );
  }
}
