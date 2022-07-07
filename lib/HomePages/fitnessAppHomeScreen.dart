import 'package:testlet/HomePages/homeScreen.dart';
import 'package:testlet/HomePages/alternateHome.dart';
import 'package:testlet/ThemeRelated/tabIconData.dart';
import 'profile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:best_flutter_ui_templates/fitnessApp/traning/trainingScreen.dart';
import 'package:flutter/material.dart';
import 'package:testlet/LoginLogic/upload.dart';

import 'package:testlet/HomePages/bottomBarView.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';

//import 'myDiary/myDiaryScreen.dart';
import 'messaging.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  final VoidCallback SignOut;
  final VoidCallback NotUploaded;

  FitnessAppHomeScreen({this.SignOut, this.NotUploaded});

  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  bool checked = false;
  bool ans;
  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    tabBody = homeScreen(
      NotUploaded: widget.NotUploaded,
      SignOut: widget.SignOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {

                return SizedBox(
//                  child: Padding(
//                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
//                    child: Ink(
//                      child: SpinKitPouringHourglass(
//                        duration: Duration(milliseconds: 1500),
//                        color: FintnessAppTheme.midpoint,
//                        size: 250.0,
//                      ),
//                    ),
//                  ),
                ); } else {
                //print(snapshot.data);
                if (snapshot.data == true) {
                  return Stack(
                    children: <Widget>[
                      tabBody,
                      bottomBar(),
                    ],
                  );
                } else {
                  return bruhUpdate();
                }
              }
            }),
      ),
    );
  }

  Widget bruhUpdate() {

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: FintnessAppTheme.grad,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/6),
              child: Image.asset(
                'assets/splashIcon.png',
                width: MediaQuery.of(context).size.width,
              ),
            ),

          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: MediaQuery.of(context).size.height/1.95),
          //child: Text('Testlet has a new Version available, please Update in order to experience new features and bug fixes',
          child: Text('Please update to use Testlet',
              textAlign: TextAlign.center,
              style: TextStyle(

                  color: FintnessAppTheme.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Raleway')),
        ),
      ],
    );
  }

  Future<bool> getData() async {
    final AuthService auth = AuthProvider.of(context).auth;
    if (checked == false) {
      //print("First checkpoint");
      bool x = await auth.isUpToDate();
      ans = x;
      checked = true;
    }

    //await Future.delayed(const Duration(milliseconds: 1000));
    return ans;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            setState(() {
              widget.NotUploaded();
            });
          },
          changeIndex: (index) {
            if (index == 0) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  //tabBody =
                  //MyDiaryScreen(animationController: animationController);
                  tabBody = homeScreen(
                    NotUploaded: widget.NotUploaded,
                    SignOut: widget.SignOut,
                  );
                });
              });
            } else if (index == 2) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  //tabBody =
                  //TrainingScreen(animationController: animationController);
                  tabBody = messaging(
//                    NotUploaded: widget.NotUploaded,
//                    SignOut: widget.SignOut,
                      );
                });
              });
            } else if (index == 1) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  //tabBody =
                  //TrainingScreen(animationController: animationController);
                  tabBody = althomeScreen(
//                    NotUploaded: widget.NotUploaded,
//                    SignOut: widget.SignOut,
                      );
                });
              });
            } else if (index == 3) {
              animationController.reverse().then((data) {
                if (!mounted) return;
                setState(() {
                  //tabBody =
                  //TrainingScreen(animationController: animationController);
                  tabBody = profile(
                    SignOut1: widget.SignOut,
                  );
                });
              });
            }
          },
        ),
      ],
    );
  }
}
