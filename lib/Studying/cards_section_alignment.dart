import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'ScreenArguments.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:confetti/confetti.dart';

List<Alignment> cardsAlign = [
  new Alignment(0.0, 1.0),
  new Alignment(0.0, 0.8),
  new Alignment(0.0, 0.0)
];
List<Size> cardsSize = new List(3);
var x;
int goal;
double width;
double height;
List correct = [];
List review = [];
double factor = 0;

class CardsSectionAlignment extends StatefulWidget {
  CardsSectionAlignment(BuildContext context) {
    cardsSize[0] = new Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6);
    cardsSize[1] = new Size(MediaQuery.of(context).size.width * 0.85,
        MediaQuery.of(context).size.height * 0.55);
    cardsSize[2] = new Size(MediaQuery.of(context).size.width * 0.8,
        MediaQuery.of(context).size.height * 0.5);
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    x = args.docNo;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  @override
  _CardsSectionState createState() => new _CardsSectionState();
}

class _CardsSectionState extends State<CardsSectionAlignment>
    with SingleTickerProviderStateMixin {
  int cardsCounter = 0;
  List<Widget> cards = new List();
  AnimationController _controller;
  Color usage = FintnessAppTheme.white;
  double len;
  double wid;
  String msg;
  final Alignment defaultFrontCardAlign = new Alignment(0.0, 0.0);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  //ConfettiController con =
  //new ConfettiController(duration: Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    goal = x.length;
    // Init cards
    for (int i = 0; i < goal; i++) {
      cards.add(ProfileCardAlignments(x[i][0], x[i][1]));
    }

    correct.removeRange(0, correct.length);

    review.removeRange(0, review.length);
    //cardsCounter = goal;

    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller = new AnimationController(
        duration: new Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) changeCardsOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Container(
            //color: FintnessAppTheme.lightYellow,
            height: MediaQuery.of(context).size.height / 1.5,
            child: new Stack(
              children: <Widget>[
                if (cardsCounter < (goal - 2)) backCard(),
                if (cardsCounter < (goal - 1))
                  middleCard(),
                if (cardsCounter < (goal))
                  frontCard(),
//            if (cardsCounter == goal && correct.length > 0)
//              new Align(
//                  alignment: Alignment(0, 1),
//                  child: new ConfettiWidget(
//                    confettiController: con,
//                    blastDirection: -pi / 2,
//                    numberOfParticles: 10,
//                    maxBlastForce: 65,
//                  )),
//                if (cardsCounter != goal)
//                  Align(alignment: Alignment(0, 0), child: exitreview()),
                if (cardsCounter == goal)
                  ondone(),
                if (cardsCounter != goal)
                  _controller.status != AnimationStatus.forward
                      ? new SizedBox.expand(
                          child: new GestureDetector(
                          // While dragging the first card
                          onPanUpdate: (DragUpdateDetails details) {
                            // Add what the user swiped in the last frame to the alignment of the card
                            setState(() {
                              // 20 is the "speed" at which moves the card
                              frontCardAlign = new Alignment(
                                  frontCardAlign.x +
                                      20 *
                                          details.delta.dx /
                                          MediaQuery.of(context).size.width,
                                  frontCardAlign.y +
                                      40 *
                                          details.delta.dy /
                                          MediaQuery.of(context).size.height);

                              frontCardRot =
                                  frontCardAlign.x; // * rotation speed;
                            });
                          },
                          // When releasing the first card
                          onPanEnd: (_) {
                            // If the front card was swiped far enough to count as swiped
                            if (frontCardAlign.x > 3.0) {
                              correct.add(cardsCounter);
                              animateCards();
                            } else if (frontCardAlign.x < -3.0) {
                              review.add(cardsCounter);
                              animateCards();
                            } else {
                              // Return to the initial rotation and alignment
                              setState(() {
                                frontCardAlign = defaultFrontCardAlign;
                                frontCardRot = 0.0;
                              });
                            }
                          },
                        ))
                      : new Container(),
              ],
            )),
      ],
    );
  }

  Widget ProfileCardAlignments(String text1, String text2) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.0),
      child: new FlipCard(
        direction: FlipDirection.VERTICAL,
        front: slides(text1),
        back: slides(text2),
      ),
    );
  }

  Widget exitreview() {
    cardsCounter = x.length;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        //gradient: myGradient,
        boxShadow: [
          BoxShadow(
            //color: back[0][y],
            color: FintnessAppTheme.grey,
            //color: Colors.greenAccent,
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 0.0, // has the effect of extending the shadow
            offset: Offset(
              2.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: RaisedButton(
          //splashColor: FintnessAppTheme.indigo,
          onPressed: () {
            cards.removeRange(0, cards.length);

            Navigator.of(context).pop();
          },
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              color: FintnessAppTheme.white,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                    constraints:
                        const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment(-0.9, 0),
                          child: Icon(
                            Icons.transit_enterexit,
                            color: FintnessAppTheme.black,
                            size: 40,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Align(
                            alignment: Alignment(0.4, 0),
                            child: Text(
                              "Exit Review",
                              style: TextStyle(
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Raleway',
                                  color: FintnessAppTheme.black),
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: height - 5),
                  child: AnimatedContainer(
                    height: 5,
                    color: FintnessAppTheme.black,
                    duration: Duration(milliseconds: 10000),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ondone() {
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
              correct.length.toDouble(), FintnessAppTheme.teal,
              rankKey: 'Q2'),
          new CircularSegmentEntry(
              review.length.toDouble(), FintnessAppTheme.yellow,
              rankKey: 'Q1'),
        ],
        rankKey: 'Cards Result',
      ),
    ];
    //con.play();
    if (review.length == 0) {

      len = -0.3;
      wid = width/2;
      msg = "Excellent!";
    } else if (correct.length == 0) {
      len = -0.5;
      wid = width/2;
      msg = "Keep Working!";
    } else {
      len = -0.5;
      wid = width/3;
      msg = "Nice Work!";
    }
    int no = cards.length;
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0, -1),
          child: Column(
            children: <Widget>[
              AnimatedCircularChart(
                key: _chartKey,
                size: const Size(300.0, 300.0),
                initialChartData: data,
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
              ),
              if (correct.length >= 0)
                subbuttons("Revise All", height / 15, width / 1.8, Icons.loop,
                    FintnessAppTheme.teal, 1),
              if (review.length > 0)
                subbuttons("Saved Ones", height / 15, width / 1.8,
                    Icons.bookmark, FintnessAppTheme.yellow, 2),
              subbuttons("Exit Review", height / 15, width / 1.8,
                  Icons.transit_enterexit, FintnessAppTheme.black, 3),
            ],
          ),
        ),
        Align(
            alignment: Alignment(0, len),
            child: Container(

              height: height/4,
              width: wid,
              //color: FintnessAppTheme.lightRed,
              child: AutoSizeText(
                msg + "${correct.length}/$no" ,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Raleway',
                    color: FintnessAppTheme.black),
                maxLines: 10,
                maxFontSize: 40,
              ),
            ))
      ],
    );
  }

  Widget subbuttons(String text, double height, double width, IconData icons,
      Color _color, int option) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          //gradient: myGradient,
          boxShadow: [
            BoxShadow(
              //color: back[0][y],
              color: FintnessAppTheme.grey,
              //color: Colors.greenAccent,
              blurRadius: 5.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                2.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: RaisedButton(
            //splashColor: FintnessAppTheme.indigo,
            onPressed: () {
              cards.removeRange(0, cards.length);
              int i;
              switch (option) {
                case (1):
                  for (int i = 0; i < x.length; i++) {
                    cards.add(ProfileCardAlignments(x[i][0], x[i][1]));
                  }
                  setState(() {
                    goal = x.length;
                    cardsCounter = 0;
                    correct.removeRange(0, correct.length);
                    review.removeRange(0, review.length);
                    frontCardAlign = cardsAlign[2];
                  });
                  break;
                case (2):
                  for (int j = 0; j < review.length; j++) {
                    i = review[j];
                    cards.add(ProfileCardAlignments(x[i][0], x[i][1]));
                  }
                  setState(() {
                    goal = review.length;
                    cardsCounter = 0;
                    correct.removeRange(0, correct.length);
                    review.removeRange(0, review.length);
                    frontCardAlign = cardsAlign[2];
                  });
                  break;
                case (3):
                  Navigator.of(context).pop();
                  break;
              }
            },
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                //gradient: myGradient,
//                gradient: new LinearGradient(
//                    colors: [AppColors.lightRed, Colors.cyanAccent],
//                    begin: Alignment.centerLeft,
//                    end: Alignment.centerRight,
//                    tileMode: TileMode.clamp),
                //color: back[1][y],
                color: FintnessAppTheme.white,
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                      constraints:
                          const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Align(
                            alignment: Alignment(-0.9, 0),
                            child: Icon(
                              icons,
                              color: _color,
                              size: 40,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.0),
                            child: Align(
                              alignment: Alignment(0.4, 0),
                              child: Text(
                                text,
                                style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Raleway',
                                    color: _color),
                                textScaleFactor: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: height - 5),
                    child: AnimatedContainer(
                      height: 5,
                      color: _color,
                      duration: Duration(milliseconds: 10000),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget slides(String text) {
    return Container(
      decoration: BoxDecoration(
        //gradient: myGradient,
        boxShadow: [
          BoxShadow(
            //color: back[0][y],
            color: FintnessAppTheme.grey,
            //color: Colors.greenAccent,
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 0.0, // has the effect of extending the shadow
            offset: Offset(
              5.0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: RaisedButton(
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              //gradient: myGradient,
//                gradient: new LinearGradient(
//                    colors: [AppColors.lightRed, Colors.cyanAccent],
//                    begin: Alignment.centerLeft,
//                    end: Alignment.centerRight,
//                    tileMode: TileMode.clamp),
              //color: back[1][y],
              color: FintnessAppTheme.white,
            ),
            child: Container(
              constraints:
                  const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 10, bottom: 10),
                child: AutoSizeText(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Raleway',
                      color: FintnessAppTheme.black),
                  maxLines: 10,
                  maxFontSize: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget backCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return new Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: new SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    if (frontCardAlign.x > 0) {
      msg = "Got It";
      factor = frontCardAlign.x / (16);
      usage = Color.fromRGBO(79, 193, 166, frontCardAlign.x / (16));
    } else if (frontCardAlign.x < 0) {
      msg = "Study Again";
      factor = frontCardAlign.x / (-16);
      usage = Color.fromRGBO(246, 199, 71, frontCardAlign.x / (-16));
    } else {
      msg = "";
      factor = 0;
      usage = FintnessAppTheme.white;
    }
    return new Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign)
                .value
            : frontCardAlign,
        child: new Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: new SizedBox.fromSize(
              size: cardsSize[0],
              child: Stack(
                children: <Widget>[
                  cards[0],
                  if (factor > 0 || factor > 0)
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(5.0),
                          topRight: const Radius.circular(5.0)),
                      child: Container(
                        height: height / 10,
                        width: double.infinity,
                        color: usage,
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: Text(
                            msg,
                            style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Raleway',
                                color: Color.fromRGBO(33, 41, 48, factor)),
                          ),
                        ),
                      ),
                    )
                ],
              )),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      for (int i = 0; i < (goal - 1); i++) {
        cards[i] = cards[i + 1];
      }
      cardsCounter++;
      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return new AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return new SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        new CurvedAnimation(
            parent: parent,
            curve: new Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent, Alignment beginAlign) {
    return new AlignmentTween(
      begin: beginAlign,
      end: new Alignment(
          beginAlign.x > 0 ? (beginAlign.x + 30.0) : beginAlign.x - 30.0, 0.0),
    ).animate(new CurvedAnimation(
        parent: parent, curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
