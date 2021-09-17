import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

const Map<String, String> _headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json; charset=UTF-8',
};
const String api = 'http://3.141.158.159:8181/predict';

const String _maskUrl =
    'https://firebasestorage.googleapis.com/v0/b/atains-app.appspot.com/o/utils%2Fmask.png?alt=media&token=ad4f142a-4dc0-451d-bd9d-2f8d8427e68c';

class AppState with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _responseImage = '';
  String get getResponseImage => _responseImage;
  set responseImage(String value) {
    _responseImage = value;
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  uploadAndGetPrediction(Uint8List file, String filename) {
    loading = true;
    uploadImageToFirebaseStorage(file, filename).then((String imageUrl) {
      getPrediction(imageUrl).then((_) {
        loading = false;
      });
    });
  }

  Future<String> uploadImageToFirebaseStorage(
      Uint8List file, String filename) async {
    final Reference ref = _firebaseStorage.ref().child('files/$filename');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> getPrediction(String uploadImageUrl) async {
    Map<String, String> upload = {'image': uploadImageUrl, 'mask': _maskUrl};
    var _body = jsonEncode(upload);
    final Uri uri = Uri.parse(api);
    http.Response response =
        await http.post(uri, headers: _headers, body: _body);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      var data = responseBody as Map<dynamic, dynamic>;
      responseImage = data['watermarks'][0]['output_image'];
      http.get(Uri.parse(_responseImage));
    }
  }
}
