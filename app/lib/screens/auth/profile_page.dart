import 'package:app/constants.dart';
import 'package:app/screens/auth/page_wrapper.dart';
import 'package:app/theme.dart';
import 'package:app/widgets/input_field.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
    required this.bioController,
    required this.nameController,
    required this.usernameController,
    required this.invalidBio,
    required this.invalidName,
    required this.invalidUserame,
  }) : super(key: key);
  final TextEditingController bioController;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final bool invalidBio;
  final bool invalidName;
  final bool invalidUserame;

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
                color: BrickColors.periwinkle,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 50),
            InputField(
              tag: 'Name',
              controller: nameController,
              invalidValue: invalidName,
              errorKey: InputFieldErrorMessageKey.name,
            ),
            InputField(
              tag: 'Username',
              controller: usernameController,
              invalidValue: invalidUserame,
              errorKey: InputFieldErrorMessageKey.username,
            ),
            InputField(
              tag: 'Bio',
              controller: bioController,
              invalidValue: invalidBio,
              errorKey: InputFieldErrorMessageKey.bio,
            ),
          ],
        ),
      ),
    );
  }
}
