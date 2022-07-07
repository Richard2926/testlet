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
import 'package:testlet/Uploading/ImageSource.dart';
import 'create.dart';
import 'createArguments.dart';
import 'machineRead.dart';

class chooseMethod extends StatefulWidget {
  //pickImage({Key key, this.title}) : super(key: key);
  const chooseMethod({this.Uploaded, this.test});

  final VoidCallback Uploaded;
  final int test;

  //final String title;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<chooseMethod> {
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: GradientAppBar(
            title: new Text('Choose a Method',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Raleway')),
            centerTitle: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (widget.test == 0) {
                    widget.Uploaded();
                  } else {
                    Navigator.pop(context);
                  }
                } //Navigator.popAndPushNamed(context, 'homescreen'),
                /*Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new doneUpload())),*/
                ),
            backgroundColorStart: FintnessAppTheme.grad[0],
            backgroundColorEnd: FintnessAppTheme.grad[1],
          ),
          body: Column(
            children: [
              _buildWidgetExample(1, "Automatic (Alpha)"),
              _buildWidgetExample(2, "Select Front/Back"),
              _buildWidgetExample(3, "Manual Entry"),
            ],
          )),
    );
  }

  Widget push(int control) {
    if (control == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => machineRead(
              test: widget.test,
            )),
      );
    } else if (control == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => pickImage(
                  test: widget.test,
                )),
      );
    } else {
      Navigator.pushNamed(
        context,
        create.routeName,
        arguments: createArguments(["", ""], ["", ""], widget.test , null),
      );
    }

    return null;
  }

  Widget _buildWidgetExample(int index, String text) {
    if (index == 0) {
      return Container(
        width: width,
        height: 50.0,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 3, left: 25.0),
            child: Text("Sets",
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway')),
          ),
        ),
      );
    }

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
            onPressed: () {
              push(index);
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
              child: Container(
                //color: FintnessAppTheme.lightRed,
                constraints: BoxConstraints(
                    minWidth: double.infinity, minHeight: height / 4),
                //alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 20),
                      child: Align(
                        alignment: Alignment(0, -0.8),
                        child: Text(
                          text,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Raleway',
                              color: FintnessAppTheme.black),
                        ),
                      ),
                    ),
                    if (index == 1)
                      Padding(
                          padding: EdgeInsets.only(top: 40, left: 15),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/auto.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/progress.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/result.png",
                                      fit: BoxFit.fitHeight)),
                            ],
                          )),
                    if (index == 2)
                      Padding(
                          padding: EdgeInsets.only(top: 40, left: 15),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/front.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/progress.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/back.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/progress.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/result.png",
                                      fit: BoxFit.fitHeight)),
                            ],
                          )),
                    if (index == 3)
                      Padding(
                          padding: EdgeInsets.only(top: 40, left: 13),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/type.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/progress.png",
                                      fit: BoxFit.fitHeight)),
                              Container(
                                  height: 120,
                                  child: Image.asset("assets/result.png",
                                      fit: BoxFit.fitHeight)),
                            ],
                          ))
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
