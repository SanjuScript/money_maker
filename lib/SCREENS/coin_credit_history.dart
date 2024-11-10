import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_maker/FUNCTIONS/coin_history_functions.dart';
import 'package:money_maker/HELPER/asset_helper.dart';
import 'package:money_maker/MODEL/coin_transaction_model.dart';
import 'package:money_maker/WIDGETS/TEXTS/helper_1.dart';

class CoinCreditHistory extends StatelessWidget {
  CoinCreditHistory({super.key});

  final Map<String, String> iconMap = {
    'Daily Bonus': GetAssetFile.dailyIcon,
    'Referral Bonus': GetAssetFile.refIcon,
    'Ad Reward': GetAssetFile.adIcon,
  };

  final String fallbackIcon = GetAssetFile.fallbackIcon;

  Future<List<CoinTransactionModel>> _fetchCoinHistory() {
    return CoinHistoryManager.getCoinHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HelperText1(
          text: "Coin Credit History",
          color: Colors.black87,
          fontSize: 25,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<CoinTransactionModel>>(
          future: _fetchCoinHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No transactions found."));
            }

            final coinCreditHistory = snapshot.data!;

            return ListView.builder(
              itemCount: coinCreditHistory.length,
              itemBuilder: (context, index) {
                final historyItem = coinCreditHistory[index];
                final creditName = historyItem.name;
                final iconPath = iconMap.containsKey(creditName)
                    ? iconMap[creditName]
                    : fallbackIcon;

                return Card(
                  elevation: 2,
                  shadowColor: Colors.blueAccent.withOpacity(.2),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.blue.shade50,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: SvgPicture.asset(
                        iconPath!,
                        width: 30,
                        height: 30,
                        color: Colors.blueAccent,
                      ),
                    ),
                    title: Text(
                      historyItem.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Text(
                      _formatDate(historyItem.time!),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    trailing: Text(
                      '+${historyItem.coins} Coins',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
