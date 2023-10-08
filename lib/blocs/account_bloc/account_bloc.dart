import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/models/account_model/account_model.dart';
import 'package:online_learning_app/services/firestore_account_service.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountState()) {
    MyFirestoreAccountService accountService = MyFirestoreAccountService();

    on<OnChangeUserAvatar>(
      (event, emit) async {
        AccountModel accountModel = state.accountModel.copyWith(
          avatarLink: event.newUserAvatar,
        );
        accountService.pushAccountModel(
          accountModel: accountModel,
        );
        emit(
          state.copyWith(
            accountModel: accountModel,
          ),
        );
      },
    );

    on<OnChangeUserName>(
      (event, emit) async {
        AccountModel accountModel = state.accountModel.copyWith(
          name: event.newName,
        );
        accountService.pushAccountModel(
          accountModel: accountModel,
        );
        emit(
          state.copyWith(
            accountModel: accountModel,
          ),
        );
      },
    );

    on<GetAccountModel>(
      (event, emit) async {
        AccountModel accountModel = await accountService.getAccountModel();
        emit(
          state.copyWith(
            accountModel: accountModel,
          ),
        );
      },
    );

/*    on<SomeEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            counter: event.counter,
          ),
        );
      },
    );*/
  }
}
