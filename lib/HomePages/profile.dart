import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testlet/HomePages/alternateHome.dart';
import 'package:testlet/Studying/cards_section_alignment.dart' as prefix0;
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:auto_size_text/auto_size_text.dart';

class profile extends StatefulWidget {
  final VoidCallback SignOut1;

  profile({this.SignOut1});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class Data {
  var url;
  var email;
  var not;
  var displayName;

  Data({this.url, this.email, this.displayName, this.not});
}

class _MyHomePageState extends State<profile> {
  bool isloading = true;
  bool update = false;
  var data = Data();
  double height;
  double width;
  var x;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    width = MediaQuery.of(context).size.width;
    if (isloading == false) {
      return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: FintnessAppTheme.background,
        body: Column(
          children: <Widget>[
            new Stack(
              //alignment: Alignment.bottomCenter,
              children: <Widget>[
//              Image.asset(
//                'assets/collaboration.png',
//                width: MediaQuery.of(context).size.width / 1.5,
//              ),
//              Padding(
//                padding: const EdgeInsets.only(top: 0.0, left: 160),
//                child: new ClipRRect(
//                  borderRadius: new BorderRadius.circular(28.0),
//                  child: Image.asset(
//                    'assets/logo1.png',
//                    //'assets/logo2.png',
//                    width: MediaQuery.of(context).size.width / 2.5,
//                  ),
//                ),
//              ),
                WavyHeader(),
                if (data.url != "null")
                  Padding(
                    padding: EdgeInsets.only(top: 85),
                    child: Align(
                      alignment: Alignment(-0.65, 1),
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(data.url),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),

                CirclePink(
                  data: data,
                ),
                CircleYellow(data: data),
                balls(),
                //ballsrand(260, 80, FintnessAppTheme.midpoint, 20),

                //ballsrand(230, 430, FintnessAppTheme.midpoint, 20),

                //ballsrand(80, 270, FintnessAppTheme.midpoint, 20),

                //ballsrand(260, 80, FintnessAppTheme.midpoint, 20),

                //ballsrand(260, 80, FintnessAppTheme.midpoint, 20),

                //ballsrand(260, 80, FintnessAppTheme.midpoint, 20),
                //ballsrand(),
              ],
            ),

//          Stack(
//            alignment: Alignment.bottomLeft,
//            children: <Widget>[
////              WavyFooter(),
////              CirclePink(),
////              CircleYellow(),
//            ],
//          )
          ],
        ),
      );
    } else {
      List<Widget> list = new List<Widget>();
      list.removeRange(0, list.length);

      if (update == false) {
        setup();
      } else {
        _update;
      }

      list = buildThis(list, FintnessAppTheme.midpoint);
      return new Scaffold(
        backgroundColor: FintnessAppTheme.background,
        body: Stack(
          children: <Widget>[
            WavyHeader(),
            new Column(children: list),
          ],
        ),
      );
    }
  }

  Widget ballsrand(double of1, double of2, Color col, double siz) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(of1, of2),
          child: Material(
            color: col,
            child: Padding(padding: EdgeInsets.all(siz)),
            shape:
                CircleBorder(side: BorderSide(color: Colors.white, width: 5.0)),
          ),
        ),
      ],
    );
  }

  Widget balls() {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(235.0, 515.0),
          child: Material(
            color: Colors.lightGreen,
            child: Padding(padding: EdgeInsets.all(60)),
            shape: CircleBorder(
                side: BorderSide(color: Colors.white, width: 15.0)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 545, left: 263),
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 47,
            tooltip: 'Signout',
            color: FintnessAppTheme.white,
            onPressed: () {
              //print("Hello");
              _signOut(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _update() async {
    final AuthService auth = AuthProvider.of(context).auth;
    setState(() {
      //update = false;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    final AuthService auth = AuthProvider.of(context).auth;
    await auth.signOut();
    widget.SignOut1();
  }

  Future<void> setup() async {
    final AuthService auth = AuthProvider.of(context).auth;
    x = await auth.getprofile();

    //print(x);
    if (x[3] == "null") {
      List y;
      String em = x[1].toString();
      y = em.split("@");
      x[3] = y[0];
    }
    if (x[2] == "null") {
      x[2] = "0";
    }
    data = Data(
      url: x[0],
      email: x[1],
      not: x[2],
      displayName: x[3],
    );

    setState(() {
      isloading = false;
    });
  }

  List buildThis(List list, Color color) {
    list.add(
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
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

const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];

const List<Color> aquaGradients = [
  Color(0xFF5AEAF1),
  Color(0xFF8EF7DA),
];

class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: FintnessAppTheme.grad,
              begin: Alignment.topLeft,
              end: Alignment.center),
        ),
        height: MediaQuery.of(context).size.height / 2.5,
      ),
    );
  }
}

class WavyFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FooterWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          //color: FintnessAppTheme.indigo,
          gradient: LinearGradient(
              colors: FintnessAppTheme.grad,
              begin: Alignment.bottomRight,
              end: Alignment.center),
        ),
        height: MediaQuery.of(context).size.height / 3,
      ),
    );
  }
}

class CirclePink extends StatelessWidget {
  final Data data;

  CirclePink({this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(170, 150.0),
          child: Material(
            color: FintnessAppTheme.red,
            child: Padding(padding: EdgeInsets.all(120)),
            shape: CircleBorder(
                side: BorderSide(color: Colors.white, width: 15.0)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 230, left: /*205*/ 220),
          child: AutoSizeText(
            data.displayName,
            style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'Raleway',
                color: FintnessAppTheme.white),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
//        Padding(
//          padding: EdgeInsets.only(top: 220, left: 323),
//          child: IconButton(
//            icon: Icon(Icons.mode_edit),
//            iconSize: 25,
//            tooltip: 'Change Name',
//            color: FintnessAppTheme.white,
//            onPressed: () {
//            },
//          ),
//        ),
        Padding(
            padding: EdgeInsets.only(top: 290, left: 200),
            child: Container(
                child: AutoSizeText(
              data.email,
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Raleway',
                  color: FintnessAppTheme.white),
              maxLines: 1,
              textAlign: TextAlign.center,
            ))),
      ],
    );
  }
}

class CircleYellow extends StatelessWidget {
  final Data data;

  CircleYellow({this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(-40.0, 350.0),
          child: Material(
            color: FintnessAppTheme.cyan,
            child: Padding(padding: EdgeInsets.all(120)),
            shape: CircleBorder(
                side: BorderSide(color: Colors.white, width: 15.0)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 430, left: 10),
          child: Column(
            children: <Widget>[
              Text("No Of Testlets :",
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Raleway',
                      color: FintnessAppTheme.white)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 460, left: 65),
          child: Column(
            children: <Widget>[
              Text(data.not,
                  style: TextStyle(
                      fontSize: 52.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Raleway',
                      color: FintnessAppTheme.white)),
            ],
          ),
        ),
      ],
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
        Offset(size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 25);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class YellowCircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
