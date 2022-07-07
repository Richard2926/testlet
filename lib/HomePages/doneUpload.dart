import 'package:flutter/material.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Backend/auth.dart';
import 'dart:async';
import 'package:flip_card/flip_card.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class doneUpload extends StatelessWidget {
  final VoidCallback SignOut;
  final VoidCallback NotUploaded;

  const doneUpload({this.SignOut, this.NotUploaded});

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = AuthProvider.of(context).auth;

      await auth.signOut();
      SignOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    /*return new Scaffold(
      appBar: new AppBar(
        title: new Text('DashBoard',
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway')),
        centerTitle: true,
      ),
      body: Stack(children: <Widget>[
        //Background(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () => _signOut(context),
              //Navigator.pushNamed(context, upload-page),
              icon: new Image.asset('assets/google.png'),
              label: Text("Log me out bruh"),
            ),
          ),
        ),
        /*GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            FlipCard(
              direction: FlipDirection.VERTICAL,
              // default
              front: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),

                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Heed not the rabble'),
                  color: Colors.teal[200],
                ),
              ),
              back: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),

                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Who scream'),
                  color: Colors.teal[400],
                ),
              ),
            ),


            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Sound of screams but the'),
              color: Colors.teal[300],
            ),

            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Revolution is coming...'),
              color: Colors.teal[500],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: const Text('Revolution, they...'),
              color: Colors.teal[600],
            ),
          ],
        )*/
      ]),
      /*floatingActionButton: new FloatingActionButton(
        heroTag: "btn2",
        onPressed: () {
          NotUploaded();
        },
        //onPressed: (){},
        tooltip: 'Add Image',
        child: new Icon(Icons.add),
      ),*/
    );*/
    return new Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
//              title: Text("hello"),
            expandedHeight: 175,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: new Text('Testlets',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway')),
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              background: Container(
                //color: RED,
                constraints: BoxConstraints.expand(height: 100),
                child: Image.asset(
                  'assets/collaboration.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 1000,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
