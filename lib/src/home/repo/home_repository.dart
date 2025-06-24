import 'package:salesbets/src/common/common.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesbets/src/common/constants/constansts.dart';
import 'package:salesbets/src/common/models/models.dart';

class HomePageRepository {
  final log = Logger();
  final getIt = GetIt.instance;

  final PreferencesRepository pref;
  final ApiRepository apiRepo;

  HomePageRepository({required this.pref, required this.apiRepo});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getHomePageData() async {
    log.d('HomePageRepository ::: getHomePageData called');

    try {
      log.d('Fetching document: home_data/main');
      final doc = await firestore.collection('home_data').doc('main').get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        log.i('Document fetched successfully: $data');
        return data;
      } else {
        log.w('Document "home_data/main" does not exist');
        throw Exception("Document does not exist");
      }
    } catch (error, stacktrace) {
      log.e(
        'Error in getHomePageData: $error',
        error: error,
        stackTrace: stacktrace,
      );
      throw Exception('Error in getting data for HomePage: $error');
    }
  }

  /// 🔹 Add a new bet
  Future<void> addBet(BetModel bet) async {
    try {
      log.d('Adding new bet: ${bet.toJson()}');
      await firestore.collection('betslips').add(bet.toJson());
      log.i('Bet successfully added to Firestore');
    } catch (e, stacktrace) {
      log.e('Failed to add bet: $e', error: e, stackTrace: stacktrace);
      rethrow;
    }
  }

  /// 🔹 Get all placed bets
  Future<List<BetModel>> getAllBets() async {
    try {
      log.d('Fetching all bets from Firestore');

      final snapshot = await firestore.collection('betslips').get();

      // Optional: Log raw document count
      log.i('Total documents found: ${snapshot.docs.length}');

      final bets = snapshot.docs
          .map((doc) => BetModel.fromJson(doc.data(), doc.id))
          .toList();

      // Log all bets in a readable format
      for (final bet in bets) {
        log.i('Bet Loaded: ${bet.toJson()}');
      }

      log.d('Fetched ${bets.length} bets from Firestore successfully.');
      return bets;
    } catch (e, stacktrace) {
      log.e('Error in getAllBets: $e', error: e, stackTrace: stacktrace);
      rethrow;
    }
  }

  Future<UsersModel?> getUserFromPreferences() async {
    try {
      final prefs = pref.getAllPreferences();

      final id = prefs[Constants.store.USER_ID];
      if (id == null || id.isEmpty) {
        log.w("ProfileRepository::No USER_ID in preferences.");
        return null;
      }

      final user = UsersModel(
        id: id,
        name: prefs[Constants.store.USER_NAME] ?? '',
        email: prefs[Constants.store.USER_EMAIL] ?? '',
        phone: prefs[Constants.store.USER_PHONE] ?? '',
        roleId: prefs[Constants.store.ROLE_ID] ?? '',
        createdAt: '',
      );

      log.i("ProfileRepository::Loaded user from preferences: $user");
      return user;
    } catch (error) {
      log.e("ProfileRepository::getUserFromPreferences::Error: $error");
      return null;
    }
  }
}
