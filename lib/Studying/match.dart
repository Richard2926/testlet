import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'ScreenArguments.dart';
import 'package:flip_card/flip_card.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'cards_section_alignment.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class match extends StatefulWidget {
  int docNo;
  static const routeName = '/match';
  match({Key key}) : super(key: key);

  var x = null;
  int no = null;

  @override
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<match> {

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    widget.x = args.docNo;
    widget.no = widget.x.length;
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return new Scaffold(
      backgroundColor: FintnessAppTheme.background,
      appBar: GradientAppBar(
        title: new Text('Review',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'Raleway')),
        centerTitle: false,
        backgroundColorStart: FintnessAppTheme.grad[0],
        backgroundColorEnd: FintnessAppTheme.grad[1],
      ),
      body: Column(

        children: <Widget>[

          Padding(
            padding:  EdgeInsets.only(top: height/15),
            child: Center(child: new CardsSectionAlignment(context)),
          ),

        ],

      ),
    );
  }


}
