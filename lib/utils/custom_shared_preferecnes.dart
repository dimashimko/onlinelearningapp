import 'package:shared_preferences/shared_preferences.dart';

Future<bool> loadNotificationEnabled() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isNotificationEnabled') ?? false;
}

void saveNotificationEnabled(bool newState) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isNotificationEnabled', newState);
}