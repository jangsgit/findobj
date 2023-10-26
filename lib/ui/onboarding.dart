import 'package:findobj/ui/authentication/signin.dart';
import 'package:flutter/material.dart';
import 'package:findobj/config/constant.dart';
import 'package:findobj/library/flutter_overboard/overboard.dart';
import 'package:findobj/library/flutter_overboard/page_model.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {

  // create each page of onBoard here
  final _pageList = [
    PageModel(
        color: Colors.white,
        imageAssetPath: LOCAL_IMAGES_URL+'/onboarding/search_product.gif',
        title: 'Choose Product',
        body: 'Search and browse the product you want to buy at iJShop',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageFromUrl: GLOBAL_URL+'/apps/ecommerce/onboarding/cart.png',
        title: 'Add to Cart and Pay',
        body: 'Add the product to shopping cart, choose delivery and then pay with your preferences payment',
        doAnimateImage: true),
    PageModel(
        color: Colors.white,
        imageFromUrl: GLOBAL_URL+'/apps/ecommerce/onboarding/delivery.png',
        title: 'Delivery',
        body: 'Wait until the product that has been purchased comes to the house',
        doAnimateImage: true),
  ];

  @override
  void initState() {
    super.initState();
  }

  // this function used if user click finish, you won't see this page again until you clear your data of this apps in your phone setting
  /*void _finishOnBoarding() async {
    final SharedPreferences _pref = await SharedPreferences.getInstance();
    await _pref.setBool('onBoarding', false);
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OverBoard(
          pages: _pageList,
          showBullets: false,
          finishCallback: () {
            //_finishOnBoarding();

            // after you click finish, direct to signin page
            // Adjust with your need using push replacement or push remove until
            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SigninPage()), (Route<dynamic> route) => false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninPage()));
          },
        )
    );
  }
}
