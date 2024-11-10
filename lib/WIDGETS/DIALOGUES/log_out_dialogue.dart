import 'package:flutter/material.dart';
import 'package:money_maker/PROVIDERS/login_auth_provider.dart';
import 'package:money_maker/SCREENS/AUTH/login_screen.dart';
import 'package:money_maker/WIDGETS/DIALOGUES/DIALOGUE_UTILS/custom_dialogue.dart';
import 'package:provider/provider.dart';

void showLogoutDialogue({
  required BuildContext context,
}) {
  final authProvider = Provider.of<LoginAuthProvider>(context, listen: false);

  CustomBlurDialog.show(
    context: context,
    title: 'Confirm Logout',
    content: 'Are you sure you want to log out?',
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.deepPurple, fontSize: 18),
        ),
      ),
      TextButton(
        onPressed: () async {
          Navigator.of(context).pop();
          await authProvider.signOut(context);
        
        },
        child: Text(
          'Log out',
          style: TextStyle(color: Colors.red[400]!, fontSize: 18),
        ),
      ),
    ],
  );
}
