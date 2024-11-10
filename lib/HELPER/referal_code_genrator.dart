import 'package:money_maker/API/auth_api.dart';

String generateReferralCode() {
  String userId = AuthApi.auth.currentUser!.uid;
  return '${userId.substring(0, 6)}${DateTime.now().millisecondsSinceEpoch % 1000}';
}
