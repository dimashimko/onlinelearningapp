import 'package:flutter/material.dart';

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
