import 'package:flutter/material.dart';
import 'package:testlet/LoginLogic/upload.dart';
import 'dart:async';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:testlet/ThemeRelated/AppColors.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'createArguments.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
class create extends StatefulWidget {
  static const routeName = '/create';

  create({Key key}) : super(key: key);

  var frontCards;
  var backCards;
  int no;
  var spam;

  @override
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<create> {
  final _controller = TextEditingController();

  String name;
  String decp;
  bool doneEdit = true;
  bool new1 = true;
  List keys = [];
  List frontControl = [];
  List backControl = [];
  int counter = 0;
  int extra = 1;
  bool private = true;

  @override
  void initState() {
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _listKey1 = GlobalKey<AnimatedListState>();
  double boxHeight = 70;

  @override
  Widget build(BuildContext context) {
    final createArguments args = ModalRoute.of(context).settings.arguments;

    widget.frontCards = args.cards1;
    widget.backCards = args.cards;
    widget.no = args.function;
    widget.spam = args.spam;

    if (new1 == true) {
      for (int i = 0; i < widget.frontCards.length; i++) {
        keys.add((counter.toString()));
        counter++;
      }
      for(int i = 0; i< widget.frontCards.length; i++){
        frontControl.add(TextEditingController());

        backControl.add(TextEditingController());

        frontControl[i].text = widget.frontCards[i];

        backControl[i].text = widget.backCards[i];

      }
      new1 = false;
    }

    if(widget.no != 0) extra = 0;

    int noOfCards = widget.frontCards.length + extra;

    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;
    print(widget.frontCards);
    print(widget.backCards);
    if (doneEdit == true) {
      return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor: FintnessAppTheme.background,
          appBar: GradientAppBar(
            title: new Text('Create',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Raleway')),
            centerTitle: false,
            backgroundColorStart: FintnessAppTheme.grad[0],
            backgroundColorEnd: FintnessAppTheme.grad[1],
            actions: <Widget>[
              if(widget.no == 0)Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    private ? Icons.lock : Icons.public,
                    color: FintnessAppTheme.white,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      private = !private;
                    });
                  },
                ),
              ),
            ],
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
          ),
          body: Stack(
            children: <Widget>[
              AnimatedList(
                  key: _listKey1,
                  initialItemCount: noOfCards,
                  itemBuilder: (context, index, animation) {
                    var item;
                    //print(index - extra);

                    if (index == 0 && widget.no == 0) {
                      return _buildWidgetExample(-1);
                    } else {
                      //item = widget.frontCards[index - extra] + (index-extra).toString();
                      item = keys[index - extra];
                      //counter ++;
                      return Dismissible(
                        key: Key(item),
                        confirmDismiss: (DismissDirection direction) async {
                          DismissDirection delete = DismissDirection.endToStart;
                          bool res;
                          if (direction == delete) {
                            res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you wish to delete this card?"),
                                  actions: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text("DELETE")),
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("CANCEL"),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
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
                        child: SizeTransition(
                          sizeFactor: animation,
                          child: _buildWidgetExample(index - (extra)),
                        ),
                        onDismissed: (direction) {
//                          List x = widget.frontCards;
//                          x.removeAt(index - extra);
//                          widget.frontCards = x;
//
//
//                          List y = widget.backCards;
//                          y.removeAt(index - extra);
//                          widget.backCards = y;

//                          print(widget.frontCards);
//                          print(index - extra);
//                          print(widget.frontCards);
//
//                          print("bruh");
                          _listKey1.currentState.removeItem(
                            index - extra,
                            (BuildContext context,
                                    Animation<double> animation) =>
                                _buildWidgetExample((index - extra)),
                            duration: const Duration(milliseconds: 0),
                          );
//
//                          print(widget.frontCards);
//                          print(widget.backCards);

                          widget.frontCards.removeAt(index - extra);
                          widget.backCards.removeAt(index - extra);
                          frontControl.removeAt(index - extra);
                          backControl.removeAt(index - extra);

                          print(widget.frontCards);
                          print(widget.backCards);
                          keys.removeAt(index - extra);
                          //_listKey1.removeAt(index - extra);
                        },
                      );
                    }
                  }),
              button(Icons.add, height * 0.76, width * 0.05, 0),
              button(Icons.check_circle, height * 0.76, width * 0.75, 1),
            ],
          ),
        ),
      );
    } else {
      List<Widget> list = new List<Widget>();
      list.removeRange(0, list.length);
      list = buildThis(list, FintnessAppTheme.midpoint);
      return new WillPopScope(
        onWillPop: () async => false,
        child: new Scaffold(
          backgroundColor: FintnessAppTheme.background,
          appBar: GradientAppBar(
            title: new Text('Create',
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
              new Container(
                  height: height,
                  width: double.infinity,
                  child: Column(
                    children: list,
                  )),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildWidgetExample(int index) {
    if (index == -1) {
      return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
        child: Container(
//        width: double.infinity,
//        height: boxHeight,
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
                        padding:
                            EdgeInsets.only(top: 10.0, left: 20, right: 20),
                        child: TextField(
                          //controller: _controller,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Raleway',
                              color: FintnessAppTheme.black),
                          textAlign: TextAlign.left,
                          enableInteractiveSelection: true,
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              hintText: 'Name Of this Set'),
                          minLines: 1,
                          maxLines: 2,
                          //expands: true,
                          onChanged: (text) {
                            name = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, left: 20, right: 20, bottom: 15),
                        child: TextField(
                          //controller: _controller,

                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Raleway',
                              color: FintnessAppTheme.black),
                          textAlign: TextAlign.left,
                          enableInteractiveSelection: true,

                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              hintText: 'Description'),
                          minLines: 1,
                          maxLines: 6,
                          //expands: true,
                          onChanged: (text) {
                            decp = text;
                          },
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
    if(widget.spam != null){
      return Padding(
        padding:
        EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
        child: Container(
//        width: double.infinity,
//        height: boxHeight,
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
                        padding: EdgeInsets.only(top: 10.0, left: 0, right: 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: TextField(
                                controller: frontControl[index],
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
                                  widget.frontCards[index] = text;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 16.0),
                              child: Container(

                                width: MediaQuery.of(context).size.width/1.18,
                                //width: MediaQuery.of(context).size.width/1.1,
                                child: DropdownButton<String>(
                                  items: [
                                    for(int i = 0; i < widget.spam.length; i++)
                                      DropdownMenuItem<String>(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width/1.3,
                                          child: AutoSizeText(
                                            widget.spam[i],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Raleway',
                                                color: FintnessAppTheme.black),
                                            maxLines: 2,
                                            //overflowReplacement: Text("..."),
                                            minFontSize: 15,
                                            maxFontSize: 15,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        value: widget.spam[i],
                                      ),

                                  ],
                                  onChanged: (String value) {
                                    //setState(() {
                                    print(value);

                                    widget.frontCards[index] = value;
                                      frontControl[index].text = value;
                                    //});
                                  },
                                  hint: Icon(
                                    Icons.restore_from_trash,
                                    color: FintnessAppTheme.midpoint,
                                    size: boxHeight / 2,),
                                  //value: _value,
                                ),
                              ),
                            ),

//                            PopupMenuButton<String>(
//                              elevation: 3.2,
//                              initialValue: "bruh",
//                              onCanceled: () {
//                                print('You have not chossed anything');
//                              },
//                              tooltip: 'This is tooltip',
//                              onSelected: null,
//                              itemBuilder: (BuildContext context) {
//
//                                return ["burhrh", "nruh"].map((String choice) {
//                                  return PopupMenuItem<String>(
//                                    value: choice,
//                                    child: AutoSizeText(
//                                          choice,
//                                          textAlign: TextAlign.left,
//                                          style: TextStyle(
//                                              fontSize: 15.0,
//                                              fontWeight: FontWeight.w300,
//                                              fontFamily: 'Raleway',
//                                              color: FintnessAppTheme.black),
//                                          maxLines: 2,
//                                          //overflowReplacement: Text("..."),
//                                          minFontSize: 15,
//                                          maxFontSize: 15,
//                                          overflow: TextOverflow.ellipsis,
//                                        ),
//                                  );
//                                }).toList();
//                              },
//                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            top: 13.0, left: 0, right: 0, bottom: 15),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/1.2,
                              child: TextField(
                                controller: backControl[index],
                                  //..text = widget.backCards[index],
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
                                  widget.backCards[index] = text;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 16.0),
                              child: Container(
                                //color: AppColors.lightTeal,
                                width: MediaQuery.of(context).size.width/1.18,
                                child: DropdownButton<String>(
                                  items: [
                                    for(int i =0; i < widget.spam.length; i++)
                                      DropdownMenuItem<String>(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width/1.3,
                                          child: AutoSizeText(
                                            widget.spam[i],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Raleway',
                                                color: FintnessAppTheme.black),
                                            maxLines: 2,
                                            //overflowReplacement: Text("..."),
                                            minFontSize: 15,
                                            maxFontSize: 15,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        value: widget.spam[i],
                                      ),

                                  ],
                                  onChanged: (String value) {
                                    //print(backControl[index].text);
                                    //setState(() {
                                    print(value);

                                    widget.backCards[index] = value;
                                      backControl[index].text = value;
                                    //});
                                  },
                                  hint: Icon(
                                    Icons.restore_from_trash,
                                    color: FintnessAppTheme.midpoint,
                                    size: boxHeight / 2,),
                                  //value: _value,
                                ),
                              ),
                            ),
                          ],
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
    }else{
      return Padding(
        padding:
        EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
        child: Container(
//        width: double.infinity,
//        height: boxHeight,
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
//                  gradient: myGradient,
//                gradient: new LinearGradient(
//                    colors: [AppColors.lightRed, Colors.cyanAccent],
//                    begin: Alignment.centerLeft,
//                    end: Alignment.centerRight,
//                    tileMode: TileMode.clamp),
//                  color: back[1][y],
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
                        child: TextField(
                          controller: TextEditingController()
                            ..text = widget.frontCards[index],
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
                            widget.frontCards[index] = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, left: 20, right: 20, bottom: 15),
                        child: TextField(
                          controller: TextEditingController()
                            ..text = widget.backCards[index],
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
                            widget.backCards[index] = text;
                          },
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

  }

  Future<void> _putitup() async {
    String error = "";

//    print(widget.frontCards);
//    print(widget.backCards);

    if(widget.no ==0){
      if (name == null || decp == null) {
        error = "Name and Description cant be empty";
      }

    }
    for (int i = 0; i < widget.backCards.length; i++) {
      if (widget.backCards[i] == "" || widget.frontCards[i] == "") {
        error = "Cards cannot be empty";
        break;
      }
    }
    if(widget.backCards.length == 0){
      error = "Need at least one card";
    }
    if (error != "") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text(
          error,
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
    } else {
      setState(() {
        doneEdit = false;
      });
      final AuthService auth = AuthProvider.of(context).auth;
      if(widget.no == 0){

        await auth.updateTestlet(widget.frontCards, widget.backCards,
            widget.backCards.length, name, decp, private, true, null);

      }else{

        await auth.addcards(widget.frontCards, widget.backCards,
            widget.backCards.length, widget.no);
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Upload(),
          ),
          (Route<dynamic> route) => false);
    }
  }

  void dispose() {
    _controller.dispose();
    for(int i = 0; i < frontControl.length; i ++){
      frontControl[i].dispose();
      backControl[i].dispose();
    }
    super.dispose();
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
                      if (option == 0) {
                        keys.insert(0, counter.toString());
                        counter++;
                        widget.frontCards.insert(0, "");
                        widget.backCards.insert(0, "");
                        frontControl.insert(0, TextEditingController());
                        backControl.insert(0, TextEditingController());
//
//                        print(widget.backCards);
//                        print(widget.frontCards);
                        _listKey1.currentState.insertItem(
                          extra,
                          duration: Duration(milliseconds: 500),
                        );
                      } else {
                        _putitup();
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

//class TextInheritedWidget extends InheritedWidget {
//  const TextInheritedWidget({Key key, this.text, Widget child})
//      : super(key: key, child: child);
//
//  final String text;
//
//  @override
//  bool updateShouldNotify(TextInheritedWidget old) {
//    return text != old.text;
//  }
//
//  static TextInheritedWidget of(BuildContext context) {
//    return context.inheritFromWidgetOfExactType(TextInheritedWidget);
//  }
//}


class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}