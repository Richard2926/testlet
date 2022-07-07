import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:testlet/Studying/ScreenArguments.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';
import 'package:testlet/Studying/HomeStudy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:testlet/Studying/review.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'default_app_bar.dart';
import 'package:testlet/LoginLogic/upload.dart';
class althomeScreen extends StatefulWidget {
  //pickImage({Key key, this.title}) : super(key: key);
  final VoidCallback SignOut;
  final VoidCallback NotUploaded;

  althomeScreen({this.SignOut, this.NotUploaded});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<althomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  var maindata;
  var names;
  var creators;
  var tno;
  var count;
  var status;

  var description;
  String search ='';
  bool getting = false;
  double boxHeight = 70;
  double width;
  bool isloading = false;

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
    getting = true;
    final AuthService auth = AuthProvider.of(context).auth;

    width = MediaQuery.of(context).size.width;
    maindata = null;

    //await Future.delayed(Duration(milliseconds: 1500));
    maindata = await auth.searchTestlets(search);
    //names = null;
    getting = false;
    //print(maindata);
    return maindata;
  }

//  Future<bool> test() async {
//    await Future.delayed(Duration(milliseconds: 5000));
//    return true;
//  }

  onSearchQueryChange(String query) {
   //print(query);
    if(query.length >= 0){

      setState(() {
        //search = query;
      });
    }
    if (query != '') {}
  }

  cancelSearch() {
    onSearchQueryChange('');
  }

  @override
  Widget build(BuildContext context) {
    if (isloading == false && search == '') {
      return Scaffold(
          backgroundColor: FintnessAppTheme.background,
          appBar: DefaultAppBar(
            onCancelSearch: cancelSearch,
            onSearchQueryChanged: onSearchQueryChange,
          ),
          body: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                Image.asset(
                  "assets/fall.gif",
                  width: MediaQuery.of(context).size.width,
                  height: 300.0 - 38-10,
                ),
                Padding(
                  padding: EdgeInsets.only(top:15),
                  child: Text('Learn from others work',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Raleway')),
                ),
                Padding(
                  padding: EdgeInsets.only(top:15),
                  child: Text('Coming Soon',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Raleway')),
                ),
//                Image.asset(
//                  "assets/down.gif",
//                  width: MediaQuery.of(context).size.width,
//                  height: 150.0,
//                ),
              ],
            )
          ]));
    }
    if (isloading == false) {
      return new Scaffold(
          backgroundColor: FintnessAppTheme.background,
          appBar: DefaultAppBar(
            onCancelSearch: cancelSearch,
            onSearchQueryChanged: onSearchQueryChange,
          ),
          body: Stack(
            children: <Widget>[
              FutureBuilder(
                  future: _display(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                          //list = buildThis(list, FintnessAppTheme.black);
                          list.add(Padding(
                            padding: EdgeInsets.only(top:150),
                            child: Center(
                              child: Text('No Results Found',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Raleway')),
                            ),
                          ),);
                        } else {
                          //print(snapshot.data);
                          names = name[0];
                          count = name[1];
                          creators = name[2];
                          description = name[3];
                          tno = name[4];
                          status = name[5];

                          list.removeRange(0, list.length);

                          list.add(
                            Expanded(
                              child: AnimatedList(
                                key: _listKey,
                                initialItemCount: (names.length + 2),
                                itemBuilder: (context, index, animation) {
                                  var item;
                                  if (index == 0) {
                                    return _buildWidgetExample(index);
                                  } else if (index == (names.length + 1)) {
                                    return Container(
                                      height: 100,
                                    );
                                  } else {
                                    item = names[index - 1];

                                    String text = names[index - 1].toString();

                                    String cre = creators[index - 1].toString();

                                    String desc = description[index - 1].toString();

                                    int couns = count[index - 1];

                                    int tnum = tno[index - 1];
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
                                              return AlertDialog(
                                                title: const Text("Confirm",style: TextStyle(
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Raleway',
                                                    color: FintnessAppTheme.black)),
                                                content: const Text(
                                                    "Do you want to add this to your sets?",style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Raleway',
                                                    color: FintnessAppTheme.nearlyBlack)),
                                                actions: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      FlatButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          child: const Text(
                                                              "Proceed",style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: 'Raleway',
                                                              color: FintnessAppTheme.midpoint),)),
                                                      FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: const Text(
                                                            "Cancel", style: TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'Raleway',
                                                            color: FintnessAppTheme.red),),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          startup(tnum, text,cre, desc,couns, false);
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
                                                    Colors.yellow,
                                                    FintnessAppTheme.yellow
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(0.8, 0),
                                            child: Icon(
                                              Icons.collections_bookmark,
                                              size: boxHeight / 1.8,
                                              color: FintnessAppTheme.white,
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
                                                  colors: FintnessAppTheme.grad,
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment(-0.8, 0),
                                            child: Icon(
                                              Icons.library_books,
                                              size: boxHeight / 2,
                                              color: FintnessAppTheme.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: _buildWidgetExample(index),
                                      onDismissed: (direction) {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          _delete(tnum, text,cre, desc,couns);
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          );

                          //return new Column(children: list);
                          break;
                        }
                    }

                    return Column(children: list);
                  }),
            ],
          ));
    } else {
      List<Widget> list = new List<Widget>();
      list.removeRange(0, list.length);

      list = buildThis(list, FintnessAppTheme.midpoint);
      return new Scaffold(
        backgroundColor: FintnessAppTheme.background,
        appBar: DefaultAppBar(
          onCancelSearch: null,
          onSearchQueryChanged: null,
        ),
        body: Stack(
          children: <Widget>[new Column(children: list)],
        ),
      );
    }
  }

  List buildThis(List list, Color color) {
    list.add(
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5 - 46),
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

  Future<void> _delete(int docNo, String name, String creator, String description, int count) async {

    setState(() {
      isloading = true;
    });
    final AuthService auth = AuthProvider.of(context).auth;
    await auth.makeACopy(docNo, name, creator, description, count);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Upload(),
        ),
            (Route<dynamic> route) => false);

  }

  Widget _buildWidgetExample(int index) {
    if (index == 0) {
      return Container(
        width: width,
        height: 50.0,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 3, left: 25.0),
            child: Text("Most Relevant :",
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway')),
          ),
        ),
      );
    }

    String text = names[index - 1].toString();

    String cre = creators[index - 1].toString();

    String desc = description[index - 1].toString();

    String coun = count[index - 1].toString() + " Cards";
    int couns = count[index - 1];
    bool stat = status[index - 1];

    int tnum = tno[index - 1];
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
              startup(tnum, text,cre, desc,couns, true);
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
                    minWidth: double.infinity, minHeight: boxHeight),
                //alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 20),
                          child: Align(
                            alignment: Alignment(-1, 1),
                            child: AutoSizeText(
                              text,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Raleway',
                                  color: FintnessAppTheme.black),
                              maxLines: 1,
                              minFontSize: 20,
                              maxFontSize: 24,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 2, left: 20),
                          child: Align(
                            alignment: Alignment(-1, 1),
                            child: AutoSizeText(
                              cre,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Raleway',
                                  color: FintnessAppTheme.midpoint),
                              maxLines: 1,
                              maxFontSize: 13,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 12, left: 10, bottom: 10),
                          child: Align(
                            alignment: Alignment(-1, 1),
                            child: AutoSizeText(
                              coun,
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
                        Padding(
                          padding:
                              EdgeInsets.only(top: 12, left: 10, bottom: 10),
                          child: Align(
                            alignment: Alignment(-1, 1),
                            child: Icon(
                              stat ? Icons.lock : Icons.public,
                              color: FintnessAppTheme.grey,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20, bottom: 20),
                      child: Align(
                        alignment: Alignment(-1, 1),
                        child: AutoSizeText(
                          desc,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Raleway',
                              color: FintnessAppTheme.black),
                          maxLines: 2,
                          //overflowReplacement: Text("..."),
                          minFontSize: 18,
                          maxFontSize: 18,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  Future<void> startup(int docNo, String name, String creator, String description, int count, bool b) async {
    setState(() {
      isloading = true;
    });
    var x;
    final AuthService auth = AuthProvider.of(context).auth;
    x = await auth.getother(docNo, name, creator, description, count);
    isloading = false;
    print(x);
    if (b == true) {
      Navigator.pushNamed(
        context,
        homeStudy.routeName,
        arguments: ScreenArguments(x, docNo, false, false, true,name,description, creator),
      );
    } else {
      Navigator.pushNamed(
        context,
        review.routeName,
        arguments: ScreenArguments(x, 0, null,null,null,null,null, null),
      );
    }
  }

}
