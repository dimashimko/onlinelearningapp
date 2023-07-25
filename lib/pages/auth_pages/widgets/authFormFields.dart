import 'package:flutter/material.dart';
import 'package:online_learning_app/widgets/elements/custom_text_form.dart';

class AuthFormFields extends StatefulWidget {
  const AuthFormFields({
    required this.emailController,
    required this.passwordController,
    super.key,
  });


  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<AuthFormFields> createState() => _AuthFormFieldsState();
}

class _AuthFormFieldsState extends State<AuthFormFields> {
  bool _obscureText1 = true;

  void _togglePassword1Visibility() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Email',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        CustomTextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          hintText: '',
          // inputFormatters: [maskFormatter],
          validator: (value) {
            if (value == null) return null;
            if (value.isEmpty) {
              return 'Enter your email';
            }
            return null;
          },
        ),
        // SizedBox(height: 16.0),
        Text(
          'Password',
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
      ],
    );
  }
}
