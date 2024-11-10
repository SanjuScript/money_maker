import 'dart:io';

class AdHelper {
  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return '<YOUR_ANDROID_BANNER_AD_UNIT_ID>';
  //   } else if (Platform.isIOS) {
  //     return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }

  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>';
  //   } else if (Platform.isIOS) {
  //     return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  //}

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
//ca-app-pub-8338859460861716/9785460523 - OG
