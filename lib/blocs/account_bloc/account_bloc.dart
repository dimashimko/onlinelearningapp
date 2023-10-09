import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/models/account_model/account_model.dart';
import 'package:online_learning_app/services/firebase_storage_service.dart';
import 'package:online_learning_app/services/firestore_account_service.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountState()) {
    MyFirestoreAccountService accountService = MyFirestoreAccountService();
    FirebaseStorageServices storageServices = FirebaseStorageServices();

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

    Future<String?> submitToStorage(String? newAvatarLocalLink) async {
      if (newAvatarLocalLink == null) return null;
      if (newAvatarLocalLink.isEmpty) return null;
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference? reference = await storageServices.submitToStorage(
        newAvatarLocalLink,
        fileName,
        'avatars',
      );
      if (reference == null) return null;
      String newURL = await reference.getDownloadURL();

      return newURL;
    }

    on<OnChangeUserAccount>(
      (event, emit) async {
        String name = event.newName ?? '';
        String avatarLink = event.newAvatarLocalLink ?? '';

        // check name

        // check avatar
        if (state.accountModel.avatarLink != event.newAvatarLocalLink) {
          String? newURL = await submitToStorage(
            event.newAvatarLocalLink,
          );
          if (newURL != null) {
            avatarLink = newURL;
          }
        }

        AccountModel accountModel = state.accountModel.copyWith(
          name: name,
          avatarLink: avatarLink,
        );

        if (state.accountModel != accountModel) {
          accountService.pushAccountModel(
            accountModel: accountModel,
          );
          emit(
            state.copyWith(
              accountModel: accountModel,
            ),
          );
        }
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
