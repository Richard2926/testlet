import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'create.dart';
import 'createArguments.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'package:smart_arrays_base/smart_arrays_base.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:testlet/Backend/universal.dart';
class machineRead extends StatefulWidget {
  //const pickImage({this.Uploaded});

  //final VoidCallback Uploaded;
  machineRead({Key key, this.title, this.test}) : super(key: key);
  final String title;
  final int test;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<machineRead> {
  File _image;
  int noOfCards = 4;
  Uint8List pngBytes;
  List rectangles = [];
  List texts = [];
  List frontCards = [];
  List backCards = [];
  List data = [];
  GlobalKey globalKey = new GlobalKey();
  bool noData = true;
  double opacity = 0.5;
  bool imageProcess = false;
  int imgWidth;
  int imgHeight;
  List input = [];
  List buffer = [];
  var result;
  List output = [];
  List spam = [];

  bool useFirebase = Universal.useMLFirebase;

  //TODO: Train cloud ML model

  bool cloud = Universal.machineCloud;

  bool dataCollection = Universal.dataCollection;

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

  Future<void> readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText;
    if(cloud == false){
      recognizeText = FirebaseVision.instance.textRecognizer();
    }else{
      recognizeText = FirebaseVision.instance.cloudTextRecognizer();
    }
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      texts.add(block.text);
      rectangles.add(block.boundingBox);

      for (TextLine line in block.lines) {
//        texts.add(line.text);
//        rectangles.add(line.boundingBox);

        for (TextElement word in line.elements) {}
      }
    }
    return null;
  }

  Future<void> inference() async {
    List x = [];
    input = [];
    //print(rectangles.length);
    if(cloud == true){
      for (int i = 0; i < rectangles.length; i++) {
        x = [];

        x.add(imgWidth);
        x.add(imgHeight);

        if (i == 0) {

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(rectangles[i + 1].centerLeft.dx.toInt());
          x.add(rectangles[i + 1].centerLeft.dy.toInt());
          x.add(rectangles[i + 1].size.width.toInt());
          x.add(rectangles[i + 1].size.height.toInt());

          x.add(rectangles[i + 2].centerLeft.dx.toInt());
          x.add(rectangles[i + 2].centerLeft.dy.toInt());
          x.add(rectangles[i + 2].size.width.toInt());
          x.add(rectangles[i + 2].size.height.toInt());

        } else if (i == 1) {

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);

          x.add(rectangles[i - 1].centerLeft.dx.toInt());
          x.add(rectangles[i - 1].centerLeft.dy.toInt());
          x.add(rectangles[i - 1].size.width.toInt());
          x.add(rectangles[i - 1].size.height.toInt());

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(rectangles[i + 1].centerLeft.dx.toInt());
          x.add(rectangles[i + 1].centerLeft.dy.toInt());
          x.add(rectangles[i + 1].size.width.toInt());
          x.add(rectangles[i + 1].size.height.toInt());

          x.add(rectangles[i + 2].centerLeft.dx.toInt());
          x.add(rectangles[i + 2].centerLeft.dy.toInt());
          x.add(rectangles[i + 2].size.width.toInt());
          x.add(rectangles[i + 2].size.height.toInt());

        } else if (i == rectangles.length - 2) {

          x.add(rectangles[i - 2].centerLeft.dx.toInt());
          x.add(rectangles[i - 2].centerLeft.dy.toInt());
          x.add(rectangles[i - 2].size.width.toInt());
          x.add(rectangles[i - 2].size.height.toInt());

          x.add(rectangles[i - 1].centerLeft.dx.toInt());
          x.add(rectangles[i - 1].centerLeft.dy.toInt());
          x.add(rectangles[i - 1].size.width.toInt());
          x.add(rectangles[i - 1].size.height.toInt());

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(rectangles[i + 1].centerLeft.dx.toInt());
          x.add(rectangles[i + 1].centerLeft.dy.toInt());
          x.add(rectangles[i + 1].size.width.toInt());
          x.add(rectangles[i + 1].size.height.toInt());

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);
        } else if (i == rectangles.length - 1) {

          x.add(rectangles[i - 2].centerLeft.dx.toInt());
          x.add(rectangles[i - 2].centerLeft.dy.toInt());
          x.add(rectangles[i - 2].size.width.toInt());
          x.add(rectangles[i - 2].size.height.toInt());

          x.add(rectangles[i - 1].centerLeft.dx.toInt());
          x.add(rectangles[i - 1].centerLeft.dy.toInt());
          x.add(rectangles[i - 1].size.width.toInt());
          x.add(rectangles[i - 1].size.height.toInt());

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);

        } else {


          x.add(rectangles[i - 2].centerLeft.dx.toInt());
          x.add(rectangles[i - 2].centerLeft.dy.toInt());
          x.add(rectangles[i - 2].size.width.toInt());
          x.add(rectangles[i - 2].size.height.toInt());

          x.add(rectangles[i - 1].centerLeft.dx.toInt());
          x.add(rectangles[i - 1].centerLeft.dy.toInt());
          x.add(rectangles[i - 1].size.width.toInt());
          x.add(rectangles[i - 1].size.height.toInt());

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(rectangles[i + 1].centerLeft.dx.toInt());
          x.add(rectangles[i + 1].centerLeft.dy.toInt());
          x.add(rectangles[i + 1].size.width.toInt());
          x.add(rectangles[i + 1].size.height.toInt());

          x.add(rectangles[i + 2].centerLeft.dx.toInt());
          x.add(rectangles[i + 2].centerLeft.dy.toInt());
          x.add(rectangles[i + 2].size.width.toInt());
          x.add(rectangles[i + 2].size.height.toInt());
        }
        //print(i);
        //print(x);
        input.add(x);
      }

    }else{
      for (int i = 0; i < rectangles.length; i++) {
        x = [];

        x.add(imgWidth);
        x.add(imgHeight);

        if (i == 0) {

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(rectangles[i + 1].centerLeft.dx.toInt());
          x.add(rectangles[i + 1].centerLeft.dy.toInt());
          x.add(rectangles[i + 1].size.width.toInt());
          x.add(rectangles[i + 1].size.height.toInt());

        } else if (i == rectangles.length - 1) {

          x.add(rectangles[i - 1].centerLeft.dx.toInt());
          x.add(rectangles[i - 1].centerLeft.dy.toInt());
          x.add(rectangles[i - 1].size.width.toInt());
          x.add(rectangles[i - 1].size.height.toInt());

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(0);
          x.add(0);
          x.add(0);
          x.add(0);
        } else {
          x.add(rectangles[i - 1].centerLeft.dx.toInt());
          x.add(rectangles[i - 1].centerLeft.dy.toInt());
          x.add(rectangles[i - 1].size.width.toInt());
          x.add(rectangles[i - 1].size.height.toInt());

          x.add(rectangles[i].centerLeft.dx.toInt());
          x.add(rectangles[i].centerLeft.dy.toInt());
          x.add(rectangles[i].size.width.toInt());
          x.add(rectangles[i].size.height.toInt());

          x.add(rectangles[i + 1].centerLeft.dx.toInt());
          x.add(rectangles[i + 1].centerLeft.dy.toInt());
          x.add(rectangles[i + 1].size.width.toInt());
          x.add(rectangles[i + 1].size.height.toInt());
        }
        //print(i);
        //print(x);
        input.add(x);
      }
    }

    const platform = const MethodChannel('ondeviceML');

    if(cloud == true){
      result = new List.generate(input.length, (_) => new List(22));

      try {
        result = await platform
            .invokeMethod('AllCloud', {"arg": input}); // passing arguments
        //here inp has our matrix returned by tokenizer class
        //print(result);

      } on PlatformException catch (e) {
        print(e.message);
      }

    }else{
      result = new List.generate(input.length, (_) => new List(14));

      try {
        result = await platform
            .invokeMethod('predictData', {"arg": input}); // passing arguments
        //here inp has our matrix returned by tokenizer class
        //print(result);

      } on PlatformException catch (e) {
        print(e.message);
      }
    }

    print(result);
    Float64List matrix;

    for (int i = 0; i < input.length; i++) {

      matrix = Float64List(3);

      for (int j = 0; j < 3; j++) {
        matrix[j] = result[i][j];
      }
      buffer.add(Array1D.getMax(matrix)[1]);
      //buffer.add(result.indexOf(result[i].reduce(max)));
    }

    print(buffer);

    for (int i = 0; i < input.length; i++) {

      bool found = false;

      if (buffer[i] == 1) {

        frontCards.add(texts[i].toString());

        if (i != (input.length - 1)){

          for(int j = i+1;j <input.length; j++){

            if(buffer[j] == 1){
              found = true;
              backCards.add("");
              break;
            }
            if(buffer[j] == 2){
              found = true;
              break;
            }
          }
          if(found == false){

            backCards.add("");
          }
          found = false;
        } else {
          backCards.add("");
        }
      }

      if (buffer[i] == 2) {

        backCards.add(texts[i].toString());

        if (i != 0) {
          for(int j = i-1;j >=0; j--){

            if(buffer[j] == 1){
              found = true;
              break;
            }
            if(buffer[j] == 2){
              frontCards.add("");
              found = true;
              break;
            }
          }
          if(found == false){

            frontCards.add("");
          }
          found = false;

        } else {
          frontCards.add("");
        }


      }
      if (buffer[i] == 0) {
        spam.add(texts[i].toString());
      }
    }
