import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:money_maker/WIDGETS/DIALOGUES/log_out_dialogue.dart';
import 'package:money_maker/WIDGETS/DIALOGUES/refering_ensure_dialogue.dart';

class DialogueUtils {
  static void showDialogue(BuildContext context, String text,
      {dynamic arguments}) {
    switch (text.toLowerCase()) {
      case 'referconfirm':
        showReferralCodeConfirmationDialogue(
            context: context, onConfirm: arguments[0]);
      case 'logout':
        showLogoutDialogue(context: context);
      default:
        break;
    }
  }
}
