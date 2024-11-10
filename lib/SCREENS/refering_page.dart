import 'package:flutter/material.dart';
import 'package:money_maker/DATA/user_data.dart';
import 'package:money_maker/HELPER/asset_helper.dart';
import 'package:money_maker/WIDGETS/TEXTS/helper_1.dart';
import 'package:share_plus/share_plus.dart';

class ReferingPage extends StatefulWidget {
  const ReferingPage({super.key});

  @override
  State<ReferingPage> createState() => _ReferingPageState();
}

class _ReferingPageState extends State<ReferingPage> {
  void shareReferralCode() async {
    // Fetch the referral code
    String? referralCode = await UserData.getUserReferralCode();

    // Check if the referral code was successfully retrieved
    if (referralCode != null) {
      String message = '''
✨ Earn Rewards with Me! ✨
🎉 Join on this app and earn 30 coins instantly! 🎉
👉 Use my referral code: *$referralCode*

Download the app now and enter the code during signup to earn exclusive rewards! 🚀

Download here: [App Link]
''';
      Share.share(message);
    } else {
      // If retrieval failed, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to retrieve referral code. Please try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const HelperText1(
          text: "Earn by Referring",
          color: Colors.black87,
          fontSize: 25,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Invite Friends and Earn ₹2.5",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Get 25 coins for every friend who signs up using your referral code!",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        GetAssetFile.referer,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        shareReferralCode();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Share Your Referral Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  children: [
                    Text(
                      "How it Works",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.person_add_alt, color: Colors.blue),
                      title: Text("1. Share your referral code"),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle, color: Colors.blue),
                      title: Text("2. Friend signs up using your code"),
                    ),
                    ListTile(
                      leading: Icon(Icons.attach_money, color: Colors.blue),
                      title: Text("3. Earn ₹2 for each successful referral"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
