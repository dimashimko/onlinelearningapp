part of 'account_bloc.dart';

abstract class AccountEvent {
  const AccountEvent();
}

class OnChangeUserAccount extends AccountEvent {
  const OnChangeUserAccount({
    required this.newName,
    required this.newAvatarLocalLink,
  });

  final String? newName;
  final String? newAvatarLocalLink;
}

class GetAccountModel extends AccountEvent {}

class InitAccountBlocEvent extends AccountEvent {}
