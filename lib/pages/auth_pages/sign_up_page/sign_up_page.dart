import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/pages/auth_pages/log_in_page/log_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/verify_phone_page/verify_phone_page.dart';
import 'package:online_learning_app/pages/auth_pages/widgets/authFormFields.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/services/auth_service.dart';
import 'package:online_learning_app/utils/showCustomSnackBar.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_error_text.dart';
import 'package:online_learning_app/widgets/elements/custom_text_form.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  static const routeName = '/auth_pages/sign_up_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  void _goToLogInPage(BuildContext context) {
    _navigateToPage(
      context: context,
      route: LogInPage.routeName,
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

  void _goToMainPage() async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainPage.routeName,
      (_) => false,
    );
  }

  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // validating
  bool acceptPrivacyPolicy = false;
  String privacyPolicyErrorText = '';

  void onTapCreateAccount() async {
    bool isAcceptedPrivacyPolicy = false;
    bool isFormsValid = false;

    setState(() {
      if (_formKey.currentState != null) {
        isFormsValid = _formKey.currentState!.validate();
      }
      isAcceptedPrivacyPolicy = validAcceptedPrivacyPolicy();
    });
    if (isAcceptedPrivacyPolicy && isFormsValid) {
      if (_contactController.text.contains('@')) {
        firebaseSignUpWithEmail();
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

  Future firebaseSignUpWithEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _contactController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _goToMainPage();
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

  bool validAcceptedPrivacyPolicy() {
    bool isValid = true;

    if (!acceptPrivacyPolicy) {
      isValid = false;
      privacyPolicyErrorText = 'You need to take privacy policy';
    } else {
      privacyPolicyErrorText = '';
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: SignUpPageAppBar(
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
                                'Sign Up',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              Text(
                                'Enter your details below & free sign up',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AuthFormFields(
                                    contactController: _contactController,
                                    passwordController: _passwordController,
                                  ),
                                  SizedBox(height: 16.0),
                                  CustomButton(
                                    title: 'Create account',
                                    onTap: () {
                                      onTapCreateAccount();
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomCheckBox(
                                        acceptPrivacyPolicy:
                                            acceptPrivacyPolicy,
                                        changeAcceptPrivacyPolicy:
                                            (newStatusAccept) {
                                          acceptPrivacyPolicy = newStatusAccept;
                                        },
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          'By creating an account you have to agree with our them & condication.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (privacyPolicyErrorText.isNotEmpty)
                                    CustomErrorText(
                                      errorText: privacyPolicyErrorText,
                                    ),
                                  SizedBox(height: 32.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account？',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _goToLogInPage(context);
                                        },
                                        child: Text(
                                          'Log in',
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
                                  )
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

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({
    required this.acceptPrivacyPolicy,
    required this.changeAcceptPrivacyPolicy,
    Key? key,
  }) : super(key: key);

  bool acceptPrivacyPolicy;
  final Function(bool) changeAcceptPrivacyPolicy;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return widget.acceptPrivacyPolicy
        ? InkWell(
            child: const Icon(Icons.check_box),
            onTap: () {
              setState(() {
                widget.acceptPrivacyPolicy = false;
                widget.changeAcceptPrivacyPolicy(widget.acceptPrivacyPolicy);
              });
            },
          )
        : InkWell(
            child: const Icon(Icons.check_box_outline_blank),
            onTap: () {
              setState(() {
                widget.acceptPrivacyPolicy = true;
                widget.changeAcceptPrivacyPolicy(widget.acceptPrivacyPolicy);
              });
            },
          );
    // : Icon(Icons.check_box_outline_blank);
  }
}

PreferredSizeWidget SignUpPageAppBar({
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
