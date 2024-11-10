import 'package:flutter/material.dart';
import 'package:money_maker/WIDGETS/DIALOGUES/DIALOGUE_UTILS/custom_dialogue.dart';

void showReferralCodeConfirmationDialogue({
  required BuildContext context,
  required Function onConfirm,
}) {
  CustomBlurDialog.show(
    context: context,
    title: 'Continue Without Referral?',
    content: '',
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
          onConfirm();
        },
        child:  Text(
          'Yes',
          style: TextStyle(color: Colors.red[400], fontSize: 18),
        ),
      ),
    ],
  );
}