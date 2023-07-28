import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/auth_pages/sign_in_page/sign_in_page.dart';
import 'package:online_learning_app/services/auth_service.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  // static const routeName = '/home_pages/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goToSignInPage() async {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      SignInPage.routeName,
      (_) => false,
      arguments: SignInPageArguments(
        isFirst: false,
      ),
    );
  }

  firebaseSignOut(BuildContext context) {
    AuthService.signOut();
    _goToSignInPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('HomePage'),
              const Spacer(),
              CustomButton(
                title: 'LogOut',
                onTap: () {
                  firebaseSignOut(context);
                  // log('*** name: ${ModalRoute.of(context)?.settings.name}');
                  // Navigator.of(context).
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget HomePageAppBar() {
  return const CustomAppBar(
    title: Text('HomePage'),
    action: Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