//      print(spam);
//    print(frontCards);
//    print(backCards);
  }

  Future<void> getImage(BuildContext context) async {


    final AuthService auth = AuthProvider.of(context).auth;
    if(useFirebase == true){
      cloud = await auth.getMachineCloud();
    }

    setState(() {
      noData = false;
    });

    await readText();
    var decodedImage = await decodeImageFromList(_image.readAsBytesSync());
    imgWidth = decodedImage.width;
    imgHeight = decodedImage.height;

    if(dataCollection == true){
      setState(() {
        imageProcess = true;
      });
    }else{

    await inference();

    Navigator.pushNamed(
      context,
      create.routeName,
      arguments: createArguments(frontCards, backCards, widget.test, spam),
    );
    }

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

    Widget _display2() {
      return Center(
        child: Text('No image selected.'),
      );
    }

    if (noData == true) {
      return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: GradientAppBar(
              title: new Text('Select an Image',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Raleway')),
              centerTitle: false,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  } //Navigator.popAndPushNamed(context, 'homescreen'),
                  /*Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new doneUpload())),*/
                  ),
              backgroundColorStart: FintnessAppTheme.grad[0],
              backgroundColorEnd: FintnessAppTheme.grad[1],
//              actions: <Widget>[
//                Stack(
//                  children: <Widget>[
//                    Padding(
//                      padding: EdgeInsets.only(top: 6.0, right: 3.0),
//                      child: Text(
//                        noOfCards.toString(),
//                        style: TextStyle(
//                            fontSize: 29.0,
//                            fontWeight: FontWeight.w300,
//                            fontFamily: 'Raleway',
//                            color: FintnessAppTheme.white),
//                        textScaleFactor: 1,
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(right: 20.0, top: 0),
//                      child: new DropdownButton<int>(
//                        items: <int>[3, 4, 5, 6, 7, 8, 9].map((int value) {
//                          return new DropdownMenuItem<int>(
//                            value: value,
//                            child: new Text(
//                              value.toString(),
//                              style: TextStyle(
//                                  fontSize: 20.0,
//                                  fontWeight: FontWeight.w500,
//                                  fontFamily: 'Raleway',
//                                  color: FintnessAppTheme.black),
//                              textScaleFactor: 1,
//                              textAlign: TextAlign.center,
//                            ),
//                          );
//                        }).toList(),
//                        onChanged: (_) {
//                          noOfCards = _;
//                          didChangeDependencies();
//                          setState(() {
//                            noOfCards = _;
//                          });
//                        },
//                        iconEnabledColor: FintnessAppTheme.white,
//                      ),
//                    ),
//                  ],
//                )
//              ],
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
                      child: _image == null ? null : _display1(),
                    ),
                  ),
                ),

                button(Icons.add_a_photo, height * 0.76, width * 0.04, 1),

                button(Icons.wallpaper, height * 0.76, width * 0.75, 2),
              ],
            )),
      );
    } else {
      List<Widget> list = new List<Widget>();
      list.removeRange(0, list.length);
      list = buildThis(list, FintnessAppTheme.midpoint);

      //print(height);
      return new Scaffold(
        backgroundColor: FintnessAppTheme.background,
        appBar: GradientAppBar(
          title: new Text('Making Cards ...',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Raleway')),
          centerTitle: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
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
          children: <Widget>[
            if (imageProcess == false)
              Container(
                //width: MediaQuery.of(context).size.width,
                width: width,
                height: height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    child: Image.file(_image),
                  ),
                ),
              ),
            if (imageProcess == false)
              Positioned(
                  left: 0.0,
                  top: 0.0,
                  width: width,
                  height: height,
                  child: new IgnorePointer(
                      child: new Opacity(
                        opacity: opacity,
                        child: new Container(
                          color: Colors.black,
                        ),
                      ))),
            if (imageProcess == false) new Column(children: list),
            if (imageProcess == true)
              Center(
                child: CustomPaint(
                  painter: ShapesPainter(
                      rectangles: rectangles,
                      texts: texts,
                      factor: imgHeight / (height * 0.9),
                      dim: [imgWidth, imgHeight],
                      cloud: cloud),
                  //child: new Image.file(_image),
                  child: Container(
                    //height: imgHeight.toDouble()*1.2,
                    width: width * 0.82,
                    //height: height*3,
                    //width: width*0.828,
                    color: Colors.transparent,
                    //child: new Image.file(_image),
                  ),
                ),
              ),
          ],
        ),
      );
    }
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

  List buildThis(List list, Color color) {
    list.add(
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
        child: Ink(
          child: SpinKitPouringHourglass(
            duration: Duration(milliseconds: 1500),
            color: color,
            size: 250.0,
          ),
        ),
      ),
    );
    return list;
  }
}

