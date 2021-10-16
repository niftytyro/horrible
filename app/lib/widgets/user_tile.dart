import 'package:app/models/user.dart';
import 'package:app/screens/chatroom/chatroom_screen.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, ChatRoomScreen.route,
            arguments: user);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.name, style: BrickTheme.textTheme.headline3),
          Text(
            user.username,
            style: BrickTheme.textTheme.bodyText1
                ?.copyWith(color: BrickColors.black80),
          ),
        ],
      ),
    );
  }
}
