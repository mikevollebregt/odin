import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/database/database.dart';
import '../repositories/device_repository.dart';
import '../repositories/log_repository.dart';
import '../repositories/network/auth_api.dart';
import 'generic_notifier.dart';
import 'loading_notifier.dart';

class AuthNotifier extends StateNotifier<NotifierState> {
  final AuthApi _authApi;
  final Database _database;
  final LoadingNotifier _loadingNotifier;
  final DeviceRepository _deviceRepository;
  bool userNameCorrect = false;
  bool isTimeLocked = false;
  DateTime lastAttempt = DateTime.now();
  DateTime thisAttempt = DateTime.now();
  bool passwordCorrect = false;
  int attempts = 2;

  AuthNotifier(this._authApi, this._database, this._loadingNotifier, this._deviceRepository) : super(const Initial());

  Future<bool> authenticate(String userName, String password) async {
    var result = false;
    print('Authenticate');
    try {
      state = const Loading();
      //final credentials = await _authApi.signup('poco', 'test@test.nl', 'test');
      await logAuth('userName [$userName], password [$password]');
      final response = await _authApi.login(userName, password);

      if (response.statusCode == 401) {
        final infoString = response.infoMessages.split(',');
        userNameCorrect = infoString[0] == 'true';
        isTimeLocked = infoString[1] == 'true';
        lastAttempt = DateTime.parse(infoString[2].split('.')[0].trim());
        thisAttempt = DateTime.parse(infoString[3].split('.')[0].trim());
        attempts = int.parse(infoString[4]);
        print('Username is $userNameCorrect, isTimeLocked is $isTimeLocked, attempts is $attempts and last attempted to login is $lastAttempt');
        state = const Loaded(null);
        return result;
      }

      if (response.payload == null) {
        state = const Loaded(null);
        return result;
      }

      await _deviceRepository.checkIfDeviceIsStored();
      await logAuth('response [${response.payload!.token}] and statusCode [${response.statusCode}]');

      result = true;
      userNameCorrect = true;
      passwordCorrect = true;
      state = const Loaded(null);
    } catch (error) {
      await logAuth('$error');
      print('Error [$error]');
      state = const Error('Error');
      return result;
    }

    return result;
  }

  Future<void> logout() async {
    await this._database.tokensDao.clean();
    await _loadingNotifier.isLoggedIn();
  }
}
