import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/utils/show_custom_snack_bar.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/elements/custom_keyboard.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhonePageArguments {
  VerifyPhonePageArguments({
    required this.phoneNumber,
    required this.verificationId,
  });

  final String phoneNumber;
  final String verificationId;
}

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({
    required this.phoneNumber,
    required this.verificationId,
    Key? key,
  }) : super(key: key);

  static const routeName = '/auth_pages/verify_phone_page';
  static const pinLength = 6;
  final String phoneNumber;
  final String verificationId;

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  void _goToMainPage() async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      MainPage.routeName,
      (_) => false,
    );
  }

  final TextEditingController _pinController = TextEditingController();

  Future<void> _onTapVerify() async {
    final bool isValid =
        _pinController.text.length == VerifyPhonePage.pinLength;

    if (!isValid) {
      showCustomSnackBar(context, 'Pin must contain 6 digits');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _pinController.text.trim(),
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      _goToMainPage();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarDefault(
        title: 'Verify Phone',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 32.0),
              Text('Code is sent to ${widget.phoneNumber}'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PinCodeVerificationWidget(
                  textEditingController: _pinController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                  title: 'Verify',
                  onTap: () {
                    _onTapVerify();
                  },
                ),
              ),
              const Spacer(),
              CustomKeyboard(
                pinController: _pinController,
                pinLength: VerifyPhonePage.pinLength,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
