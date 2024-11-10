class UserAccountModel {
  final int adsWatched;

  UserAccountModel({
    required this.adsWatched,
  });

  factory UserAccountModel.fromFirestore(Map<String, dynamic> data) {
    return UserAccountModel(
      adsWatched: data['adsWatched'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'adsWatched': adsWatched,
    };
  }
}
