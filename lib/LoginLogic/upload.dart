import 'package:flutter/material.dart';
import 'package:testlet/Uploading/ImageSource.dart';
import 'package:testlet/Uploading/chooseMethod.dart';
import 'package:testlet/HomePages/homeScreen.dart';
import 'package:testlet/HomePages/fitnessAppHomeScreen.dart';

class Upload extends StatefulWidget {
  const Upload({this.onSignedOut});

  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _UploadState();
}

enum UploadStatus {
  notUploaded,
  Uploaded,
}

class _UploadState extends State<Upload> {
  UploadStatus us = UploadStatus.Uploaded;

  void _uploaded() {
    setState(() {
      us = UploadStatus.Uploaded;
    });
  }

  void _signout() {
    widget.onSignedOut();
  }
  void _upload(){
    setState(() {
      us = UploadStatus.notUploaded;
    });
  }

  @override
  Widget build(BuildContext context) {


    switch (us) {
      case UploadStatus.Uploaded:
        return FitnessAppHomeScreen(
          NotUploaded: _upload,
          SignOut: _signout,
        );
      case UploadStatus.notUploaded:
        /*return WaitToUpload(

          SignOut: _signout,
        );*/
        return chooseMethod(
          Uploaded: _uploaded,
          test: 0,
        );

//        return pickImage(
//         Uploaded: _uploaded,
//        );
    }
    return null;
  }
}
