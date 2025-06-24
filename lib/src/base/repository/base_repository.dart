import 'package:salesbets/src/common/common.dart';
import 'package:salesbets/src/common/constants/constansts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:salesbets/src/common/models/models.dart';

class BaseRepository {
  final log = Logger();
  final ApiRepository apiRepo;
  final PreferencesRepository prefRepo;

  BaseRepository({required this.apiRepo, required this.prefRepo});

  String _permissionKey(String userId, String email) {
    return 'permission_${userId}_$email';
  }

  Future<bool> checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    log.d('Microphone permission status: $status');
    return status.isGranted;
  }

  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    log.d('Microphone permission request result: $status');
    return status.isGranted;
  }

  Future<bool> ensureMicrophonePermission(String userId, String email) async {
    final hasPermission = await checkMicrophonePermission();
    if (hasPermission) {
      await prefRepo.savePreference(_permissionKey(userId, email), 'true');
      return true;
    }

    final requested = await requestMicrophonePermission();

    await prefRepo.savePreference(
      _permissionKey(userId, email),
      requested ? 'true' : 'false',
    );
    return requested;
  }

  Future<Map<String, bool>> isAppInit(String userId, String email) async {
    Map<String, bool> initMap = {};
    try {
      log.d("BaseRepository:::isAppInit for user $userId, $email");

      final permissionString =
          await prefRepo.getPreference(_permissionKey(userId, email)) ??
          "false";
      final initializedString =
          await prefRepo.getPreference(Constants.store.INITIALIZED) ?? "false";

      initMap[Constants.store.PERMISSION] =
          permissionString.toLowerCase() == 'true';
      initMap[Constants.store.INITIALIZED] =
          initializedString.toLowerCase() == 'true';

      log.d(
        "BaseRepository::isAppInit: permission=${initMap[Constants.store.PERMISSION]}, initialized=${initMap[Constants.store.INITIALIZED]}",
      );
    } catch (error) {
      log.e("BaseRepository:::isAppInit:Error::$error");
    }

    return initMap;
  }

  Future<void> saveUserToPreferences(UsersModel user) async {
    try {
      log.d("BaseRepository::saveUserToPreferences:: ${user.toJson()}");
      await prefRepo.savePreference(Constants.store.USER_ID, user.id);
      await prefRepo.savePreference(Constants.store.USER_NAME, user.name);
      await prefRepo.savePreference(Constants.store.USER_EMAIL, user.email);
      await prefRepo.savePreference(Constants.store.USER_PHONE, user.phone);
      await prefRepo.savePreference(Constants.store.ROLE_ID, user.roleId);
    } catch (e) {
      log.e("BaseRepository::saveUserToPreferences error: $e");
    }
  }

  Future<UsersModel?> getUserFromPreferences() async {
    try {
      final id = await prefRepo.getPreference(Constants.store.USER_ID);
      if (id == null || id.isEmpty) return null;

      return UsersModel(
        id: id,
        name: await prefRepo.getPreference(Constants.store.USER_NAME) ?? '',
        email: await prefRepo.getPreference(Constants.store.USER_EMAIL) ?? '',
        phone: await prefRepo.getPreference(Constants.store.USER_PHONE) ?? '',
        roleId: await prefRepo.getPreference(Constants.store.ROLE_ID) ?? '',
        createdAt: '',
      );
    } catch (e) {
      log.e("BaseRepository::getUserFromPreferences error: $e");
      return null;
    }
  }
}
