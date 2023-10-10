import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

showCustomSnackBar(
  BuildContext context,
  String? message, [
  bool isError = true,
]) {
  if (message != null && message.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          '${isError ? 'Error: ' : ''} $message',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 14,
              ),
        ),
        showCloseIcon: true,
      ),
    );
  }
}
