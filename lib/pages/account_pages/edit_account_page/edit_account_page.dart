import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_learning_app/blocs/account_bloc/account_bloc.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';
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

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.avatarLink,
    required this.onChangeImage,
    super.key,
  });

  final String? avatarLink;
  final Function(String) onChangeImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0,
      child: InkWell(
        onTap: () async {
          log('*** choice photo');
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: ImageSource.gallery,
          );
          if (image != null) {
            onChangeImage(image.path);
/*            setState(() {
              widget.linkToImage = image.path;
              print(image.path);
            });*/
          } else {
            log('*** image not choiced');
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CustomImageViewer(
              link: avatarLink,
              alternativePhoto: AppImages.empty_avatar,
              boxFitNetworkImage: BoxFit.fitHeight,
            ),
/*            Container(
              // width: 96.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.black26,
              ),
            ),*/
            SvgPicture.asset(
              AppIcons.camera_contour,
            ),
          ],
        ),
      ),
    );
  }
}

class UserNameTextField extends StatelessWidget {
  const UserNameTextField({
    required this.userName,
    required this.nameController,
    super.key,
  });

  final String userName;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.inverseSurface,
        hintText: 'Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          // gapPadding: 16.0,
        ),
      ),
    );
  }
}
