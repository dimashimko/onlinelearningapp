import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:online_learning_app/widgets/elements/custom_text_form.dart';

class AuthFormFields extends StatefulWidget {
  const AuthFormFields({
    required this.contactController,
    required this.passwordController,
    required this.contentFormFieldKey,
    this.onTapForgetPassword,
    super.key,
  });

  final TextEditingController contactController;
  final TextEditingController passwordController;
  final GlobalKey<FormFieldState> contentFormFieldKey;
  final VoidCallback? onTapForgetPassword;


  @override
  State<AuthFormFields> createState() => _AuthFormFieldsState();
}

class _AuthFormFieldsState extends State<AuthFormFields> {
  bool _obscureText1 = true;
  bool _isEmail = false;

  void _togglePassword1Visibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.contactController.addListener(() {
      bool oldValue = _isEmail;
      _isEmail = widget.contactController.text.contains('@');
      if (oldValue != _isEmail) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Email or Phone',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(

          controller: widget.contactController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: '',

          validator: _isEmail
              ? (String? value) {
                  if (value == null) return null;
                  if (value.isEmpty) {
                    return 'Enter your email';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Email is incorrect';
                  }
                  return null;
                }
              : (String? value) {
                  if (value == null) return null;
                  value = value.replaceAll(' ', '');
                  return _validatePhoneNumber(value)
                      ? null
                      : 'Phone number must be in the format +xx xxx xxx xx xx';
                },
/*            :  (String? value) {
                  if (value == null) return null;
                  if (value.isEmpty) {
                    return 'Enter your phone or email';
                  }
                  return null;
                },*/
        ),

        if (_isEmail)
          Text(
            'Password',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        if (_isEmail)
          CustomTextFormField(
            controller: widget.passwordController,
            obscureText: _obscureText1,
            suffixIcon: IconButton(
              focusNode: FocusNode(skipTraversal: true),
              icon: Icon(
                _obscureText1 ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: _togglePassword1Visibility,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value == null) return null;
              if (value.isEmpty) {
                return 'Please enter your password';
              } else if (widget.passwordController.text.length < 6) {
                return 'Password must contain at least 6 characters';
              }
              return null;
            },
          ),
        if (_isEmail && widget.onTapForgetPassword != null)
          ForgetPasswordButton(
            onTapForgetPassword: () {
              widget.onTapForgetPassword!();
            },
          ),
      ],
    );
  }
}

bool _validatePhoneNumber(String input) {
  final phoneExp = RegExp(r'^\+\d\d\d\d\d\d\d\d\d\d\d\d$');
  return phoneExp.hasMatch(input);
}

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({
    required this.onTapForgetPassword,
    super.key,
  });

  final VoidCallback onTapForgetPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onTapForgetPassword,
        child: Text(
          'Forget password?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
