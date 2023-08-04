import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_learning_app/models/users/user_model.dart';
import 'package:online_learning_app/repositories/base_repository.dart';
import 'package:online_learning_app/repositories/local_repository.dart';

enum PhoneAuthStatus { initial, menu, tab }


class AuthService {

// signUpByPhone
  static Future<bool> authWithPhoneNumberStep2(String smsCode) async {
    UserModel user = await LocalRepository.instance.getUser();

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: user.verificationId!,
      smsCode: smsCode,
    );

    log('*** credential: $credential');
    log('*** verificationId: ${credential.verificationId}');
    // Sign the user in (or link) with the credential
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // save
      LocalRepository.instance.saveUser(
        user.copyWith(
          uid: FirebaseAuth.instance.currentUser!.uid,
        ),
      );
      // user = await LocalRepository.instance.getUser();
      // log('*** uid (in auth): ${user.uid}');
      // getUserFromFirestoreOrInit();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }

    // navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  // sendSms
  static Future<String?> authWithPhoneNumberStep01({
    required String userPhoneNumber,
    required Function(PhoneAuthCredential credential) verificationCompleted,

  }) async {
    final UserModel user = await LocalRepository.instance.getUser();
    String? response = 'No answer';
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        // phoneNumber: '+38 097 199 16 84',
        // phoneNumber: '+44 7444 555666',
        phoneNumber: userPhoneNumber,
        timeout: const Duration(seconds: 120),

        verificationCompleted: verificationCompleted,
        codeAutoRetrievalTimeout: (String verifId) {
          // log('*** codeAutoRetrievalTimeout ');
          // log('verificationId: $verifId');
          user.verificationId = verifId;
          LocalRepository.instance.saveUser(user);
          // Auto-resolution timed out...
          response = 'Timeout';
        },
        codeSent: (String verifId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          user.verificationId = verifId;
          // log('verificationId: $verifId');

          LocalRepository.instance.saveUser(user);
          // log('*** codeSent verifId: $verifId ');
          response = '';
        },
        verificationFailed: (FirebaseAuthException e) {
          // log('*** verificationFailed');
          if (e.code == 'invalid-phone-number') {
            // log('*** verificationFailed invalid-phone-number');
            // log('The provided phone number is not valid.');
          }
          response = 'Verification failed';

          // Handle other errors
        },
      );
      // return response;
    } catch (e) {
      log('*** catch error: \n ${e.toString()}');
      response = e.toString();
      return response;
    }
    return response;
  }

  // sendSms
  static Future<String?> authWithPhoneNumberStep1({
    required String userPhoneNumber,
  }) async {
    final UserModel user = await LocalRepository.instance.getUser();
    String? response = 'No answer';
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        // phoneNumber: '+38 097 199 16 84',
        // phoneNumber: '+44 7444 555666',
        phoneNumber: userPhoneNumber,
        timeout: const Duration(seconds: 120),

        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!
          // log('*** verificationCompleted ');
          // log('*** verificationCompleted  credential: ${credential.toString()}');
          // log('*** verificationCompleted  credential token: ${credential.token.toString()}');
          // Sign the user in (or link) with the auto-generated credential
          await FirebaseAuth.instance.signInWithCredential(credential);
          response = null;
          // log('*** verificationCompleted  *** signIn Completed ');
        },
        codeAutoRetrievalTimeout: (String verifId) {
          // log('*** codeAutoRetrievalTimeout ');
          // log('verificationId: $verifId');
          user.verificationId = verifId;
          LocalRepository.instance.saveUser(user);
          // Auto-resolution timed out...
          response = 'Timeout';
        },
        codeSent: (String verifId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          user.verificationId = verifId;
          // log('verificationId: $verifId');

          LocalRepository.instance.saveUser(user);
          // log('*** codeSent verifId: $verifId ');
          response = '';
        },
        verificationFailed: (FirebaseAuthException e) {
          // log('*** verificationFailed');
          if (e.code == 'invalid-phone-number') {
            // log('*** verificationFailed invalid-phone-number');
            // log('The provided phone number is not valid.');
          }
          response = 'Verification failed';

          // Handle other errors
        },
      );
      // return response;
    } catch (e) {
      log('*** catch error: \n ${e.toString()}');
      response = e.toString();
      return response;
    }
    return response;
  }

  static Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
