import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_maker/DATA/user_account_data.dart';
import 'package:money_maker/HELPER/ad_helper.dart';
import 'package:money_maker/MODEL/user_account_model.dart';
import 'package:money_maker/MODEL/user_model.dart';
import 'package:money_maker/SECURITY/storage_manager.dart';
import 'package:money_maker/WIDGETS/TEXTS/helper_1.dart';
import 'package:provider/provider.dart';

class CoinEarningScreen extends StatefulWidget {
  const CoinEarningScreen({super.key});

  @override
  _CoinEarningScreenState createState() => _CoinEarningScreenState();
}

class _CoinEarningScreenState extends State<CoinEarningScreen> {
  final int _adsLimit = 3;
  int _timerDuration = 300; // 5 minutes in seconds
  late Timer _timer;
  late Future<UserAccountModel?> _userDataFuture;
  RewardedAd? _rewardedAd;
  bool _isAdLoading = true;
  bool _isTimerActive = false;
  DateTime? _adWatchStartTime; // Store the time when ads were last watched
  int _adsWatched = 0; // To hold current ads watched count

  void _loadUserData() async {
    _userDataFuture = UserAccountData.getAccountData();

    // Fetch the last ad watch time and current ads watched count
    DateTime? lastAdWatchTime = await UserAccountData.getLastAdWatchTime();
    _adsWatched = await UserAccountData.getAdsWatchedCount(); // Get ads watched count

    // Check if more than 5 minutes have passed
    if (lastAdWatchTime != null) {
      final now = DateTime.now();
      if (now.difference(lastAdWatchTime).inMinutes >= 5) {
        // Reset ad count
        await UserAccountData.resetAdsWatched();
        _adsWatched = 0; // Reset local count as well
      } else if (_adsWatched >= _adsLimit) {
        // Disable ad watching if at limit
        Fluttertoast.showToast(msg: "You can only watch 3 ads in a row. Come back after 5 minutes.");
      }
    }
  }

  void _loadRewardedAd() {
    setState(() {
      _isAdLoading = true; // Start loading, show progress indicator
    });

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
            _isAdLoading = false; // Ad loaded, hide progress indicator
          });
        },
        onAdFailedToLoad: (err) {
          setState(() {
            _isAdLoading = false; // Loading failed, hide progress indicator
          });
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  

  void _startTimer() {
    setState(() {
      _isTimerActive = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerDuration > 0) {
        setState(() {
          _timerDuration--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerActive = false; // Stop showing the timer after time's up
          _adWatchStartTime = null; // Reset start time
        });
      }
    });
  }

  void _watchAd() async {
    if (_adsWatched >= _adsLimit) {
      Fluttertoast.showToast(msg: "You can only watch $_adsLimit ads in a row. Come back after 5 minutes.");
      return;
    }

    _adWatchStartTime = DateTime.now(); // Set the start time

    if (_rewardedAd != null) {
      _rewardedAd?.show(
        onUserEarnedReward: (_, reward) async {
          log("User earned reward");
          log(reward.toString());
          try {
            await UserAccountData.incrementCoins(10); // Assuming 10 coins per ad
            await _incrementAdsWatchedToServer(); // Increment the count in Firestore
            _adsWatched++; // Update local ads watched count

            // Check if the limit is reached and start the timer
            if (_adsWatched >= _adsLimit) {
              _startTimer(); // Start 5-minute timer
            }
          } catch (e) {
            log("Error updating coins or ads watched: $e");
          }
        },
      );
    }
  }

  Future<void> _incrementAdsWatchedToServer() async {
    await UserAccountData.incrementAdsWatched(); // Call the method to increment ads watched count in Firestore
  }

  String get timerString {
    final minutes = (_timerDuration ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerDuration % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
@override
  void initState() {
    super.initState();
    _loadRewardedAd();
    _loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _rewardedAd?.dispose();
  }
  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        title:   HelperText1(
          text: "Coin Earning",
          color: Colors.black87,
          fontSize: 25,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserAccountModel?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data.'));
          }

          final userData = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with an image
                Center(
                  child: Image.asset('assets/images/coins.png', width: 100), // Add your coin image here
                ),
                const SizedBox(height: 20),
                // Current Coins Display
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Coins',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${userData!}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Ads Watched Display
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ads Watched',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${userData.adsWatched!}/$_adsLimit',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Conditionally show the timer only if the timer is active
                if (_isTimerActive)
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Time Remaining',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            timerString,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                // Watch Ad Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Button color
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _watchAd,
                    child: const Text(
                      'Watch Ad',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );

  }
}
