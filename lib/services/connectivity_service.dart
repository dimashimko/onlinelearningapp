import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CustomConnectivityService {
  final Function(bool) onChangeConnectionState;
  StreamSubscription<InternetStatus>? listener;

  CustomConnectivityService({
    required this.onChangeConnectionState,
  });

  Future<void> init() async {
    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      onChangeConnectionState(status == InternetStatus.connected);
    });
  }

  void checkNow() {
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    bool result = await InternetConnection().hasInternetAccess;

    onChangeConnectionState(
      result,
    );
  }

  void dispose() {
    listener?.cancel();
  }
}
