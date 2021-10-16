import 'package:app/models/user.dart';
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
  @override
  void initState() {
    super.initState();
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
                  children: const [
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
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