class ShapesPainter extends CustomPainter {
  ShapesPainter({Key key, this.rectangles, this.texts, this.factor, this.dim, this.cloud});

  final List rectangles;
  final List texts;
  double factor;
  var dim;
  bool cloud;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = FintnessAppTheme.lightTeal;

    Rect rect;
    factor = factor * 1.032;

    //print(factor);
    //factor = 2.440;

    for (int i = 0; i < rectangles.length; i++) {
      if(rectangles.length > 4){
        if(cloud == true)state(i);
        if(cloud == false)statedevice(i);
        //enable for data collection, although needs to manually labelled
      }

      print(texts[i]);
//      if (i == 17) {
//        paint.color = Colors.black;
//      } else {
        paint.color = FintnessAppTheme.lightTeal;
//      }

      //rect = rectangles[i];
      rect = Rect.fromLTWH(
          rectangles[i].centerLeft.dx / factor,
          rectangles[i].centerLeft.dy / factor,
          rectangles[i].size.width / factor,
          rectangles[i].size.height / factor);
//      if (i == 0) {
//        print(rect.toString());
//        print(rect.centerLeft.dx);
//      }
      //rect.size = rect.size/2;
      //print(rect.size.width);
      canvas.drawRect(rect, paint);
    }
  }

  void state(int i) {
    if (i == 0) {
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          rectangles[i + 1].centerLeft.dx.toString() +
          " " +
          rectangles[i + 1].centerLeft.dy.toString() +
          " " +
          rectangles[i + 1].size.width.toString() +
          " " +
          rectangles[i + 1].size.height.toString() +
          " " +
          rectangles[i + 2].centerLeft.dx.toString() +
          " " +
          rectangles[i + 2].centerLeft.dy.toString() +
          " " +
          rectangles[i + 2].size.width.toString() +
          " " +
          rectangles[i + 2].size.height.toString());
    } else if (i == rectangles.length - 1) {
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          rectangles[i - 2].centerLeft.dx.toString() +
          " " +
          rectangles[i - 2].centerLeft.dy.toString() +
          " " +
          rectangles[i - 2].size.width.toString() +
          " " +
          rectangles[i - 2].size.height.toString() +
          " " +
          rectangles[i - 1].centerLeft.dx.toString() +
          " " +
          rectangles[i - 1].centerLeft.dy.toString() +
          " " +
          rectangles[i - 1].size.width.toString() +
          " " +
          rectangles[i - 1].size.height.toString() +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0");
    } else if (i == rectangles.length - 2) {
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          rectangles[i - 2].centerLeft.dx.toString() +
          " " +
          rectangles[i - 2].centerLeft.dy.toString() +
          " " +
          rectangles[i - 2].size.width.toString() +
          " " +
          rectangles[i - 2].size.height.toString() +
          " " +
          rectangles[i - 1].centerLeft.dx.toString() +
          " " +
          rectangles[i - 1].centerLeft.dy.toString() +
          " " +
          rectangles[i - 1].size.width.toString() +
          " " +
          rectangles[i - 1].size.height.toString() +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          rectangles[i + 1].centerLeft.dx.toString() +
          " " +
          rectangles[i + 1].centerLeft.dy.toString() +
          " " +
          rectangles[i + 1].size.width.toString() +
          " " +
          rectangles[i + 1].size.height.toString() +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0");
    }else if (i == 1) {
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          rectangles[i-1].centerLeft.dx.toString() +
          " " +
          rectangles[i-1].centerLeft.dy.toString() +
          " " +
          rectangles[i-1].size.width.toString() +
          " " +
          rectangles[i-1].size.height.toString() +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          rectangles[i + 1].centerLeft.dx.toString() +
          " " +
          rectangles[i + 1].centerLeft.dy.toString() +
          " " +
          rectangles[i + 1].size.width.toString() +
          " " +
          rectangles[i + 1].size.height.toString() +
          " " +
          rectangles[i + 2].centerLeft.dx.toString() +
          " " +
          rectangles[i + 2].centerLeft.dy.toString() +
          " " +
          rectangles[i + 2].size.width.toString() +
          " " +
          rectangles[i + 2].size.height.toString());

    }else {
      //print("bruh");
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          rectangles[i - 2].centerLeft.dx.toString() +
          " " +
          rectangles[i - 2].centerLeft.dy.toString() +
          " " +
          rectangles[i - 2].size.width.toString() +
          " " +
          rectangles[i - 2].size.height.toString() +
          " " +
          rectangles[i - 1].centerLeft.dx.toString() +
          " " +
          rectangles[i - 1].centerLeft.dy.toString() +
          " " +
          rectangles[i - 1].size.width.toString() +
          " " +
          rectangles[i - 1].size.height.toString() +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          rectangles[i + 1].centerLeft.dx.toString() +
          " " +
          rectangles[i + 1].centerLeft.dy.toString() +
          " " +
          rectangles[i + 1].size.width.toString() +
          " " +
          rectangles[i + 1].size.height.toString()+
          " " +
          rectangles[i + 2].centerLeft.dx.toString() +
          " " +
          rectangles[i + 2].centerLeft.dy.toString() +
          " " +
          rectangles[i + 2].size.width.toString() +
          " " +
          rectangles[i + 2].size.height.toString());
    }
  }
  void statedevice(int i) {
    if (i == 0) {
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          rectangles[i + 1].centerLeft.dx.toString() +
          " " +
          rectangles[i + 1].centerLeft.dy.toString() +
          " " +
          rectangles[i + 1].size.width.toString() +
          " " +
          rectangles[i + 1].size.height.toString());

    } else if (i == rectangles.length - 1) {
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          rectangles[i - 1].centerLeft.dx.toString() +
          " " +
          rectangles[i - 1].centerLeft.dy.toString() +
          " " +
          rectangles[i - 1].size.width.toString() +
          " " +
          rectangles[i - 1].size.height.toString() +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0" +
          " " +
          "0");

    } else {
      print(dim[0].toString() +
          " " +
          dim[1].toString() +
          " " +
          rectangles[i - 1].centerLeft.dx.toString() +
          " " +
          rectangles[i - 1].centerLeft.dy.toString() +
          " " +
          rectangles[i - 1].size.width.toString() +
          " " +
          rectangles[i - 1].size.height.toString() +
          " " +
          rectangles[i].centerLeft.dx.toString() +
          " " +
          rectangles[i].centerLeft.dy.toString() +
          " " +
          rectangles[i].size.width.toString() +
          " " +
          rectangles[i].size.height.toString() +
          " " +
          rectangles[i + 1].centerLeft.dx.toString() +
          " " +
          rectangles[i + 1].centerLeft.dy.toString() +
          " " +
          rectangles[i + 1].size.width.toString() +
          " " +
          rectangles[i + 1].size.height.toString());

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

//    custom.FirebaseRemoteModelSource cloudSource =
//    custom.FirebaseRemoteModelSource(modelName: "vertmodel");
//    custom.FirebaseModelInputOutputOptions options =
//    custom.FirebaseModelInputOutputOptions([
//      custom.FirebaseModelIOOption(
//          custom.FirebaseModelDataType.BYTE, [rectangles.length, 14])
//    ], [
//      custom.FirebaseModelIOOption(
//          custom.FirebaseModelDataType.BYTE, [rectangles.length, 3])
//    ]);
//    custom.FirebaseModelInterpreter interpreter =
//        custom.FirebaseModelInterpreter.instance;
//    custom.FirebaseModelManager manager = custom.FirebaseModelManager.instance;
//
//    manager.registerRemoteModelSource(cloudSource);
//    var results = await interpreter.run(
//        remoteModelName: "vertmodel", inputOutputOptions: options, inputBytes: input);
//
//    custom.FirebaseLocalModelSource localSource =
//    custom.FirebaseLocalModelSource(
//        modelName: "Vertmodel", assetFilePath: 'assets/tflite/Vertmodel.tflite');
//
//    custom.FirebaseModelInputOutputOptions options =
//    custom.FirebaseModelInputOutputOptions([
//      custom.FirebaseModelIOOption(
//          custom.FirebaseModelDataType.FLOAT32, [rectangles.length, 14])
//    ], [
//      custom.FirebaseModelIOOption(
//          custom.FirebaseModelDataType.FLOAT32, [rectangles.length, 3])
//    ]);
//    custom.FirebaseModelInterpreter interpreter =
//        custom.FirebaseModelInterpreter.instance;
//
//    custom.FirebaseModelManager manager = custom.FirebaseModelManager.instance;
//
//    manager.registerLocalModelSource(localSource);
//
//    //List<List<int>> input2 = input;
//    var results = await interpreter.run(
//        localModelName: "Vertmodel",
//        inputOutputOptions: options,
//        inputBytes: input);
//
//    print(results);
