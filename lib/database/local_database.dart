import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:online_learning_app/models/users/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class _ClearStorage {
  const _ClearStorage._();

  static const _ClearStorage instance = _ClearStorage._();

  Future<File> get _localFile async {
    final Directory directory = await getTemporaryDirectory();
    final String path = directory.path;
    return File('$path/first_launch.txt');
  }

  Future<bool?> readLaunch() async {
    try {
      final File file = await _localFile;
      final String content = await file.readAsString();
      return content.isNotEmpty ? false : null;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeLaunch(bool launch) async {
    final File file = await _localFile;
    return file.writeAsString('$launch');
  }
}

class LocalDB {
  const LocalDB._();

  static const String _authBox = 'authBox';
  static const String _notificationsBox = '_notificationsBox';
  static const LocalDB instance = LocalDB._();

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_authBox);
    await Hive.openBox<String>(_notificationsBox);
  }

  Future<void> ensureInitialized() async {
    await _initializeHive();

    const _ClearStorage clearStorage = _ClearStorage.instance;
    final bool? isFirst = await clearStorage.readLaunch();

    if (isFirst != null) return;

    await saveUser(UserModel());
    await clearStorage.writeLaunch(false);
  }

  // [START] User

  Future<void> saveUser(UserModel user) async {
    final Box<String> authBox = Hive.box(_authBox);
    await authBox.put('authUser', jsonEncode(user.toJson()));
  }

  UserModel getUser() {
    final Box<String> authBox = Hive.box(_authBox);
    return UserModel.fromJson(
      jsonDecode(authBox.get('authUser')!),
    );
  }

  // ******

  Future<void> setFlagNoFirst() async {
    final Box<String> authBox = Hive.box(_authBox);
    await authBox.put('isFirst', 'false');
  }

  String? getFlagIsFirst() {
    final Box<String> authBox = Hive.box(_authBox);
    return authBox.get('isFirst');
  }

  // ******

  Future<void> saveNotifications(String json, String userUid) async {
    final Box<String> notificationsBox = Hive.box(_notificationsBox);
    await notificationsBox.put('notifications_$userUid', json);
  }

  String? getNotifications(String userUid) {
    final Box<String> notificationsBox = Hive.box(_notificationsBox);
    String key = 'notifications_$userUid';
    String? value = notificationsBox.get(key);
    // log('*** key:$key, value: $value');
    return value;
  }

// ******

  Future<void> saveTimeLastSeenNotification(
    String timeLastSeenNotification,
  ) async {
    final Box<String> notificationsBox = Hive.box(_notificationsBox);
    await notificationsBox.put(
      'timeLastSeenNotification',
      timeLastSeenNotification,
    );
  }

  String? getTimeLastSeenNotification() {
    final Box<String> notificationsBox = Hive.box(_notificationsBox);
    return notificationsBox.get('timeLastSeenNotification');
  }
}
