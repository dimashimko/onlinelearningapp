import 'package:online_learning_app/database/local_database.dart';
import 'package:online_learning_app/models/users/user_model.dart';

class LocalRepository {
  const LocalRepository._();

  static const LocalRepository instance = LocalRepository._();

  Future<UserModel> getUser() async{
    return LocalDB.instance.getUser();
  }

  Future<void> saveUser(UserModel userModel) async{
    await LocalDB.instance.saveUser(userModel);
  }
}