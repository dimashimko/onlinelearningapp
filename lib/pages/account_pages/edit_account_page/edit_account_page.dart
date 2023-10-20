import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/account_bloc/account_bloc.dart';
import 'package:online_learning_app/pages/account_pages/edit_account_page/widgets/user_avatar.dart';
import 'package:online_learning_app/pages/account_pages/edit_account_page/widgets/username_text_field.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  static const routeName = '/account_pages/edit_account_page';

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final TextEditingController nameController = TextEditingController();
  String? avatarLink;

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onTapSave() {
    context.read<AccountBloc>().add(
          OnChangeUserAccount(
            newName: nameController.text,
            newAvatarLocalLink: avatarLink,
          ),
        );
    _goToBackPage(context);
  }

  void _onChangeImage(String newPath) {
    setState(() {
      avatarLink = newPath;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(
          GetAccountModel(),
        );
    avatarLink = context.read<AccountBloc>().state.accountModel.avatarLink;
    String? userName = context.read<AccountBloc>().state.accountModel.name;
    nameController.text = userName ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // fluter 2.x

      appBar: const CustomAppBarDefault(
        title: 'Edit account',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 0.0,
                    width: double.infinity,
                  ),
                  UserAvatar(
                    avatarLink: avatarLink,
                    onChangeImage: _onChangeImage,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  UserNameTextField(
                    userName: '',
                    nameController: nameController,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.5,
                    child: CustomButton(
                      title: 'Save',
                      onTap: () => _onTapSave(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
