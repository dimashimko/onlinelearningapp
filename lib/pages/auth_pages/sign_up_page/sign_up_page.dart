import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:online_learning_app/pages/auth_pages/log_in_page/log_in_page.dart';
import 'package:online_learning_app/pages/auth_pages/verify_phone_page/verify_phone_page.dart';
import 'package:online_learning_app/pages/auth_pages/widgets/auth_form_fields.dart';
import 'package:online_learning_app/pages/auth_pages/widgets/successful_registration_dialog.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/utils/show_custom_snack_bar.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_error_text.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
  final _contentFormFieldKey = GlobalKey<FormFieldState>();

  bool acceptPrivacyPolicy = false;
  String privacyPolicyErrorText = '';

  void _successfulRegistration() async {
    context.read<NotificationBloc>().add(
          AddNotificationSuccessfulRegistrationEvent(),
        );
    _showCompleteRegistrationDialog();
  }

  void _showCompleteRegistrationDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessRegistrationDialog(
          onTapDone: () => _goToMainPage(),
        );
      },
    );
  }

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
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          _successfulRegistration();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        Navigator.of(context).pop(); // need for pop CircularProgressIndicator

        showCustomSnackBar(context, e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        _goToVerifyPhonePage(verificationId: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Navigator.of(context).pop();

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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _contactController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (FirebaseAuth.instance.currentUser != null) {
        _successfulRegistration();
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
                                    contentFormFieldKey: _contentFormFieldKey,
                                  ),
                                  const SizedBox(height: 16.0),
                                  CustomButton(
                                    title: 'Create account',
                                    onTap: () {
                                      onTapCreateAccount();
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
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
                                  const SizedBox(height: 32.0),
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
  const CustomCheckBox({
    required this.acceptPrivacyPolicy,
    required this.changeAcceptPrivacyPolicy,
    Key? key,
  }) : super(key: key);

  final bool acceptPrivacyPolicy;
  final Function(bool) changeAcceptPrivacyPolicy;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool acceptPrivacyPolicy = false;

  @override
  Widget build(BuildContext context) {
    return acceptPrivacyPolicy
        ? InkWell(
            child: const Icon(Icons.check_box),
            onTap: () {
              setState(() {
                acceptPrivacyPolicy = false;
                widget.changeAcceptPrivacyPolicy(
                  acceptPrivacyPolicy,
                );
              });
            },
          )
        : InkWell(
            child: const Icon(Icons.check_box_outline_blank),
            onTap: () {
              setState(() {
                acceptPrivacyPolicy = true;
                widget.changeAcceptPrivacyPolicy(
                  acceptPrivacyPolicy,
                );
              });
            },
          );
  }
}
