import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_learning_app/resources/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.inputFormatters,
    this.suffixIcon,
    this.textInputAction = TextInputAction.none,
    this.validator,
    this.hintStyle = const TextStyle(
      color: AppColors.gray,
    ),
    this.borderRadius = 16.0,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool obscureText;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final double borderRadius;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.left,
      key: widget.key,

      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      validator: widget.validator,
      maxLines: widget.maxLines,

      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSurface,
        errorStyle: const TextStyle(
          height: 1.0,
          fontSize: 12,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          borderSide: BorderSide(

            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          borderSide: BorderSide(

            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,

          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),

        helperText: '',
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        suffixIcon: widget.suffixIcon,


      ),

    );
  }
}
