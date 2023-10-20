import 'package:flutter/material.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_keyboard.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class BottomSheetPaymentPassword extends StatefulWidget {
  const BottomSheetPaymentPassword({
    required this.correctPin,
    super.key,
  });

  static const pinLength = 6;

  final String correctPin;

  @override
  State<BottomSheetPaymentPassword> createState() => _BottomSheetPaymentPasswordState();
}

class _BottomSheetPaymentPasswordState extends State<BottomSheetPaymentPassword> {
  final TextEditingController _pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _onTapVerifyAndPay(BuildContext context) {
    if (_formKey.currentState != null) {
      bool isValid = _formKey.currentState!.validate();
      if (isValid) {
        Navigator.pop(context, true);
      }
    }
  }

  String? pinValidator(String? text) {
    if (text != widget.correctPin) return 'Pin is incorrect';

    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _pinController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 24,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  Text(
                    'Payment Password',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 24.0,
                        ),
                  ),
                  Text(
                    'Please enter the payment password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  PinCodeVerificationWidget(
                    textEditingController: _pinController,
                    formKey: _formKey,
                    pinValidator: pinValidator,
                  ),
                  SizedBox(
                    width: 200,
                    child: CustomButton(
                      title: 'Verify and pay',
                      onTap: () {
                        _onTapVerifyAndPay(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CustomKeyboard(
                    pinController: _pinController,
                    pinLength: BottomSheetPaymentPassword.pinLength,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PinCodeVerificationWidget extends StatefulWidget {
  const PinCodeVerificationWidget({
    required this.textEditingController,
    required this.formKey,
    required this.pinValidator,
    Key? key,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final GlobalKey formKey;
  final String? Function(String?)? pinValidator;
  static const pinLength = 6;

  @override
  PinCodeVerificationWidgetState createState() =>
      PinCodeVerificationWidgetState();
}

class PinCodeVerificationWidgetState extends State<PinCodeVerificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: PinCodeTextField(
          readOnly: true,
          showCursor: false,
          obscureText: true,
          animationType: AnimationType.none,
          appContext: context,
          length: PinCodeVerificationWidget.pinLength,
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
          validator: widget.pinValidator,
          autovalidateMode: AutovalidateMode.disabled,
          errorTextSpace: 24.0,
        ),
      ),
    );
  }
}
