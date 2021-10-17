import 'package:app/models/search.dart';
import 'package:app/models/user.dart';
import 'package:app/api/user.dart';
import 'package:app/theme.dart';
import 'package:app/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  static const route = "/search";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<SearchResult> results;
  String searchKey = "";

  @override
  void initState() {
    super.initState();
    results = search(key: searchKey.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrickColors.englishRusk,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: BrickColors.englishRusk),
        elevation: 0,
        titleSpacing: BrickSpacing.m,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BrickSpacing.xxl),
            color: BrickColors.white,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: BrickSpacing.l1,
          ),
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Search...",
              border: InputBorder.none,
            ),
            style: BrickTheme.textTheme.bodyText1
                ?.copyWith(color: BrickColors.black60),
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              setState(() {
                if (searchKey.trim() != value.trim()) {
                  results = search(key: value.trim());
                }
                searchKey = value.trim();
              });
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: BrickSpacing.l,
          horizontal: BrickSpacing.xl,
        ),
        child: FutureBuilder<SearchResult>(
          future: results,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.users.isNotEmpty) {
                return ListView(
                  children: snapshot.data!.users.map((user) {
                    return UserTile(user: user);
                  }).toList(),
                );
              } else {
                return Center(
                    child: Text(searchKey != ""
                        ? "Couldn't find any users :/"
                        : "Go on search for your friends!"));
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
