import 'package:salesbets/src/common/common.dart';
import 'package:salesbets/src/common/constants/constansts.dart';
import 'package:salesbets/src/common/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class LoginFirebaseRepository {
  final FirebaseAuth _firebaseAuth;
  final PreferencesRepository prefRepo;
  final ApiRepository apiRepo;

  LoginFirebaseRepository({
    FirebaseAuth? firebaseAuth,
    required this.prefRepo,
    required this.apiRepo,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final log = Logger();
  Future<UsersModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userModel = UsersModel.fromFirebaseUser(firebaseUser);

        // Save in preferences
        await prefRepo.savePreference(Constants.store.USER_ID, userModel.id);
        await prefRepo.savePreference(
          Constants.store.USER_NAME,
          userModel.name,
        );
        await prefRepo.savePreference(
          Constants.store.USER_EMAIL,
          userModel.email,
        );
        await prefRepo.savePreference(
          Constants.store.USER_PHONE,
          userModel.phone,
        );
        await prefRepo.savePreference(
          Constants.store.ROLE_ID,
          userModel.roleId,
        );

        return userModel;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    log.d("LoginFirebaseRepository :: signOut ");
    await _firebaseAuth.signOut();
  }

  Future<UsersModel?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        return UsersModel.fromFirebaseUser(firebaseUser);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
