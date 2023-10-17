part of 'account_bloc.dart';


@immutable
class AccountState extends Equatable {
  const AccountState({
    this.accountModel = const AccountModel.empty(),
  });

  final AccountModel accountModel;

  @override
  List<Object?> get props => [
        accountModel,
      ];

  AccountState copyWith({
    AccountModel? accountModel,
  }) {
    return AccountState(
      accountModel: accountModel ?? this.accountModel,
    );
  }
}
