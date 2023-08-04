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
        content: Text('${isError ? 'Error: ' : ''} $message'),
        showCloseIcon: true,
      ),
    );
  }
}

// operation-not-allowed:
// Thrown if the type of account corresponding to the credential is not enabled. Enable the account type in the Firebase Console, under the Auth tab.
// user-disabled:
// Thrown if the user corresponding to the given credential has been disabled.
// user-not-found:
// Thrown if signing in with a credential from EmailAuthProvider.credential and there is no user corresponding to the given email.
// wrong-password:
// Thrown if signing in with a credential from EmailAuthProvider.credential and the password is invalid for the given email, or if the account corresponding to the email does not have a password set.
// invalid-verification-code:
// Thrown if the credential is a PhoneAuthProvider.credential and the verification code of the credential is not valid.
// invalid-verification-id:
// Thrown if the credential is a PhoneAuthProvider.credential and the verification ID of the credential is not valid.id.

Map<String, String> errorDescriptions = {
  // signInWithEmailAndPassword
  'invalid-email': 'Email address is not valid.',
  'user-disabled': 'User corresponding to the given email has been disabled',
  'user-not-found': 'No user corresponding to the given email.',
  'wrong-password':
      'The password is invalid for the given email, or the account corresponding to the email does not have a password set',

  // createUserWithEmailAndPassword
  'email-already-in-use':
      'There already exists an account with the given email address.',
  'operation-not-allowed':
      'Email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.',
  'weak-password': 'The password is not strong enough.',

  'account-exists-with-different-credential':
      'There already exists an account with the email address asserted by the credential.',
  'invalid-credential': 'The credential is malformed or has expired.',
};
