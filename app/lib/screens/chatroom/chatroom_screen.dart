import 'dart:convert';

import 'package:app/api/chat.dart';
import 'package:app/models/chat.dart';
import 'package:app/models/user.dart';
import 'package:app/services/storage.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatRoomScreen extends StatefulWidget {
  static const route = "/chatroom";
  const ChatRoomScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final ChatRoom room;
  String friendMessage = "";

  @override
  void initState() {
    super.initState();
    room = ChatRoom(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrickColors.englishRusk,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: BrickColors.englishRusk,
        ),
        elevation: 0,
        title: Text(widget.user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(BrickSpacing.l),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: BrickColors.lightPeriwinkle,
                  borderRadius: BorderRadius.circular(BrickSpacing.l),
                ),
                child: StreamBuilder(
                  stream: room.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final message =
                          ChatMessage.fromJson(json.decode("${snapshot.data}"));
                      if (message.from == storage.id) {
                        setState(() {
                          friendMessage = message.message;
                        });
                      }
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          friendMessage,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: BrickSpacing.l),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: BrickColors.jbg,
                  borderRadius: BorderRadius.circular(BrickSpacing.l),
                ),
                padding: const EdgeInsets.symmetric(horizontal: BrickSpacing.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {
                        room.send(
                            jsonEncode({"from": storage.id, "message": value}));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
