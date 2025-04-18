import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';

@singleton
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  ConnectivityService() {
    log('Inicjalizacja ConnectivityService');
  }

  Stream<ConnectivityResult> get connectivityStream {
    log('Tworzenie connectivityStream');
    return _connectivity.onConnectivityChanged.asyncExpand((list) {
      log('connectivityStream emituje listę: $list');
      return Stream.fromIterable(list);
    });
  }

  Future<bool> isConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      log('checkConnectivity wynik: $connectivityResult');
      if (connectivityResult == ConnectivityResult.none) {
        log('checkConnectivity wskazuje brak połączenia');
        return false;
      }

      final pingResult = await InternetAddress.lookup('google.com').timeout(
        Duration(seconds: 3),
        onTimeout: () {
          log('Ping do google.com nieudany (timeout)');
          return [];
        },
      );
      final isPingSuccessful =
          pingResult.isNotEmpty && pingResult[0].rawAddress.isNotEmpty;
      log('Ping do google.com: $isPingSuccessful');

      final isConnected = isPingSuccessful;
      log('isConnected wynik: $isConnected');
      return isConnected;
    } catch (e) {
      log('Błąd w isConnected: $e');
      return false;
    }
  }
}
