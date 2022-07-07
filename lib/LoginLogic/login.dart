import 'package:flutter/material.dart';
import 'package:testlet/Backend/auth.dart';
import 'package:testlet/ThemeRelated/background.dart';
import 'dart:async';
import 'package:testlet/Backend/auth_provider.dart';
import 'package:testlet/ThemeRelated/fintnessAppTheme.dart';

class Login extends StatefulWidget {
  const Login({this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
}

enum FormMode { LOGIN, SIGNUP }

class _LoginPageState extends State<Login> {
  Future<void> _loginUser(BuildContext context) async {
    try {
      final AuthService auth = AuthProvider.of(context).auth;

      //final AuthService auth = new AuthService();
      String bruh = await auth.googleSignIn();
      if (bruh != null) {
        widget.onSignedIn();
      }
    } catch (e) {
      print(e);
    }
  }

  final _formKey = new GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      final AuthService auth = AuthProvider.of(context).auth;
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await auth.signIn(_email, _password);
          widget.onSignedIn();
          print('Signed in: $userId');
        } else {
          userId = await auth.signUp(_email, _password);
          widget.onSignedIn();
          //auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {}
      } catch (e) {
        //print('Error: $e');
        setState(() {
          _isLoading = false;

          _errorMessage = e.details;

          _errorMessage = e.message;
          //_errorMessage =
          //"Unauthorized Credentials, New Accounts may take a while, just spam the login for a second or two";
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Background(),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showBody(),
                _showCircularProgress(),
                /* Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FloatingActionButton.extended(
                    onPressed: () => _loginUser(context),
                    icon: new Image.asset("assets/google.png"),
                    label: Text("Login With Google"),
                  ),
                ),
              ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    _isLoading = false;
    return SingleChildScrollView(
      //children: <Widget>[
      child: Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                _showLogo(),
                _showEmailInput(),
                _showPasswordInput(),
                _showPrimaryButton(),
                _showGoogleLogin(),
                _showSecondaryButton(),
                Center(child: _showErrorMessage()),
              ],
            ),
          )),
      //],
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text(
          _errorMessage,
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
      return new Container(
        height: 0.0,
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          //child: Image.asset('assets/flutter-icon.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Raleway'))
          : new Text('Have an account? Sign in',
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Raleway')),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: FintnessAppTheme.cyan,
            child: _formMode == FormMode.LOGIN
                ? new Text('Login',
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w300,
                    ))
                : new Text('Create account',
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w300,
                    )),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _showGoogleLogin() {
    if (_formMode == FormMode.LOGIN) {
      return new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: SizedBox(
            height: 40.0,
            child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.red,
              child: _formMode == FormMode.LOGIN
                  ? new Text('Proceed with Google',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w300,
                      ))
                  : null,
              onPressed: () => _loginUser(context),
            ),
          ));
    } else {
      return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      );
    }
  }
}
