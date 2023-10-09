import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices {
  String getTimeNow() {
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    // print(DateTime.parse('formattedString'));
    // print('*** file name: $fileName');
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

      // print(e);
    }
/*
    String newURL = await newRef.getDownloadURL();
    print('newURL: $newURL');*/

    return newRef;
  }

  Future<void> deleteInStorage(String? filePath, String folder) async {
    print('*** deleteInStorage');

    if (filePath != null) {
      final Reference baseRef = FirebaseStorage.instance.ref();
      print('*** deleteInStorage baseRef: $baseRef');

      // Create a reference to the file to delete
      final desertRef = baseRef.child(folder).child(filePath);
      print('*** deleteInStorage desertRef: $desertRef');

      // Delete the file
      await desertRef.delete();
      print('*** deleteInStorage deleted... ');
    }
  }
}
