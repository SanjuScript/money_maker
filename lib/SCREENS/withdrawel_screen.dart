import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_maker/FUNCTIONS/coin_data.dart';
import 'package:money_maker/FUNCTIONS/withdrawel_management.dart';
import 'package:money_maker/HELPER/asset_helper.dart';
import 'package:money_maker/WIDGETS/TEXTS/helper_1.dart';

class CoinWithdrawelPage extends StatefulWidget {
  const CoinWithdrawelPage({super.key});

  @override
  State<CoinWithdrawelPage> createState() => _CoinWithdrawelPageState();
}

class _CoinWithdrawelPageState extends State<CoinWithdrawelPage> {
  TextEditingController upiController = TextEditingController();

  late Future<int> coinCount;
  int selectedAmount = 100;
  Future<bool?>? pending;
  final List<int> withdrawelOptions = [100, 150, 200, 250, 500, 1000];

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();
    coinCount = CoinData.getCoinCount();
    pending = WithdrawelManager.getLastWithdrawalStatus();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const HelperText1(
          text: "Withdraw Coins",
          color: Colors.black87,
          fontSize: 25,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Section

            Center(
              child: FutureBuilder<bool?>(
                  future: pending,
                  builder: (context, snap) {
                    if (snap.hasData && snap != null && snap != true) {
                      return Container(
                        height: size.height * .04,
                        width: size.width * .90,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent, // Red background
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons
                                    .hourglass_empty, // You can choose any icon you want
                                color: Colors.white,
                                size: 20.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                " Withdrawel Processing...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(10.0), // Padding inside the badge
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text("Your current balance"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        GetAssetFile.coinIcon,
                        height: size.height * .10,
                        width: size.width * .10,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      FutureBuilder<int>(
                        future: CoinData.getCoinCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent),
                                strokeWidth: 2,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                'Error',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            );
                          } else {
                            final coinCount = snapshot.data ?? 0;
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                '$coinCount',
                                key: ValueKey<int>(
                                    coinCount), // Key to trigger animation on coin count change
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coin to Currency Conversion:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '10 Coins = 1 INR',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Withdraw your coins easily by following the policy below:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Withdrawal Policy Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Withdrawal Policy:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '• Minimum withdrawal amount: 100 INR\n'
                    '• Withdrawal fee: 5% of the total withdrawal amount\n'
                    '• Processing time: 1-2 business days\n'
                    '• Users can only withdraw once per week.\n'
                    '• Ensure you have a valid payment method linked to your account.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Amount to Withdraw:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: withdrawelOptions.map((amount) {
                      final isSelected = selectedAmount == amount;
                      return GestureDetector(
                        key: ValueKey(amount),
                        onTap: () {
                          setState(() {
                            selectedAmount = amount;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.blueAccent.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            '₹ $amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black87 : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        controller: upiController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueAccent.withOpacity(0.6),
                          hintText: 'Enter your UPI ID',
                          hintStyle: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      int coins = await coinCount;
                      double? amount = selectedAmount.toDouble();

                      if (amount == null || amount < 100) {
                        showToast("Please select a valid amount (min 100 INR)");
                        return;
                      }

                      if (upiController.text.isEmpty ||
                          !isValidUpiId(upiController.text.trim())) {
                        showToast("Please enter a valid UPI ID");
                        return;
                      }

                      if ((amount * 10) > coins) {
                        showToast("Insufficient coins");
                        return;
                      }
                      bool isAllowed =
                          await WithdrawelManager.isWithdrawalAllowed();
                      if (!isAllowed) {
                        Fluttertoast.showToast(
                          msg:
                              "Withdrawal attempt blocked. Less than 7 days since last withdrawal.",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                        return;
                      }
                      int newCoin = coins - (amount * 10).toInt();
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Prevent dismissing the dialog by tapping outside
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      try {
                        log("New Coin Balance: $newCoin");
                        await WithdrawelManager.widthrawAmount(
                          amount: selectedAmount,
                          coins: coins,
                          newCoins: newCoin,
                          upiID: upiController.text.trim()
                        );
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Withdrawal Submitted"),
                            content: const Text(
                                "Your withdrawal request has been submitted successfully. You will be notified once it's processed."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                  Navigator.pop(
                                      context); // Navigate back to the previous screen
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                        Future.delayed(const Duration(seconds: 3), () {
                          setState(() {});
                        });
                        Fluttertoast.showToast(
                          msg: "Withdrawal successful",
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      } catch (e) {
                        Navigator.pop(context);

                        log("Error submitting withdrawal request: $e");

                        showToast("An error occurred. Please try again.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Withdraw Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidUpiId(String upiId) {
    final RegExp upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
    if (upiId.isEmpty) {
      return false;
    }
    return upiRegex.hasMatch(upiId);
  }
}
