import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUserStreaks(
    String userId,
    int longestPerfectStreak,
    String habitId,
    int habitSpecificLongestStreak,
  ) async {
    await _db.collection('users').doc(userId).set({
      'longestPerfectStreak': longestPerfectStreak,
    }, SetOptions(merge: true));

    await _db
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId)
        .set({
          'longestStreak': habitSpecificLongestStreak,
        }, SetOptions(merge: true));
  }

  // TODO: Implement the logic to show the 'New Achievement Unlocked' popup
  void showNewAchievementPopup() {
    print('New Achievement Unlocked!');
  }
}
