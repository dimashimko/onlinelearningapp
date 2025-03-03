import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_learning_app/blocs/account_bloc/account_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/firebase_options.dart';
import 'package:online_learning_app/pages/account_pages/account_page/widgets/account_menu_item.dart';
import 'package:online_learning_app/pages/account_pages/account_page/widgets/title_of_page.dart';
import 'package:online_learning_app/pages/account_pages/edit_account_page/edit_account_page.dart';
import 'package:online_learning_app/pages/account_pages/favorite_page/favorite_page.dart';
import 'package:online_learning_app/pages/account_pages/help_page/help_page.dart';
import 'package:online_learning_app/pages/account_pages/setting_page/setting_page.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const routeName = '/account_page/account_page';

  void _navigateToPage({
    required BuildContext context,
    required String route,
    bool isRoot = false,
    Object? arguments,
  }) {
    Navigator.of(
      context,
      rootNavigator: isRoot,
    ).pushNamed(route, arguments: arguments);
  }

  void _goToFavoritePage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: FavoritePage.routeName,
    );
  }

  void _goToEditAccountPage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: EditAccountPage.routeName,
      isRoot: true,
    );
  }

  void _goToSettingsAndPrivacyPage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: SettingPage.routeName,
      isRoot: true,
    );
  }

  void _goToHelpPage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: HelpPage.routeName,
    );
  }

  void _goToSignInPage(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      SignInPage.routeName,
      (_) => false,
      arguments: SignInPageArguments(
        isFirst: false,
      ),
    );
  }

  void logOut(BuildContext context) async {
    context.read<NotificationBloc>().add(
          ClearNotificationsStateEvent(),
        );
    _goToSignInPage(context);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    ).signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TitleOfPage(),
                    InkWell(
                      onTap: () => _goToEditAccountPage(context),
                      child: SizedBox(
                        height: 96.0,
                        child: CustomImageViewer(
                          link: state.accountModel.avatarLink,
                          alternativePhoto: AppImages.emptyAvatar,
                          boxFitNetworkImage: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    AccountMenuItem(
                      title: 'Favourite',
                      onTap: () => _goToFavoritePage(context),
                    ),
                    AccountMenuItem(
                      title: 'Edit Account',
                      onTap: () => _goToEditAccountPage(context),
                    ),
                    AccountMenuItem(
                      title: 'Settings and Privacy',
                      onTap: () => _goToSettingsAndPrivacyPage(context),
                    ),
                    AccountMenuItem(
                      title: 'Help',
                      onTap: () => _goToHelpPage(context),
                    ),
                    AccountMenuItem(
                      title: 'LogOut',
                      onTap: () => logOut(context),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
