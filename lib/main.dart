import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/Uploading/ImageSource.dart';
import 'package:testlet/Uploading/root_page.dart';
import 'package:testlet/HomePages/doneUpload.dart';
import 'package:testlet/Studying/study.dart';
import 'package:testlet/Uploading/create.dart';
import 'package:testlet/Studying/review.dart';
import 'package:testlet/Studying/HomeStudy.dart';
import 'package:testlet/HomePages/homeScreen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {

    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Testlet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          //"upload-page": (context) => doneUpload(),
          //"login-page": (context) => Login(),
          'homescreen': (BuildContext context) => homeScreen(),
          //'pickImage': (BuildContext context) => pickImage(),
          study.routeName: (context) => study(),
          review.routeName: (context) => review(),
          homeStudy.routeName: (context) => homeStudy(),
          create.routeName: (context) => create(),
          //'study': (BuildContext context) => new study(),
        },
        home: RootPage(),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
