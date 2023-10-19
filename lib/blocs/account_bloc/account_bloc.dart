import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/models/account_model/account_model.dart';
import 'package:online_learning_app/services/firebase_storage_service.dart';
import 'package:online_learning_app/services/firestore_account_service.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  MyFirestoreAccountService accountService = MyFirestoreAccountService();
  FirebaseStorageServices storageServices = FirebaseStorageServices();

  AccountBloc() : super(const AccountState()) {
    on<OnChangeUserAccount>(_onChangeUserAccount);
    on<GetAccountModel>(_getAccountModel);
    on<InitAccountBlocEvent>(_initAccountBlocEvent);
  }

  void _onChangeUserAccount(
    OnChangeUserAccount event,
    Emitter<AccountState> emit,
  ) async {
    String name = event.newName ?? '';
    String avatarLink = event.newAvatarLocalLink ?? '';

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
  }

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

  void _getAccountModel(
    GetAccountModel event,
    Emitter<AccountState> emit,
  ) async {
    AccountModel accountModel = await accountService.getAccountModel();
    emit(
      state.copyWith(
        accountModel: accountModel,
      ),
    );
  }

  void _initAccountBlocEvent(
    InitAccountBlocEvent event,
    Emitter<AccountState> emit,
  ) async {
    add(GetAccountModel());
  }
}
