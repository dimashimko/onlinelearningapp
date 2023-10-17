import 'dart:developer';
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
    log('*** submitToStorage');
    final Reference baseRef = FirebaseStorage.instance.ref();

    final Reference newRef = baseRef.child(directory).child(newFileName);
    log('*** newRef fullPath: ${newRef.fullPath}');

    File file = File(localPathToNewFile);
    try {
      await newRef.putFile(file);
    } catch (e) {
      return null;
    }
/*
    String newURL = await newRef.getDownloadURL();
    print('newURL: $newURL');*/

    return newRef;
  }

}
