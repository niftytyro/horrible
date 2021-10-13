import 'package:app/screens/search/search_screen.dart';
import 'package:app/screens/search/search_screen.dart';
import 'package:app/services/storage.dart';
import 'package:app/services/user.dart';
import 'package:app/theme.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      appBar: AppBar(
        backgroundColor: BrickColors.englishRusk,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: BrickColors.englishRusk),
        title: Text(
          "Hey ${firstName()} 👋",
          style: BrickTheme.textTheme.headline2
              ?.copyWith(color: BrickColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.route);
            },
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [],
        ),
      ),
    );
  }
}
