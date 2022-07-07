import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:testlet/Studying/study.dart';
import 'package:flutter/foundation.dart';
import 'package:testlet/Studying/ScreenArguments.dart';
import 'package:testlet/ThemeRelated/AppColors.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:testlet/Uploading/chooseMethod.dart';
import 'package:testlet/LoginLogic/upload.dart';
import 'match.dart';
import 'learn.dart';
//import 'package:testlet/Studying/cards_section_alignment.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:testlet/Studying/review.dart';

class homeStudy extends StatefulWidget {
  int docNo;
  static const routeName = '/homeStudy';

  homeStudy({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<homeStudy> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final PageController ctrl = PageController(viewportFraction: 0.2);

  int currentPage = 0;
  int extra = 5;
  String creator;
  var count;
  double boxHeight = 70;
  List box = [];
  double width;
  bool isloading = false;
  bool private = false;
  bool first = true;
  int tno;
  Color _color = FintnessAppTheme.cyan;
  String name;
  String description;
  var x;
  int no;
  bool some;
  bool canEdit;

  final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>();
  Future<void> push(int option) async {
    switch (option) {
      case (1):
        Navigator.pushNamed(
          context,
          review.routeName,
          arguments: ScreenArguments(x, null, null, null, null, null, null, null),
        );
        break;
      case (2):
        Navigator.pushNamed(
          context,
          match.routeName,
          arguments: ScreenArguments(x, null, null, null, null, null, null, null),
        );
        break;


      case (3):
        Navigator.pushNamed(
          context,
          learn.routeName,
          arguments: ScreenArguments(x, null, null, null, null, null, null, null),
        );
        break;



//      case (4):
//        break;
//      case (5):
//        break;
    }

  }

  @override
  void initState() {
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }


  Future<void> sendInvite() async {
    String email;
    int result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Raleway',
                  color: FintnessAppTheme.black)),
          content: Container(
            constraints:
            BoxConstraints(minWidth: double.infinity, minHeight: boxHeight),
            //alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20, right: 20),
                  child: TextField(
                    controller: TextEditingController()..text = email,
                    //controller: _controller,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Raleway',
                        color: FintnessAppTheme.black),
                    textAlign: TextAlign.left,
                    enableInteractiveSelection: true,

                    minLines: 1,
                    maxLines: 6,
                    //expands: true,
                    onChanged: (text) {
                      email = text;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(2),
                  child: const Text("Cancel",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          color: FintnessAppTheme.black)),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(1),
                  child: const Text("Proceed",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          color: FintnessAppTheme.midpoint)),
                )
              ],
            ),
          ],
        );
      },
    );
    if (result == 1) {
      final AuthService auth = AuthProvider.of(context).auth;
      setState(() {
        isloading = true;
      });
      bool result = await auth.sendInvite(tno, email, creator);
      setState(() {
        isloading = false;
      });
      String msg;
      if(result == true){
        msg = "Invite Sent To $email.";
      }else{
        msg = "Unable To Send. Check email.";
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text(msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            fontFamily: 'Raleway',
          ),
        ),
        duration: new Duration(seconds: 2),
        backgroundColor: FintnessAppTheme.cyan,
      ));
    }
  }


  Future<void> editInfo() async {
    String ins1 = name;
    String ins2 = description;
    int result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Raleway',
                  color: FintnessAppTheme.black)),
          content: Container(
            constraints:
                BoxConstraints(minWidth: double.infinity, minHeight: boxHeight),
            //alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20, right: 20),
                  child: TextField(
                    controller: TextEditingController()..text = name,
                    //controller: _controller,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Raleway',
                        color: FintnessAppTheme.black),
                    textAlign: TextAlign.left,
                    enableInteractiveSelection: true,

                    minLines: 1,
                    maxLines: 6,
                    //expands: true,
                    onChanged: (text) {
                      ins1 = text;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 20, right: 20, bottom: 15),
                  child: TextField(
                    controller: TextEditingController()..text = description,
                    //controller: _controller,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Raleway',
                        color: FintnessAppTheme.black),
                    textAlign: TextAlign.left,
                    enableInteractiveSelection: true,

                    minLines: 1,
                    maxLines: 6,
                    //expands: true,
                    onChanged: (text) {
                      ins2 = text;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(2),
                  child: const Text("Cancel",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          color: FintnessAppTheme.black)),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(1),
                  child: const Text("Proceed",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway',
                          color: FintnessAppTheme.midpoint)),
                )
              ],
            ),
          ],
        );
      },
    );
    if (result == 1) {
      final AuthService auth = AuthProvider.of(context).auth;
      name = ins1;
      description = ins2;
      auth.modifyInfo(tno, name, description);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    if (first == true) {
      name = args.name;
      description = args.description;
      first = false;
      x = args.docNo;
      private = args.status;
      width = MediaQuery.of(context).size.width;
      tno = args.tno;
      some = args.some;
      canEdit = args.editName;
      no = x.length;
      creator = args.creator;
    }

    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: FintnessAppTheme.background,
        appBar: GradientAppBar(
          title: new Text('Home',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Raleway')),
          centerTitle: false,
          backgroundColorStart: FintnessAppTheme.grad[0],
          backgroundColorEnd: FintnessAppTheme.grad[1],
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Upload(),
                    ),
                    (Route<dynamic> route) => false);
              } //
              /*Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new doneUpload())),*/
              ),
          actions: <Widget>[
            if ((canEdit == false && some == false)||(canEdit == false && some == true)||(canEdit == true && some == true))
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.share,
                    color: FintnessAppTheme.white,
                    size: 25,
                  ),
                  onPressed: () {
                    sendInvite();
                  },
                ),
              ),

            if (canEdit == true)
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    private ? Icons.lock : Icons.public,
                    color: FintnessAppTheme.white,
                    size: 25,
                  ),
                  onPressed: () {
                    if (some == true) {
                      setState(() {
                        private = !private;
                      });

                      final AuthService auth = AuthProvider.of(context).auth;
                      auth.changeStatus(tno, private);
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: new Text(
                          "Cannot publish modified work of others",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Raleway',
                          ),
                        ),
                        duration: new Duration(seconds: 2),
                        backgroundColor: FintnessAppTheme.cyan,
                      ));
                    }
                  },
                ),
              ),
            if (canEdit == true)
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: FintnessAppTheme.white,
                    size: 23,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new chooseMethod(
                                  //Uploaded: _uploaded,
                                  test: tno,
                                )));
                  },
                ),
              ),
          ],
        ),
        body: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: (no + extra),
                  itemBuilder: (context, index, animation) {
                    var item;
                    if (index == 0) {
                      return pages();
                    } else if (index == 1) {
                      return buttons();
                    } else if (index == 2) {
                      return Container(
                        width: (MediaQuery.of(context).size.width),
                        height: 50.0,
                        //color: FintnessAppTheme.lightBlue,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 1, left: 25.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text("Info",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Raleway')),
                                ),
                                if (canEdit == true && some == false)
                                  Padding(
                                    padding: EdgeInsets.only(right: 4, top: 7),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.lock,
                                        color: FintnessAppTheme.black,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: new Text(
                                            "Copies initial info cannot be edited",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Raleway',
                                            ),
                                          ),
                                          duration: new Duration(seconds: 2),
                                          backgroundColor:
                                              FintnessAppTheme.cyan,
                                        ));
                                      },
                                    ),
                                  ),
                                if (canEdit == true && some == true)
                                  Padding(
                                    padding: EdgeInsets.only(right: 4, top: 7),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: FintnessAppTheme.black,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        editInfo();
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (index == 3) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                        child: Container(
                          //width: double.infinity,
                          //height: boxHeight,
                          decoration: BoxDecoration(
                            //gradient: myGradient,
                            boxShadow: [
                              BoxShadow(
                                //color: back[0][y],
                                color: FintnessAppTheme.grey,
                                //color: Colors.greenAccent,
                                blurRadius: 5.0,
                                // has the effect of softening the shadow
                                spreadRadius: 0.0,
                                // has the effect of extending the shadow
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
                              //splashColor: FintnessAppTheme.yellow,
                              //splashColor: AppColors.lightPink,
                              onPressed: () {},
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
                                  constraints: BoxConstraints(
                                      minWidth: double.infinity,
                                      minHeight: boxHeight),
                                  //alignment: Alignment.center,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0, left: 20, right: 20),
                                        child: Text(
                                          name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Raleway',
                                              color: FintnessAppTheme.black),
                                        ),
                                      ),
                                      Row(children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 2, left: 105),
                                          child: Align(
                                            alignment: Alignment(-1, 1),
                                            child: AutoSizeText(
                                              creator,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Raleway',
                                                  color: FintnessAppTheme
                                                      .midpoint),
                                              maxLines: 1,
                                              maxFontSize: 13,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 12, left: 10, bottom: 10),
                                          child: Align(
                                            alignment: Alignment(-1, 1),
                                            child: AutoSizeText(
                                              "$no Cards",
                                              textAlign: TextAlign.left,

                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Raleway',
                                                  color: FintnessAppTheme.grey),
                                              maxLines: 1,
                                              //overflowReplacement: Text("..."),
                                              //minFontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                              maxFontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0,
                                            left: 20,
                                            right: 20,
                                            bottom: 15),
                                        child: Text(
                                          description,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Raleway',
                                              color: FintnessAppTheme.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (index == 4) {
                      return Container(
                        width: (MediaQuery.of(context).size.width),
                        height: 50.0,
                        //color: FintnessAppTheme.lightBlue,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, bottom: 1, left: 25.0),
                            child: Text("Cards",
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Raleway')),
                          ),
                        ),
                      );
                    } else {
                      item = x[index - extra][0];
                      if (canEdit == true) {
                        return Dismissible(
                          key: Key(item),
                          confirmDismiss: (DismissDirection direction) async {
                            DismissDirection delete =
                                DismissDirection.endToStart;
                            bool res;
                            int j;
                            if (direction == delete) {
                              res = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm",
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Raleway',
                                            color: FintnessAppTheme.black)),
                                    content: const Text(
                                        "Are you sure you wish to delete this item?",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Raleway',
                                            color:
                                                FintnessAppTheme.nearlyBlack)),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE",
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Raleway',
                                                      color: FintnessAppTheme
                                                          .red))),
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("CANCEL",
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Raleway',
                                                    color: FintnessAppTheme
                                                        .black)),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              String ins1 = x[index - extra][0];
                              String ins2 = x[index - extra][1];
                              j = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm",
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Raleway',
                                            color: FintnessAppTheme.black)),
                                    content: Container(
                                      constraints: BoxConstraints(
                                          minWidth: double.infinity,
                                          minHeight: boxHeight),
                                      //alignment: Alignment.center,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, left: 20, right: 20),
                                            child: TextField(
                                              controller:
                                                  TextEditingController()
                                                    ..text =
                                                        x[index - extra][0],
                                              //controller: _controller,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Raleway',
                                                  color:
                                                      FintnessAppTheme.black),
                                              textAlign: TextAlign.left,
                                              enableInteractiveSelection: true,

                                              minLines: 1,
                                              maxLines: 6,
                                              //expands: true,
                                              onChanged: (text) {
                                                ins1 = text;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 20.0,
                                                left: 20,
                                                right: 20,
                                                bottom: 15),
                                            child: TextField(
                                              controller:
                                                  TextEditingController()
                                                    ..text =
                                                        x[index - extra][1],
                                              //controller: _controller,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: 'Raleway',
                                                  color:
                                                      FintnessAppTheme.black),
                                              textAlign: TextAlign.left,
                                              enableInteractiveSelection: true,

                                              minLines: 1,
                                              maxLines: 6,
                                              //expands: true,
                                              onChanged: (text) {
                                                ins2 = text;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(2),
                                            child: const Text("Cancel",
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Raleway',
                                                    color: FintnessAppTheme
                                                        .black)),
                                          ),
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(1),
                                            child: const Text("Proceed",
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Raleway',
                                                    color: FintnessAppTheme
                                                        .midpoint)),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (j == 1) {
                                final AuthService auth =
                                    AuthProvider.of(context).auth;
                                x[index - extra][0] = ins1;
                                x[index - extra][1] = ins2;
                                auth.modifyCard(index - extra, tno,
                                    x[index - extra][0], x[index - extra][1]);
//                                setState(() {
//
//                                });
                              }
                              res = false;
                            }

                            return res;
                          },
                          secondaryBackground: Stack(
                            children: <Widget>[
                              Container(
                                //height: boxHeight + 20,
                                //color: FintnessAppTheme.lightRed,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.redAccent,
                                        FintnessAppTheme.lightRed
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                ),
                              ),
                              Align(
                                alignment: Alignment(0.8, 0),
                                child: Icon(
                                  Icons.delete,
                                  size: boxHeight / 1.8,
                                ),
                              ),
                            ],
                          ),
                          background: Stack(
                            children: <Widget>[
                              Container(
                                //height: boxHeight + 20,
                                //color: FintnessAppTheme.black,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
//                                    colors: [
//                                      FintnessAppTheme.yellow,
//                                      FintnessAppTheme.lightYellow,
//                                    ],
                                      colors: FintnessAppTheme.grad,
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                ),
                              ),
                              Align(
                                alignment: Alignment(-0.8, 0),
                                child: Icon(
                                  Icons.mode_edit,
                                  //Icons.star,
                                  color: Colors.white,
                                  size: boxHeight / 2,
                                ),
                              ),
                            ],
                          ),
                          child: _buildWidgetExample(index - (extra)),
                          onDismissed: (direction) {
//                          List x = frontCards;
//                          x.removeAt(index - extra);
//                          frontCards = x;
//
//
//                          List y = backCards;
//                          y.removeAt(index - extra);
//                          backCards = y;

                            //print(frontCards);
                            //print(index - extra);
                            //print(frontCards);

                            _listKey.currentState.removeItem(
                              index - extra,
                              (BuildContext context,
                                      Animation<double> animation) =>
                                  _buildWidgetExample((index - extra)),
                              duration: const Duration(milliseconds: 0),
                            );

//                          print(frontCards);
//                          print(backCards);

                            x.removeAt(index - extra);
                            no--;

                            final AuthService auth =
                                AuthProvider.of(context).auth;
                            auth.deleteCard(index - extra, tno);
                            if (no == 0) {
                              auth.deleteTestlet(tno);
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => Upload(),
                                  ),
                                  (Route<dynamic> route) => false);
                            }
