import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:image/image.dart' as xv;
import 'package:testlet/Backend/universal.dart';
import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui' as ui;
import 'rotatescale.dart';
import '../ThemeRelated/imgcrop_icons.dart';
import 'package:testlet/Uploading/result_page.dart';
import 'package:image/image.dart' as ImageUtil;
import 'package:testlet/Backend/auth_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'imagepage2.dart';

class CropPage extends StatefulWidget {
  CropPage({Key key, this.title, this.image, this.imageInfo, this.docNo, this.test})
      : super(key: key);
  final String title;
  final File image;
  final int test;
  final int docNo;
  ImageInfo imageInfo;

  @override
  _CropPageState createState() => new _CropPageState();
}

class _CropPageState extends State<CropPage>
    with SingleTickerProviderStateMixin {

  GlobalKey globalKey = new GlobalKey();
  ui.Image corpImg;
  int track = 0;
  bool useFirebase = Universal.useFirebase ;
  String maskDirection = "center";
  double opacity = 0.5;
  double maskTop = 60.0;
  double maskLeft = 40.0;
  Uint8List pngBytes;
  double maskWidth = 0.0;
  double maskHeight = 0.0;
  double dragStartX = 0.0;
  double dragStartY = 0.0;
  double imgDragStartX = 0.0;
  double imgDragStartY = 0.0;
  double imgWidth = 0.0;
  double imgHeight = 0.0;
  double buffer = 30;
  double oldScale = 1.0;
  double _scale = 1.0;
  double oldRotate = 0.0;
  String path;
  int counter = 0;
  File _image;
  List high = [];
  bool noData = true;
  List tests = [];
  int div;

  bool cloud = Universal.cloudText;

  TextRecognizer recognizeText;
  //var wide = new List(1);
  double rotate = 0.0;
  Offset topLeft = new Offset(40.0, 60.0);
  Matrix4 matrix = new Matrix4.identity();
  GlobalKey imgKey = new GlobalKey();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    div = widget.docNo;
    //Navigator.pushNamed(context, "upload-page")
    _controller =
        new AnimationController(duration: new Duration(seconds: 3), vsync: this)
          ..addListener(() {
            this.setState(() {});
          });
  }

  static decodePng(SendPort sendPort) async {
    var port = new ReceivePort();
    sendPort.send(port.sendPort);
    await for (var msg in port) {
      var data = msg[0];
      ImageUtil.Image image = ImageUtil.decodePng(data);
      SendPort replyTo = msg[1];
      replyTo.send(image);
      port.close();
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = new ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }

  static encodePng(SendPort sendPort) async {
    var port = new ReceivePort();
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      var data = msg[0];
      List<int> byteList = ImageUtil.encodePng(data);
      SendPort replyTo = msg[1];
      replyTo.send(byteList);
      port.close();
    }
    // return new Future(() => ImageUtil.encodePng(image));
  }
  Future<void> _capturePng() async {
    //_image = widget.image;
    for (int i = 0; i < tests.length; i++) {
      tests[i] = "";
    }
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    new Directory(appDocDirectory.path + '/' + 'dir')
        .create(recursive: true)
        .then((Directory directory) {
      path = directory.path;
    });
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    double pixelRatio = 1.5;
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    pngBytes = byteData.buffer.asUint8List();
    var receivePort = new ReceivePort();
    await Isolate.spawn(decodePng, receivePort.sendPort);
    var sendPort = await receivePort.first;
    ImageUtil.Image uImage = await sendReceive(sendPort, pngBytes);
    var receivePort1 = new ReceivePort();
    await Isolate.spawn(encodePng, receivePort1.sendPort);
    var sendPort1 = await receivePort1.first;
    List<int> byteList = await sendReceive(sendPort1, uImage);


    File temp = new File('$path/test1.png');

    File total = new File('$path/test.png');
    total = total
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteList);

    xv.Image modified = xv.decodeImage(total.readAsBytesSync());

    xv.Image tempImage;

    print(image.height);
    print(image.width);



//    print(maskLeft);
//    print(maskTop);
//    print(maskWidth);
//    print(maskHeight);
//    print(high);

    int corpX;
    int corpY;
    int corpWidth;
    int corpHeight;

