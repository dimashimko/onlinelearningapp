import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/auth_pages/verify_phone_page/verify_phone_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationWidget extends StatefulWidget {
  const PinCodeVerificationWidget({
    required this.textEditingController,
    Key? key,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  PinCodeVerificationWidgetState createState() =>
      PinCodeVerificationWidgetState();
}

class PinCodeVerificationWidgetState extends State<PinCodeVerificationWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: PinCodeTextField(
          readOnly: true,
          showCursor: false,
          animationType: AnimationType.none,
          appContext: context,
          length: VerifyPhonePage.pinLength,
          blinkDuration: const Duration(milliseconds: 0),
          textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          pinTheme: PinTheme(
            activeColor: Theme.of(context).colorScheme.outline,
            selectedColor: Theme.of(context).colorScheme.outline,
            inactiveColor: Theme.of(context).colorScheme.outline,
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(16),
            fieldHeight: 50,
            fieldWidth: 40,
          ),
          cursorColor: Colors.black,
          controller: widget.textEditingController,
          keyboardType: TextInputType.number,
          onChanged: (value) {},
        ),
      ),
    );
  }
}