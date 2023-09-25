import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard({
    required this.pinController,
    required this.pinLength,
    super.key,
  });

  final TextEditingController pinController;
  final int pinLength;

  void addSign(int sign) {
    if (pinController.text.length < pinLength) {
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