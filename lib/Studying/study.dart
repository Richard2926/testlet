import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'ScreenArguments.dart';
import 'package:flip_card/flip_card.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
class study extends StatefulWidget {
  int docNo;
  static const routeName = '/extractArguments';
  study({Key key}) : super(key: key);

  var x = null;
  int no = null;

  @override
  createState() => FirestoreSlideshowState();
}

class FirestoreSlideshowState extends State<study> {

  final PageController ctrl = PageController(viewportFraction: 0.8);

  int currentPage = 0;


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

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    widget.x = args.docNo;
    widget.no = widget.x.length;

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
              controller: ctrl,
              itemCount: widget.no,
              itemBuilder: (context, int currentIdx) {
                bool active = (currentIdx == currentPage);
                return _buildStoryPage((currentIdx), active);
              }),
        ],
      ),
    );
  }

  // Builder Functions

  _buildStoryPage(int v, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    return FlipCard(
      direction: FlipDirection.VERTICAL,
      front: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/collaboration.png'),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  blurRadius: blur,
                  offset: Offset(offset, offset))
            ]),
        child: Text(widget.x[v][0]),
      ),
      back: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/collaboration.png'),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  blurRadius: blur,
                  offset: Offset(offset, offset))
            ]),
        child: Text(widget.x[v][1]),
      ),
    );
  }
}
