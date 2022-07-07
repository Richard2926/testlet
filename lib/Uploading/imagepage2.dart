import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testlet/ThemeRelated/background.dart';
import 'package:testlet/Uploading/CropPage.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui' as ui;
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:testlet/Uploading/CropPage2.dart';
import 'package:testlet/LoginLogic/upload.dart';
class pickImage2 extends StatefulWidget {

  //const pickImage({this.Uploaded});

  //final VoidCallback Uploaded;
  pickImage2({Key key, this.title, this.image, this.imageInfo, this.docNo, this.frontCards,this.test})
      : super(key: key);
  final String title;
  final File image;
  final int docNo;
  final int test;
  var frontCards;
  ImageInfo imageInfo;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<pickImage2> {
  File _image;
  int noOfCards = 4;

  Future getImageFromCam() async {
    // for camera
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    // for gallery
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future getImage(BuildContext context) async {
    File sampleImage = _image;


    try {
      _loadImage(sampleImage).then((image) {
        if (image != null) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new CropPage2(
                      title: 'crop',
                      image: _image,
                      docNo: widget.docNo,
                      frontCards: widget.frontCards,
                      test: widget.test,
                      imageInfo: new ImageInfo(image: image, scale: 1.0))));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
  Future<ui.Image> _loadImage(File img) async {
    if (img != null) {
      var codec = await ui.instantiateImageCodec(img.readAsBytesSync());
      var frame = await codec.getNextFrame();
      return frame.image;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget _display() {
      return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
          child: Image.file(_image),
        ),
      );
    }

    Widget _display1() {
      return FloatingActionButton.extended(
        heroTag: "btn1",
        onPressed: () => getImage(context),
        //Navigator.pushNamed(context, upload-page),
        icon: new Image.asset('assets/upload.png'),
        backgroundColor: FintnessAppTheme.red,
        label: Text("Proceed",
            style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'Raleway')),
      );
    }
    void push(BuildContext context){

      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new CropPage2(
            title: 'crop',
            image: widget.image,
            docNo: (widget.docNo),
            frontCards: widget.frontCards,
            test: widget.test,
            imageInfo: widget.imageInfo,
          ),
        ),
      );

    }

    Widget _display3() {
      return FloatingActionButton.extended(
        heroTag: "btn5",
        onPressed: () { push(context);},
        //Navigator.pushNamed(context, upload-page),
        //icon: new Image.asset('assets/upload.png'),
        backgroundColor: FintnessAppTheme.midpoint,
        label: Text("Same Image",
            style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'Raleway')),
      );
    }
    Widget _display2() {
      return Center(
        child: Text('No image selected.'),
      );
    }



    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: GradientAppBar(
            title: new Text('Select Image For Back',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Raleway')),
            centerTitle: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Upload(),
                      ),
                          (Route<dynamic> route) => false);
                } //Navigator.popAndPushNamed(context, 'homescreen'),
              /*Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new doneUpload())),*/
            ),
            backgroundColorStart: FintnessAppTheme.grad[0],
            backgroundColorEnd: FintnessAppTheme.grad[1],
          ),
          body: Stack(
            children: [
              //Background(),
              /*PreferredSize(
              preferredSize: Size.fromHeight(10.0),
              child: AppBar(
                title: const Text('Next page'),
              )
          ),*/
              Container(
                //width: MediaQuery.of(context).size.width,
                width: width,
                height: height,
                child: _image == null ? _display2() : _display(),
              ),
              Container(
                child: Padding(
                  //padding: EdgeInsets.only(top: height - (height / 3.9)),
                  padding: EdgeInsets.only(top: height * 0.74),
                  child: Center(
                    child: _image == null ? _display3() : _display1(),
                  ),
                ),
              ),

              button(Icons.add_a_photo, height * 0.76, width * 0.04, 1),

              button(Icons.wallpaper, height * 0.76, width * 0.75, 2),
            ],
          )),
    );
  }

  Widget button(IconData data, double top, double lef, int option) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom, top: top, left: lef),
      child: SizedBox(
        width: 38 * 2.0,
        height: 38 + 62.0,
        child: Container(
          alignment: Alignment.topCenter,
          color: Colors.transparent,
          child: SizedBox(
            width: 38 * 2.0,
            height: 38 * 2.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                // alignment: Alignment.center,s
                decoration: BoxDecoration(
                  color: FintnessAppTheme.nearlyDarkBlue,
                  gradient: LinearGradient(
                      colors: FintnessAppTheme.grad,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FintnessAppTheme.indigo.withOpacity(0.4),
                        offset: Offset(8.0, 16.0),
                        blurRadius: 16.0),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.1),
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    onTap: () {
                      if (option == 1) {
                        getImageFromCam();
                      } else {
                        getImageFromGallery();
                      }
                    },
                    child: Icon(
                      data,
                      color: FintnessAppTheme.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
