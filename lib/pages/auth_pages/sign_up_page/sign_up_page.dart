import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_icons.dart';
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
  void _navigateToPage(BuildContext context, String route, bool isRoot) {
    Navigator.of(context, rootNavigator: isRoot).pushNamed(route);
  }

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText1 = true;

  void _togglePassword1Visibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void onTapRegister() async {
    bool isAcceptedPrivacyPolicy = false;
    bool isValid = false;

    setState(() {
      if (_formKey.currentState != null) {
        isValid = _formKey.currentState!.validate();
      }
      isAcceptedPrivacyPolicy = valid();
    });
    if (isAcceptedPrivacyPolicy && isValid) {}
  }

  bool valid() {
    bool isValid = true;

    if (!acceptPrivacyPolicy) {
      isValid = false;
      privacypolicyErrorText = 'You need to take privacy policy';
    } else {
      privacypolicyErrorText = '';
    }

    return isValid;
  }

  // validating
  bool acceptPrivacyPolicy = false;
  String emailErrorText = '';
  String nameErrorText = '';
  String passwordErrorText = '';
  String privacypolicyErrorText = '';

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
                        height: 120,
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
                                  Text(
                                    'Your Email',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  CustomTextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    hintText: '',
                                    // inputFormatters: [maskFormatter],
                                    validator: (value) {
                                      if (value == null) return null;
                                      if (value.isEmpty) {
                                        return 'Enter your email';
                                      }
/*                            else if (!EmailValidator.validate(value)) {
                                // return 'Phone should be at least 6 characters';
                                return LocaleKeys.email_wrong.tr();
                              }*/
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Password',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  CustomTextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureText1,
                                    suffixIcon: IconButton(
                                      focusNode: FocusNode(skipTraversal: true),
                                      icon: Icon(
                                        _obscureText1
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                      onPressed: _togglePassword1Visibility,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: (String? value) {
                                      if (value == null) return null;
                                      if (value.isEmpty) {
                                        return 'Please enter your password';
                                      } else if (_passwordController
                                              .text.length <
                                          6) {
                                        return 'Password must contain at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  CustomButton(
                                    title: 'Create account',
                                    onTap: () {
                                      onTapRegister();
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
                                              .titleMedium
                                              ?.copyWith(fontSize: 14.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (privacypolicyErrorText.isNotEmpty)
                                    CustomErrorText(
                                      errorText: privacypolicyErrorText,
                                    ),
                                  SizedBox(height: 32.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account？',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontSize: 14.0),
                                      ),
                                      Text(
                                        'Log in',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
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
