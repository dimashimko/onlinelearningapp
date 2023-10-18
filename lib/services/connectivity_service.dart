import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

class CustomConnectivityService {
  final Function(bool) onChangeConnectionState;
  StreamSubscription<ConnectivityResult>? connectivityStreamSubscription;

  CustomConnectivityService({
    required this.onChangeConnectionState,
  });

  Future<void> init() async {
    connectivityStreamSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      log('*** result: $result');
      onChangeConnectionState(
        result != ConnectivityResult.none,
      );
    });
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    ConnectivityResult result = await (Connectivity().checkConnectivity());
    log('*** result: $result');
    onChangeConnectionState(
      result != ConnectivityResult.none,
    );
  }

  void checkNow(){
    _checkConnectivity();
  }

  void dispose() {
    connectivityStreamSubscription?.cancel();
  }
}
