import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/pages/auth_pages/verify_phone_page/verify_phone_page.dart';
import 'package:online_learning_app/pages/auth_pages/widgets/authFormFields.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/services/auth_service.dart';
import 'package:online_learning_app/utils/showCustomSnackBar.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  static const routeName = '/auth_pages/log_in_page';

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  void _goToBackPage() {
    Navigator.of(context).pop();
  }

  void _goToSignUpPage() async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignUpPage.routeName,
      (_) => false,
    );
  }

  void _goToMainPage() async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainPage.routeName,
      (_) => false,
    );
  }

  void _goToVerifyPhonePage({
    required String verificationId,
  }) async {
    Navigator.pushNamed(
      context,
      VerifyPhonePage.routeName,
      arguments: VerifyPhonePageArguments(
        phoneNumber: _contactController.text.trim().replaceAll(' ', ''),
        verificationId: verificationId,
      ),
    );
  }


  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // for validating
  String emailErrorText = '';
  String nameErrorText = '';
  String passwordErrorText = '';

  // METHODS
  void onTapLogin() async {
    bool isValid = false;

    setState(() {
      if (_formKey.currentState != null) {
        isValid = _formKey.currentState!.validate();
      }
    });
    if (isValid) {
    // if (true) {
      if(_contactController.text.contains('@')){
        firebaseSignInWithEmail();
      } else {
        firebaseAuthWithPhone();
      }
      // _goToVerifyPhonePage();
    }
  }

  Future firebaseAuthWithPhone() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _contactController.text.trim().replaceAll(' ', ''),
      verificationCompleted: (PhoneAuthCredential credential) async {
        log("*** verificationCompleted");
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          _goToMainPage();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        log("*** verificationFailed");
        Navigator.of(context).pop();
        log('*** e.code: ${e.code}');
        log('*** e.message: ${e.message}');
        showCustomSnackBar(context, e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        log("*** codeSent");
        _goToVerifyPhonePage(verificationId: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Navigator.of(context).pop();
        log('*** SMS code handling fails');
        showCustomSnackBar(context, 'SMS code handling fails');
      },
    );
  }

  Future firebaseSignInWithEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _contactController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (FirebaseAuth.instance.currentUser != null) {
        _goToMainPage();
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      log('*** e.code: ${e.code}');
      log('*** e.message: ${e.message}');
      showCustomSnackBar(context, e.message);
    } catch (e) {
      log('*** Unhandled error: ${e.toString()}');
      showCustomSnackBar(context, 'SomeError');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: LogInPageAppBar(
        iconColor: Theme.of(context).colorScheme.onBackground,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onTap: () {
          _goToBackPage();
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
                                    contactController: _contactController,
                                    passwordController: _passwordController,
                                    onTapForgetPassword: onTapForgetPassword,
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
                                          _goToSignUpPage();
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
                log('***SignInWith google');
              },
            ),
            const SizedBox(width: 20.0),
            InkWell(
              child: SvgPicture.asset(AppIcons.facebook),
              onTap: () {
                log('***SignInWith facebook');
              },
            ),
          ],
        )
      ],
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
