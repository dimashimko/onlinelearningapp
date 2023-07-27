import 'package:online_learning_app/database/local_database.dart';
import 'package:online_learning_app/models/users/user_model.dart';

bool isAuthorized() {
  final UserModel user = LocalDB.instance.getUser();
  return user.accessToken != null;
}

Future<bool?> localRequest({
  int seconds = 3,
  isSuccess = true,
}) async {
  await Future.delayed(
    Duration(seconds: seconds),
  );

  if (isSuccess) return isSuccess;

  return null;
}
