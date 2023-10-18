import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_learning_app/pages/auth_pages/sign_up_page/sign_up_page.dart';
import 'package:online_learning_app/pages/auth_pages/verify_phone_page/verify_phone_page.dart';
import 'package:online_learning_app/pages/auth_pages/widgets/authFormFields.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/utils/show_custom_snack_bar.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  static const routeName = '/auth_pages/log_in_page';

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
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
  final _contentFormFieldKey = GlobalKey<FormFieldState>();

  String emailErrorText = '';
  String nameErrorText = '';
  String passwordErrorText = '';

  void onTapLogin() async {
    bool isValid = false;

    setState(() {
      if (_formKey.currentState != null) {
        isValid = _formKey.currentState!.validate();
      }
    });
    if (isValid) {
      if (_contactController.text.contains('@')) {
        firebaseSignInWithEmail();
      } else {
        firebaseAuthWithPhone();
      }
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
      timeout: const Duration(seconds: 3),
      phoneNumber: _contactController.text.trim().replaceAll(' ', ''),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          _goToMainPage();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.of(context).pop();

        showCustomSnackBar(context, e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        _goToVerifyPhonePage(verificationId: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
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
      if (mounted) {
        Navigator.of(context).pop();

        showCustomSnackBar(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'SomeError');
      }
    }
  }

  Future<void> onTapForgetPassword() async {
/*    bool isValid = false;

    setState(() {

      if (_contentFormFieldKey.currentState != null) {
        isValid = _contentFormFieldKey.currentState!.validate();


      }
    });*/

    if (EmailValidator.validate(_contactController.text)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _contactController.text.trim(),
        );
        if (mounted) {
          showCustomSnackBar(
            context,
            'Link to reset your password was sent',
            false,
          );
          Navigator.of(context).pop();
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.of(context).pop();

          showCustomSnackBar(context, e.message);
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop();

          showCustomSnackBar(context, 'SomeError');
        }
      }
    } else {
      showCustomSnackBar(context, 'Email is incorrect');
    }
  }

  Future<void> signInWithGoogle() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        return _goToMainPage();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.of(context).pop();

        showCustomSnackBar(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showCustomSnackBar(context, 'SomeError');
      }
    }
  }

  String prettyPrint(Map json) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }

  Future<void> signInWithFacebook() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile

    if (result.status == LoginStatus.success) {
      try {
        await FacebookAuth.instance.getUserData();

        FacebookAuthProvider.credential(result.accessToken!.token);

        if (FirebaseAuth.instance.currentUser != null) {
          return _goToMainPage();
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.of(context).pop();

          showCustomSnackBar(context, e.message);
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop();
          showCustomSnackBar(context, 'SomeError');
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: const CustomAppBarDefault(
        title: '',
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
                                    contentFormFieldKey: _contentFormFieldKey,
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
                                    onGoogle: () => signInWithGoogle(),
                                    onFacebook: () => signInWithFacebook(),
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
                onGoogle();
              },
            ),
            const SizedBox(width: 20.0),
            InkWell(
              child: SvgPicture.asset(AppIcons.facebook),
              onTap: () {
                onFacebook();
              },
            ),
          ],
        )
      ],
    );
  }
}
