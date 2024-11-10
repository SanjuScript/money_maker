import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:money_maker/API/auth_api.dart';

class DeviceInfoHelper {
  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); 
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id ?? 'unknown';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    } else {
      return 'unknown';
    }
  }

  static Future<void> storeDeviceId(String deviceId) async {
    final user = AuthApi.auth.currentUser;

    if (user != null) {
      await AuthApi.users.doc(user.uid).set({
        'deviceId': deviceId,
      }, SetOptions(merge: true));
    }
  }
}
