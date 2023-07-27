import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/pages/auth_pages/widgets/authFormFields.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_error_text.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  static const routeName = '/auth_pages/log_in_page';

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  void _navigateToPage({
    required BuildContext context,
    required String route,
    bool isRoot = false,
  }) {
    Navigator.of(
      context,
      rootNavigator: isRoot,
    ).pushReplacementNamed(route);
  }

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _goToSignUpPage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: SignUpPage.routeName,
    );
  }

  void onTapLogin() async {
    bool isValid = false;

    setState(() {
      if (_formKey.currentState != null) {
        isValid = _formKey.currentState!.validate();
      }
    });
    if (isValid) {
      firebaseSignIn();
    }
  }

  Future firebaseSignIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void onTapForgetPassword() {
    log('*** onTapForgetPassword');
  }

  void onTapLoginWithGoogle() {
    log('*** onTapLoginWithGoogle');
  }

  void onTapLoginWithFacebook() {
    log('*** onTapLoginWithFacebook');
  }






  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // validating
  String emailErrorText = '';
  String nameErrorText = '';
  String passwordErrorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: LogInPageAppBar(
        iconColor: Theme.of(context).colorScheme.onBackground,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onTap: () {
          _goToBackPage(context);
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 90,
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 10.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Log In',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              Text(
                                '',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AuthFormFields(
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                  ),
                                  ForgetPasswordButton(
                                    onTapForgetPassword: () {
                                      onTapForgetPassword();
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  CustomButton(
                                    title: 'Log In',
                                    onTap: () {
                                      onTapLogin();
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Don’t have an account? ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _goToSignUpPage(context);
                                        },
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  LoginWithOtherServicesButtons(
                                    onGoogle: () => onTapLoginWithGoogle(),
                                    onFacebook: () => onTapLoginWithFacebook(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginWithOtherServicesButtons extends StatelessWidget {
  const LoginWithOtherServicesButtons({
    required this.onGoogle,
    required this.onFacebook,
    Key? key,
  }) : super(key: key);

  final VoidCallback onGoogle;
  final VoidCallback onFacebook;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Or login with',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Expanded(
              child: Divider(),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: SvgPicture.asset(AppIcons.google),
              onTap: () {
                print('***SignInWith google');
              },
            ),
            const SizedBox(width: 20.0),
            InkWell(
              child: SvgPicture.asset(AppIcons.facebook),
              onTap: () {
                print('***SignInWith facebook');
              },
            ),
          ],
        )
      ],
    );
  }
}

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({
    required this.onTapForgetPassword,
    super.key,
  });

  final VoidCallback onTapForgetPassword;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapForgetPassword,
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          'Forget password?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

PreferredSizeWidget LogInPageAppBar({
  required Color iconColor,
  required Color backgroundColor,
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    backgroundColor: backgroundColor,
    leading: SvgPicture.asset(
      AppIcons.arrow_back,
      colorFilter: ColorFilter.mode(
        iconColor,
        BlendMode.srcIn,
      ),
      // color: Colors.red,
    ),
    onLeading: onTap,
    // title: Text('titleSignUpPage'),
    action: const Text(
      '          ',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
