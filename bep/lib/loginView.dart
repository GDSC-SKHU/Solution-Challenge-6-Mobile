import 'package:bep/Api/Response/googleLoginResponse.dart';
import 'package:bep/Api/loginController.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MainView/mainView.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_platform.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginPlatform _loginPlatform = LoginPlatform.none;
  GoogleSignInAccount? googleUser = null;
  LoginController loginController = LoginController();
  googleLoginResponse? response;
  bool isLoading = false;

  void signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    try {
      googleUser = await GoogleSignIn().signIn();
      response = await loginController.googleLogin(googleUser!);
      prefs.setString('accessToken', response!.token!);
      prefs.setInt('userPoint', response!.userPoint);
      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

// logout
  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut();
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loginPlatform != LoginPlatform.none
            ? mainView(
                googleUser: googleUser!,
                response: response!,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                      "BeP",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.asset(
                    'assets/images/global.gif',
                    width: 240,
                    height: 240,
                    fit: BoxFit.fill,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 14, 0, 36),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Let's make a better\nplanet together",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  LoginButton(isLoading, signInWithGoogle),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                      child: GestureDetector(
                        onTap: () {
                          Uri uri = Uri.parse('https://youtu.be/eIh8eERBSR4');
                          launchUrl(uri);
                        },
                        child: Text(
                          'How to use BeP',
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}

Widget LoginButton(bool isLoading, void Function() signInWithGoogle) {
  return ElevatedButton(
    onPressed: isLoading
        ? null
        : () async {
            try {
              signInWithGoogle();
            } catch (e) {
              print("error $e");
            }
          },
    style: ElevatedButton.styleFrom(
      shadowColor: Color.fromRGBO(255, 255, 255, 0),
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey),
      ),
    ),
    child: Container(
      width: 300,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
            child: Image.asset(
              "assets/images/google-logo.png",
              width: 35,
              height: 35,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(38, 0, 16, 0),
            child: Text(
              isLoading ? "Loading..." : "Sign in with Google",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF777777),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
