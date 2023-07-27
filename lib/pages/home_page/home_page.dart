import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';
  // static const routeName = '/home_pages/home_page';


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

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future firebaseSignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomePageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('HomePage'),
              Spacer(),
              CustomButton(
                title: 'LogOut',
                onTap: () {
                  firebaseSignOut();
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
  return CustomAppBar(
    title: const Text('HomePage'),
    action: const Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
