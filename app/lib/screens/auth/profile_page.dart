import 'package:app/screens/auth/page_wrapper.dart';
import 'package:app/theme.dart';
import 'package:app/widgets/input_field.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PageWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: BrickColors.lightPeriwinkle,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 50),
            InputField(tag: 'Name'),
            InputField(tag: 'Username'),
            InputField(tag: 'Bio'),
          ],
        ),
      ),
    );
  }
}
