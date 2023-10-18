import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices {
  String getTimeNow() {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

    return fileName;
  }

  Future<Reference?> submitToStorage(
    String localPathToNewFile,
    String newFileName,
    String directory,
  ) async {
    final Reference baseRef = FirebaseStorage.instance.ref();

    final Reference newRef = baseRef.child(directory).child(newFileName);

    File file = File(localPathToNewFile);
    try {
      await newRef.putFile(file);
    } catch (e) {
      return null;
    }

    return newRef;
  }
}
