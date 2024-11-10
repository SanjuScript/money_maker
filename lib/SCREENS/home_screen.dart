import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:money_maker/DATA/user_data.dart';
import 'package:money_maker/FUNCTIONS/coin_data.dart';
import 'package:money_maker/HELPER/asset_helper.dart';
import 'package:money_maker/MODEL/user_model.dart';
import 'package:money_maker/PROVIDERS/login_auth_provider.dart';
import 'package:money_maker/SCREENS/coin_credit_history.dart';
import 'package:money_maker/SCREENS/earning_screen.dart';
import 'package:money_maker/SCREENS/refering_page.dart';
import 'package:money_maker/SCREENS/withdrawel_screen.dart';
import 'package:money_maker/WIDGETS/DIALOGUES/DIALOGUE_UTILS/dialogue_utils.dart';
import 'package:money_maker/WIDGETS/TEXTS/helper_1.dart';
import 'package:money_maker/WIDGETS/cached_image_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserDataModel?> userDataFuture;
  late Future<int> coinFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      userDataFuture = UserData.getUserData();
      coinFuture = CoinData.getCoinCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final authProvider = Provider.of<LoginAuthProvider>(context);
    log("Home Rebuilding");
    authProvider.addListener(() {
      if (authProvider.user != null) {
        fetchData(); // Refresh user data on account change
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const HelperText1(
          text: "Just Coin",
          color: Colors.black87,
          fontSize: 25,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: FutureBuilder<UserDataModel?>(
          future: userDataFuture,
          builder: (context, snapshot) {
            log('Connection state: ${snapshot.connectionState}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              log('Error fetching user data: ${snapshot.error}');
              return const SizedBox();
            } else if (snapshot.hasData) {
              UserDataModel? userData = snapshot.data;
              if (userData != null) {
                log('Photo URL: ${userData.photoURL}');
                return userData.photoURL != null
                    ? Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 226, 225, 225),
                          shape: BoxShape.circle,
                        ),
                        child: CachedImageWidget(
                          imageUrl: userData.photoURL,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      )
                    : const SizedBox();
              }
            }
            return const SizedBox();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications action
            },
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        height: size.height * .11,
        color: Colors.lightBlue[1000],
        backgroundColor: Colors.blueAccent,
        onRefresh: () async {
          fetchData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: size.height * 0.25,
                  width: size.width * 0.90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.lightBlue,
                        Colors.blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        offset: Offset(5, 5),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your current coins',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              GetAssetFile.coinIcon,
                              height: size.height * .10,
                              width: size.width * .10,
                            ),
                            FutureBuilder<int>(
                              future: coinFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    'Loading...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(color: Colors.white),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(color: Colors.red),
                                  );
                                } else {
                                  final coinCount = snapshot.data ?? 0;
                                  return Text(
                                    '$coinCount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(color: Colors.white),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Options Section
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'What would you like to do?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: size.height * .45,
                child: GridView.count(
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: [
                    _buildOptionCard(
                      context,
                      title: 'Start Earning',
                      icon: Icons.attach_money,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CoinEarningScreen()));
                      },
                    ),
                    _buildOptionCard(
                      context,
                      title: 'Withdraw Money',
                      icon: Icons.money_off,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CoinWithdrawelPage()));
                      },
                    ),
                    _buildOptionCard(
                      context,
                      title: 'View Transactions',
                      icon: Icons.history,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CoinCreditHistory()));
                      },
                    ),
                    _buildOptionCard(
                      context,
                      title: 'Refer a Friend',
                      icon: Icons.person_add,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReferingPage()));
                      },
                    ),
                  ],
                ),
              ),

              Container(
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home, color: Colors.white),
                      onPressed: () {
                        DialogueUtils.showDialogue(context, "logout");
                      },
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
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

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