//    String userId = "";
    final AuthService auth = AuthProvider.of(context).auth;
//    userId = await auth.currentUser();
//    final StorageReference firebaseStorageRef =
//    FirebaseStorage.instance.ref().child(userId);
//
//    firebaseStorageRef.putFile(total);
//    print(modified.length);
//    print(modified.height);

//    if(useFirebase == true){
//      cloud = await auth.getIfCloud();
//
//      if(cloud == false){
//
//        recognizeText = FirebaseVision.instance.textRecognizer();
//
//      }else{
//
//        recognizeText = FirebaseVision.instance.cloudTextRecognizer();
//
//      }
//    }


    for (int i = 0; i <= div; i++) {

      corpX = (maskLeft*pixelRatio ).toInt();
      corpWidth = (maskWidth*pixelRatio ).toInt();

      if (i == 0) {
        corpY = ((maskTop) ~/ 2).toInt();
        corpHeight = ((high[i] - maskTop) * pixelRatio).toInt();
      }
      if (i == div) {
        corpY = ((high[i - 1]) * 1.15).toInt();
        corpHeight =
            ((maskHeight + maskTop - high[i - 1]) * pixelRatio).toInt();
      }
      if (i != 0 && i != div) {
        corpY = ((high[i - 1])).toInt();
        corpHeight = ((high[i] - high[i - 1]) * pixelRatio).toInt();
      }



//      print(
//          corpX.toString() +
//              " " +
//              corpY.toString() +
//              " " +
//              corpWidth.toString() +
//              " " +
//              corpHeight.toString());

      tempImage = xv.copyCrop(modified, corpX,  corpY,  corpWidth, corpHeight);

      temp..writeAsBytesSync(xv.encodePng(tempImage));

      StorageReference firebaseStorageRef2 = FirebaseStorage.instance.ref().child(i.toString());

      firebaseStorageRef2.putFile(temp);

      _image = temp;

      //await Future.delayed(Duration(milliseconds: 500));
      await readText(i);
    }
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new pickImage2(
          title: 'crop',
          image: widget.image,
          docNo: (widget.docNo),
          frontCards: tests,
          imageInfo: widget.imageInfo,
          test: widget.test,
        ),
      ),
    );
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void doCapturePng() async {

    _controller.repeat();
    _capturePng();
    setState(() {
      noData = false;
    });
  }


  Future<void> readText(int j) async {
    //print(j);

    recognizeText = FirebaseVision.instance.cloudTextRecognizer();
    FirebaseVisionImage ourImage =  FirebaseVisionImage.fromFile(_image);

    //TextRecognizer recognizeText = FirebaseVision.instance.cloudTextRecognizer();
    //TextRecognizer recognizeText =  FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    //tests[counter] = readText.toString();

    for (TextBlock block in readText.blocks) {
      //tests[counter] = "";
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {

          //if (counter == 0) {
          //print(counter);

          tests[j] += word.text.toString();
          tests[j] += " ";

          //print(word.text);
          //}
          //

        }
      }
    }
    //print(tests[j]);
    return null;
  }

  void onPanStart(DragStartDetails dragInfo) {
    dragStartX = dragInfo.globalPosition.dx;
    dragStartY = dragInfo.globalPosition.dy;
  }

  void onMaskPanStart(DragStartDetails dragInfo) {
    dragStartX = dragInfo.globalPosition.dx;
    dragStartY = dragInfo.globalPosition.dy;
    double margin = 20.0;
    //点击位置离跟左边点在10以内
    if ((dragStartX - maskLeft).abs() < margin &&
        dragStartY > (maskTop + margin) &&
        dragStartY < (maskTop + maskHeight - margin)) {
      maskDirection = "left";
    } else if ((dragStartY - maskTop).abs() < margin &&
        dragStartX > (maskLeft + margin) &&
        dragStartX < (maskLeft + maskWidth - margin)) {
      maskDirection = "top";
    } else if ((dragStartX - (maskLeft + maskWidth)).abs() < margin &&
        dragStartY > (maskTop + margin) &&
        dragStartY < (maskTop + maskHeight - margin)) {
      maskDirection = "right";
    } else if ((dragStartY - (maskTop + maskHeight)).abs() < margin &&
        dragStartX > (maskLeft + margin) &&
        dragStartX < (maskLeft + maskWidth - margin)) {
      maskDirection = "bottom";
    } else {

      maskDirection = "center";
    }
    //print(maskDirection+" " +dragStartX.toString()+" "+maskLeft.toString()+" "+(dragStartX -maskLeft).abs().toString());
  }

  void onPanEnd(DragEndDetails details) {
    dragStartX = 0.0;
    dragStartY = 0.0;
  }

  void onPanUpdate(String btn, DragUpdateDetails dragInfo, int bruh) {
    double moveX = (dragInfo.globalPosition.dx - dragStartX);
    double moveY = (dragInfo.globalPosition.dy - dragStartY);

    dragStartX = dragStartX + moveX;
    dragStartY = dragStartY + moveY;

    bool s;
    double _maskHeight = maskHeight;
    double _maskWidth = maskWidth;
    double _maskTop = maskTop;
    double _maskLeft = maskLeft;
    double _height;
    var _high = high;

    if (bruh == 0) {
      if (btn == "topleft") {
        _maskHeight = maskHeight - moveY;
        _maskWidth = maskWidth - moveX;
        _maskTop = maskTop + moveY;
        _maskLeft = maskLeft + moveX;
      }

      if (btn == "topright") {
        _maskWidth = maskWidth + moveX;
        _maskHeight = maskHeight - moveY;
        _maskTop = maskTop + moveY;
      }

      //bottomLeft
      if (btn == "bottomleft") {
        _maskWidth = maskWidth - moveX;
        _maskLeft = maskLeft + moveX;
        _maskHeight = maskHeight + moveY;
        //_maskTop = maskTop+ moveY;
      }

      //bottomRight
      if (btn == "bottomright") {
        _maskWidth = maskWidth + moveX;
        _maskHeight = maskHeight + moveY;
      }
      if (btn == "left") {
        _maskWidth = maskWidth - moveX;
        _maskLeft = maskLeft + moveX;
      }

      if (btn == "top") {
        _maskHeight = maskHeight - moveY;
        _maskTop = maskTop + moveY;
      }
      if (btn == "bottom") {
        _maskHeight = maskHeight + moveY;
      }
      if (btn == "right") {
        _maskWidth = maskWidth + moveX;
      }

      //center
      if (btn == "center") {
        _maskLeft = maskLeft + moveX;
        _maskTop = maskTop + moveY;
      }

      for (int u = 0; u < div; u++) {
        _high[u] =
            (_maskTop + (((high[u] - maskTop) / maskHeight) * _maskHeight));
      }
    } else {
      _height = high[bruh - 1];

      if (btn == "drag") {
        _height = _height + moveY;
      }
    }
    if (bruh != 0) {
      s = false;
      if (bruh == 1) {
        if ((high[bruh - 1] > (maskTop + buffer)) &&
            (high[bruh - 1] < (high[bruh] - buffer))) {
          s = true;
        }
      } else if (bruh == div) {
        if ((high[bruh - 1] < (maskTop + maskHeight - buffer)) &&
            (high[bruh - 1] > (high[bruh - 2] + buffer))) {
          s = true;
        }
      } else {
        if ((high[bruh - 1] > (high[bruh - 2] + buffer)) &&
            (high[bruh - 1] < (high[bruh] - buffer))) {
          s = true;
        }
      }
    } else {
      high = _high;
    }
    //debugPrint("undate x:"+dragInfo.globalPosition.dx.toString()+" y:"+dragInfo.globalPosition.dy.toString()+" move:"+moveX.toString()+" maskWidth:" +maskWidth.toString());
    setState(() {
      maskWidth = _maskWidth;
      maskHeight = _maskHeight;
      maskTop = _maskTop;
      maskLeft = _maskLeft;

      if (s == true) {
        buffer = 30;
        high[bruh - 1] = _height;
      } else {
        buffer = buffer - 1;
      }
    });
  }

  Widget buildLoading() {
    return new Center(
        child: new Text(
      "Loading",
      style: new TextStyle(color: Colors.white),
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var size = MediaQuery.of(context).size;

    var devW = size.width - 40 * 2;
    var devH = size.height - 2 * 60;
    var devWh = devW / devH;
    var imgWh = widget.imageInfo.image.width / widget.imageInfo.image.height;
    if (devWh < imgWh) {
      imgWidth = devW;
      imgHeight = widget.imageInfo.image.height *
          (imgWidth / widget.imageInfo.image.width);
    } else {
      imgHeight = devH;
      imgWidth = widget.imageInfo.image.width *
          (imgHeight / widget.imageInfo.image.height);
    }
    maskWidth = imgWidth;
    maskHeight = imgHeight;
    _change();
    //print("====== imgHeight:"+imgHeight.toString()+"  imgWidth:"+imgWidth.toString());
  }

  Widget _buildImage(BuildContext context) {
    /*if (corpImg != null) {
      return new RawImage(
        image: corpImg,
        scale: 1.0,
      );
    }*/

    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;
////
//    print(width);
//    print(height);
    return new Stack(
      children: <Widget>[
        /*new RawImage(
          image: widget.image,
          scale: widget.imageInfo.scale,
        ),*/
        /*new RepaintBoundary(
          key: globalKey,
          child: new Container(
            margin: const EdgeInsets.only(
                left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
            padding: const EdgeInsets.only(
                left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: new CustomSingleChildLayout(
              delegate: new ImagePositionDelegate(imgWidth, imgHeight, topLeft),
              child: Transform(
                child: new RawImage(
                  image: widget.image,
                  scale: widget.imageInfo.scale,
                ),
                alignment: FractionalOffset.center,
                transform: matrix,
              ),
            ),
          ),
        ),*/
        Center(
          child: new RepaintBoundary(
            key: globalKey,
            child: new Image.file(widget.image),
          ),
        ),
        new Positioned(
            left: 0.0,
            top: 0.0,
            width: MediaQuery.of(context).size.width,
            height: maskTop,
            child: new IgnorePointer(
                child: new Opacity(
              opacity: opacity,
              child: new Container(
                color: Colors.black,
              ),
            ))),
        new Positioned(
            left: 0.0,
            top: maskTop,
            width: this.maskLeft,
            height: this.maskHeight,
            child: new IgnorePointer(
                child: new Opacity(
              opacity: opacity,
              child: new Container(color: Colors.black),
            ))),
        new Positioned(
            right: 0.0,
            top: maskTop,
            width: (MediaQuery.of(context).size.width -
                this.maskWidth -
                this.maskLeft),
            height: this.maskHeight,
            child: new IgnorePointer(
                child: new Opacity(
              opacity: opacity,
              child: new Container(color: Colors.black),
            ))),
        new Positioned(
            left: 0.0,
            top: this.maskTop + this.maskHeight,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                (this.maskTop + this.maskHeight),
            child: new IgnorePointer(
                child: new Opacity(
              opacity: opacity,
              child: new Container(color: Colors.black),
            ))),

        /*new Positioned(
            //scan
            left: this.maskLeft,
            top: this.maskTop,
            width: this.maskWidth,
            height: this.maskHeight * _controller.value,
            child: new Opacity(
              opacity: 1,
              child: new Container(color: Colors.black),
            )),*/
        new Positioned(
          left: this.maskLeft,
          top: this.maskTop,
          width: this.maskWidth,
          height: this.maskHeight,
          child: new GestureDetector(
              /*child: new Container(
                color: Colors.transparent,
                child: new CustomPaint(
                  painter: new GridPainter(),
                ),
              ),*/
              onPanStart: onMaskPanStart,
              onPanUpdate: (dragInfo) {
                this.onPanUpdate(maskDirection, dragInfo, 0);
              },
              onPanEnd: onPanEnd),
        ),
        new Positioned(
          top: maskTop - 2,
          left: this.maskLeft - 2,
          child: new GestureDetector(
              child: new Image.asset("assets/topLeft.png"),
              onPanStart: onPanStart,
              onPanUpdate: (dragInfo) {
                this.onPanUpdate("topleft", dragInfo, 0);
              },
              onPanEnd: onPanEnd),
        ),
        new Positioned(
          top: maskTop - 2,
          right: (MediaQuery.of(context).size.width -
              this.maskWidth -
              this.maskLeft -
              2),
          child: new GestureDetector(
              child: new Image.asset("assets/topRight.png"),
              onPanStart: onPanStart,
              onPanUpdate: (dragInfo) {
                this.onPanUpdate("topright", dragInfo, 0);
              },
              onPanEnd: onPanEnd),
        ),
        _display(),
        new Positioned(
          top: this.maskTop + this.maskHeight - 12.0,
          left: this.maskLeft - 2,
          child: new GestureDetector(
              child: new Image.asset("assets/bottomLeft.png"),
              onPanStart: onPanStart,
              onPanUpdate: (dragInfo) {
                this.onPanUpdate("bottomleft", dragInfo, 0);
              },
              onPanEnd: onPanEnd),
        ),
        new Positioned(
          top: this.maskTop + this.maskHeight - 12.0,
          right: (MediaQuery.of(context).size.width -
              this.maskWidth -
              this.maskLeft -
              2),
          child: new GestureDetector(
            child: new Image.asset("assets/bottomRight.png"),
            onPanStart: onPanStart,
            onPanUpdate: (dragInfo) {
              this.onPanUpdate("bottomright", dragInfo, 0);
            },
            onPanEnd: onPanEnd,
          ),
        ),
        //button(Icons.add_a_photo, height*0.76, width*0.04 ,1),

        button(Icons.check_circle, height * 0.76, width * 0.75, 2),
      ],
    );
  }

  void _change() {
    while (high.length < div) {
      int u = high.length;
      high.add(u + 1);

      high[u] = (this.maskTop + ((u + 1) * (this.maskHeight / (div + 1))));
    }
    while (tests.length <= div) {
      int v = tests.length;
      tests.add(v + 1);
      tests[v] = "";
    }
  }

  Widget button(IconData data, double top, double lef, int option) {
    return new Padding(
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
                        Navigator.of(context).pop();
                      } else {
                        doCapturePng();
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

  Widget _display() {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < div; i++) {
      list.add(
        new Positioned(
          top: high[i],
          right: (MediaQuery.of(context).size.width -
              this.maskWidth -
              this.maskLeft -
              2),
          child: new Image.asset("assets/rightCon.png"),
        ),
      );
      list.add(
        new Positioned(
          top: high[i],
          left: this.maskLeft - 2,
          child: new Image.asset("assets/leftCon.png"),
        ),
      );
      list.add(
        new Positioned(
          top: high[i],
          left: (this.maskWidth / 2.35 + this.maskLeft),
          child: new GestureDetector(
              child: new Image.asset("assets/bar.png"),
              onPanStart: onPanStart,
              onPanUpdate: (dragInfo) {
                this.onPanUpdate("drag", dragInfo, (i + 1));
              },
              onPanEnd: onPanEnd),
        ),
      );
    }
    return new Stack(children: list);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (noData == true) {
      return new Scaffold(
        appBar: GradientAppBar(
          title: new Text('Pick Front Cards',
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
        body: new Center(
            child: new Container(
                child: new Column(children: [
          new Expanded(child: new Center(child: _buildImage(context))),
        ]))), // This trailing comma makes auto-formatting nicer for build methods.
      );
    } else {
      List<Widget> list = new List<Widget>();
      list.removeRange(0, list.length);
      list = buildThis(list, FintnessAppTheme.midpoint);
      return new Scaffold(
        backgroundColor: FintnessAppTheme.background,
        appBar: GradientAppBar(
          title: new Text('Pick Front Cards',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Raleway')),
          centerTitle: false,
          backgroundColorStart: FintnessAppTheme.grad[0],
          backgroundColorEnd: FintnessAppTheme.grad[1],
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: new RepaintBoundary(
                key: globalKey,
                child: new Image.file(widget.image)
              ),
            ),
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
            new Column(children: list),
          ],
        ),
      );
    }
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ImagePositionDelegate extends SingleChildLayoutDelegate {
  final double imageWidth;
  final double imageHeight;
  final Offset topLeft;

  const ImagePositionDelegate(this.imageWidth, this.imageHeight, this.topLeft);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return topLeft;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
      maxWidth: imageWidth,
      maxHeight: imageHeight,
      minHeight: imageHeight,
      minWidth: imageWidth,
    );
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}