//                          print(frontCards);
//                          print(backCards);
                            //keys.removeAt(index - extra);
                            //_listKey1.removeAt(index - extra);
                          },
                        );
                      } else {
                        return _buildWidgetExample(index - (extra));
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ]));
  }

  Widget buttons() {
    return Container(
      height: 100,
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              subbuttons(
                  "Review", 100.0, width  - 20, 10, Icons.library_books, 1),
//              subbuttons(
//                  "Learn", 100.0, width / 2 - 15, 10, Icons.import_contacts, 2),
            ],
          ),
//          Padding(
//            padding: EdgeInsets.only(top: 10.0),
//            child: Row(
//              children: <Widget>[
////                subbuttons("Run", 100.0, (width - 40) / 3, 10,
////                    Icons.directions_run, 3),
//                subbuttons("Match", 100.0, width / 2 - 15, 10,
//                    Icons.content_copy, 2),
//                subbuttons(
//                    "Learn", 100.0, width / 2 - 15, 10, Icons.import_contacts, 3),
////                subbuttons(
////                    "Grid It", 100.0, (width - 40) / 3, 10, Icons.grid_on, 5),
//              ],
//            ),
//          ),
        ],
      ),
    );
  }

  Widget pages() {
    return new Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: FintnessAppTheme.grad,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
          height: 140,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 140.0),
          child: Container(
            color: FintnessAppTheme.background,
            height: 80,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 0),
          child: Container(
              height: 210,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return _buildStoryPage(index);
                },
                itemCount: no,
                viewportFraction: 0.85,
                scale: 0.9,
                loop: false,
                //pagination: new SwiperPagination(),
                //control: new SwiperControl(),
                //loop: false,
              )),
        )
      ],
    );
  }

  Widget _buildWidgetExample(int index) {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
      child: Container(
        //width: double.infinity,
        //height: boxHeight,
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
            //splashColor: FintnessAppTheme.yellow,
            //splashColor: AppColors.lightPink,
            onPressed: () {},
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
                constraints: BoxConstraints(
                    minWidth: double.infinity, minHeight: boxHeight),
                //alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 20, right: 20),
                      child: Text(
                        x[index][0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Raleway',
                            color: FintnessAppTheme.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, left: 20, right: 20, bottom: 15),
                      child: Text(
                        x[index][1],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Raleway',
                            color: FintnessAppTheme.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildStoryPage(int v) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.0),
      child: new FlipCard(
        direction: FlipDirection.VERTICAL,
        front: slides(x[v][0]),
        back: slides(x[v][1]),
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

  Widget subbuttons(String text, double height, double width, double left,
      IconData icons, int option) {
    return Padding(
      padding: EdgeInsets.only(left: left),
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
                3.0, // horizontal, move right 10
                3.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: RaisedButton(
            //splashColor: FintnessAppTheme.indigo,
            onPressed: () {
   push(option);
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
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment(0, 0.6),
                            child: Text(
                              text,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Raleway',
                                  color: _color),
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment(0, -0.6),
                            child: Icon(
                              icons,
                              color: _color,
                              size: 40,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height - 5),
                            child: AnimatedContainer(
                              height: 5,
                              color: _color,
                              duration: Duration(milliseconds: 10000),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
