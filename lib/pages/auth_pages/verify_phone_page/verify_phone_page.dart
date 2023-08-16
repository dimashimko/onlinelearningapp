import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/pages/auth_pages/widgets/successfulRegistrationDialog.dart';
import 'package:online_learning_app/pages/main_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/services/auth_service.dart';
import 'package:online_learning_app/utils/show_custom_snack_bar.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
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

  void _goToBackPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  final TextEditingController _pinController = TextEditingController();

  Future<void> _onTapVerify() async {

    final bool isValid =
        _pinController.text.length == VerifyPhonePage.pinLength;
    log('*** isValid: $isValid');
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
      // _showCompleteRegistrationDialog();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TemplatePageAppBar(onTap: () {
        _goToBackPage(context);
      }),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    required this.pinController,
    super.key,
  });

  final TextEditingController pinController;

  void addSign(int sign) {
    if (pinController.text.length < VerifyPhonePage.pinLength) {
      pinController.text = '${pinController.text}$sign';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            KeyboardSign(
              sign: '1',
              onTap: () => addSign(1),
            ),
            KeyboardSign(
              sign: '2',
              onTap: () => addSign(2),
            ),
            KeyboardSign(
              sign: '3',
              onTap: () => addSign(3),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            KeyboardSign(
              sign: '4',
              onTap: () => addSign(4),
            ),
            KeyboardSign(
              sign: '5',
              onTap: () => addSign(5),
            ),
            KeyboardSign(
              sign: '6',
              onTap: () => addSign(6),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            KeyboardSign(
              sign: '7',
              onTap: () => addSign(7),
            ),
            KeyboardSign(
              sign: '8',
              onTap: () => addSign(8),
            ),
            KeyboardSign(
              sign: '9',
              onTap: () => addSign(9),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            KeyboardSign(
              sign: ' ',
              onTap: () {},
            ),
            KeyboardSign(
              sign: '0',
              onTap: () => addSign(0),
            ),
            KeyboardSign(
              sign: '*',
              onTap: () {
                if (pinController.text.isNotEmpty) {
                  pinController.text = pinController.text
                      .substring(0, pinController.text.length - 1);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class KeyboardSign extends StatelessWidget {
  const KeyboardSign({
    required this.sign,
    required this.onTap,
    super.key,
  });

  final String sign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: sign != ' ' ? onTap : null,
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 10,
          child: sign != '*'
              ? Text(
                  sign,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 24.0,
                      ),
                )
              : SvgPicture.asset(
                  AppIcons.delete,
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
  _PinCodeVerificationWidgetState createState() =>
      _PinCodeVerificationWidgetState();
}

class _PinCodeVerificationWidgetState extends State<PinCodeVerificationWidget> {
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

PreferredSizeWidget TemplatePageAppBar({
  required VoidCallback onTap,
}) {
  return CustomAppBar(
    leading: SvgPicture.asset(AppIcons.close),
    onLeading: onTap,
    title: const Text('Verify Phone'),
    action: const Text(
      '          ',
      style: TextStyle(color: Colors.white),
    ),
  );
}
