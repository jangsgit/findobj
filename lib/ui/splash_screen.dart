import 'dart:async';

import 'package:findobj/config/constant.dart';
import 'package:findobj/ui/authentication/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Timer? _timer;
  int _second = 2; // set timer for 3 second and then direct to next page

  void _startTimer() {
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        _second--;
      });
      if (_second == 0) {
        _cancelFlashsaleTimer();
        // for this example we will use pushReplacement because we want to go back to the list
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninPage()));

        // if you use this splash screen on the very first time when you open the page, use below code
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OnBoardingPage()), (Route<dynamic> route) => false);
      }
    });
  }

  void _cancelFlashsaleTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    // set status bar color to transparent and navigation bottom color to black21
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    if(_second != 0){
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _cancelFlashsaleTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Container(
            child: Center(
              child: Image.asset(LOCAL_IMAGES_URL+'/logo.png', width: MediaQuery.of(context).size.width/2),
            ),
          ),
        )
    );
  }
}
