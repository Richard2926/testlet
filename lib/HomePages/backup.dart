import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:testlet/Studying/study.dart';
import 'package:flutter/foundation.dart';
import 'package:testlet/ThemeRelated/AppColors.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:ui' as ui;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class homeScreen extends StatefulWidget {
  //pickImage({Key key, this.title}) : super(key: key);
  final VoidCallback SignOut;
  final VoidCallback NotUploaded;

  homeScreen({this.SignOut, this.NotUploaded});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<homeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  var names;
  var creators;
  var count;
  double boxHeight = 70;
  double width;

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = AuthProvider.of(context).auth;

      await auth.signOut();
      widget.SignOut();
    } catch (e) {
      print(e);
    }
  }

  Future<List> _display() async {
    width = MediaQuery.of(context).size.width;
    names = null;
    final AuthService auth = AuthProvider.of(context).auth;
    //await Future.delayed(Duration(milliseconds: 1800));
    names = await auth.noOfTestletonce();
    return names;
  }

  Future<bool> test() async {
    await Future.delayed(Duration(milliseconds: 5000));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: FintnessAppTheme.background,
        appBar: GradientAppBar(
          title: new Text('Testlets',
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
            FutureBuilder(
                future: _display(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  var name = snapshot.data;

                  List<Widget> list = new List<Widget>();
                  list.removeRange(0, list.length);

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      list = buildThis(list, FintnessAppTheme.black);
                      break;
                    case ConnectionState.waiting:
                      list = buildThis(list, FintnessAppTheme.midpoint);

                      break;
                    case ConnectionState.active:
                      list = buildThis(list, FintnessAppTheme.lightYellow);
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        list = buildThis(list, FintnessAppTheme.lightRed);
                        break;
                      } else if (!snapshot.hasData) {
                        list = buildThis(list, FintnessAppTheme.black);
                      } else {
                        names = name[0];
                        count = name[1];
                        creators = name[2];

                        list.removeRange(0, list.length);

                        list.add(
                          Expanded(
                            child: AnimatedList(
                              key: _listKey,
                              initialItemCount: (names.length + 1),
                              itemBuilder: (context, index, animation) {
                                var item;
                                if (index == 0) {
                                  item = "bruh";
                                } else {
                                  item = names[index - 1];
                                }
                                return Dismissible(
                                  key: Key(item),
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    DismissDirection delete =
                                        DismissDirection.endToStart;
                                    bool res;
                                    if (direction == delete) {
                                      res = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          if (index == 0) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Congrats, Cookie?"),
                                              content: const Text(
                                                  "You have come across a 'Easter Egg', and that was in quotes because in reality, we are just lazy to work around it."),
                                              actions: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                context)
                                                                .pop(false),
                                                        child:
                                                        const Text("Bruh")),
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text(
                                                          "You Dummy"),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            );
                                          }

                                          return AlertDialog(
                                            title: const Text("Confirm"),
                                            content: const Text(
                                                "Are you sure you wish to delete this item?"),
                                            actions: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child:
                                                      const Text("DELETE")),
                                                  FlatButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
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
                                        height: boxHeight + 20,
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
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: boxHeight / 2.7,
                                            left: width - boxHeight),
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
                                        height: boxHeight + 20,
                                        //color: FintnessAppTheme.black,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: FintnessAppTheme.grad,
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: boxHeight / 2.7,
                                            left: boxHeight / 2),
                                        child: Icon(
                                          Icons.library_books,
                                          size: boxHeight / 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: _buildWidgetExample(index),
                                  onDismissed: null,
                                );
                              },
                            ),
                          ),
                        );

                        //return new Column(children: list);
                        break;
                      }
                  }

                  return new Column(children: list);
                }),
          ],
        ));
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

  Widget _buildWidgetExample(int index) {
    if (index == 0) {
      return Container(
        width: (MediaQuery.of(context).size.width / 1.2),
        height: boxHeight / 1.45,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 0, left: 25.0),
            child: Text("Sets",
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway')),
          ),
        ),
      );
    }
    String text = names[index - 1];
    return Container(
      //color: FintnessAppTheme.background,
      decoration: BoxDecoration(
        color: FintnessAppTheme.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: FintnessAppTheme.grey,
            blurRadius: 5.0, // has the effect of softening the shadow
            spreadRadius: 0.0, // has the effect of extending the shadow
            offset: Offset(
              5.0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          )
        ],
      ),
      height: boxHeight,
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: new Center(
        child: new Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
    );
  }
}
