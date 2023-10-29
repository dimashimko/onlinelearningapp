import 'dart:async';

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
      onChangeConnectionState(
        result != ConnectivityResult.none,
      );
    });
    _checkConnectivity();
  }

  void checkNow() {
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    ConnectivityResult result = await (Connectivity().checkConnectivity());

    onChangeConnectionState(
      result != ConnectivityResult.none,
    );
  }

/*  void checkChanges(){

  }*/

  void dispose() {
    connectivityStreamSubscription?.cancel();
  }
}
