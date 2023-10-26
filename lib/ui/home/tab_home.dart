import 'dart:convert';

import 'package:findobj/ui/home.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:findobj/config/constant.dart';
import 'package:findobj/model/feature/banner_slider_model.dart';
import 'package:findobj/model/feature/category_model.dart';
import 'package:findobj/ui/reusable/cache_image_network.dart';
import 'package:findobj/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class TabHomePage extends StatefulWidget {
  @override
  _Home1PageState createState() => _Home1PageState();
}

class _Home1PageState extends State<TabHomePage> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  Color _color1 = Color(0xFF005288);
  Color _color2 = Color(0xFF37474f);
  var _usernm = "";
  int _currentImageSlider = 0;

  List<BannerSliderModel> _bannerData = [];
  List<CategoryModel> _categoryData = [];

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 3),
        () => 'Data Loaded',
  );

  @override
  void initState()  {
    setData();
    //GLOBAL_URL+'/home_banner/1.jpg'));  LOCAL_IMAGES_URL+'/elvimg/1.jpg'
    _bannerData.add(BannerSliderModel(id: 1, image: HYUNDAI_URL + '/product_gallery/THE EL_main_Web(0).jpg'));
    _bannerData.add(BannerSliderModel(id: 2, image: HYUNDAI_URL + '/product_gallery/THE EL_4(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 3, image: HYUNDAI_URL + '/product_gallery/THE EL_3(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 4, image: HYUNDAI_URL + '/product_gallery/THE EL_2(1).jpg'));
    _bannerData.add(BannerSliderModel(id: 5, image: HYUNDAI_URL + '/product_characteristic/특징_02(0).jpg'));

    _categoryData.add(CategoryModel(id: 1, name: '고 장 접 수', image: GLOBAL_URL+'/menu/store.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 2, name: '고 장 처 리', image: GLOBAL_URL+'/menu/products.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 3, name: '점 검 계 획', image: GLOBAL_URL+'/menu/buy_online.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 4, name: '점 검 조 치', image: GLOBAL_URL+'/menu/apply_credit.png', color:0xD3D3D3));

    _categoryData.add(CategoryModel(id: 5, name: '도 면 자 료', image: GLOBAL_URL+'/menu/credit_application_status.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 6, name: '부 품 자 료', image: GLOBAL_URL+'/menu/credit_payment.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 7, name: '기 타 자 료', image: GLOBAL_URL+'/menu/commission.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 8, name: '현장정보\n승강기번호\n비상통화/조회', image: GLOBAL_URL+'/menu/contact_us.png', color:0xffffff));

    _categoryData.add(CategoryModel(id: 9, name: '수 리\n노 하 우', image: GLOBAL_URL+'/menu/store.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 10, name: '부 품\n가 이 드', image: GLOBAL_URL+'/menu/products.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 11, name: '수 리\nQ  &  A', image: GLOBAL_URL+'/menu/buy_online.png', color:0xD3D3D3));
    _categoryData.add(CategoryModel(id: 12, name: '직 원 정 보', image: GLOBAL_URL+'/menu/apply_credit.png', color:0xD3D3D3));

    _categoryData.add(CategoryModel(id: 13, name: '고 장 이 력', image: GLOBAL_URL+'/menu/credit_application_status.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 14, name: '고 장 통 계', image: GLOBAL_URL+'/menu/credit_payment.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 15, name: '작 업 일 보', image: GLOBAL_URL+'/menu/commission.png', color:0xffffff));
    _categoryData.add(CategoryModel(id: 16, name: '공 지 사 항', image: GLOBAL_URL+'/menu/point.png', color:0xffffff));



    super.initState();

  }


  Future<void> setData() async {
    String username = await  SessionManager().get("username");
    // 문자열 디코딩
    _usernm = utf8.decode(username.runes.toList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Image.asset(LOCAL_IMAGES_URL+'/logo.png', height: 24, color: Colors.white),
            backgroundColor: _color1,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.help_outline),
                  onPressed: () async {
                    const url = 'http://emmsg.co.kr:8080/actas/about_privacy';
                    if (await canLaunch(url)) {
                    await launch(url);
                    } else {
                    throw 'Could not launch $url';
                    }
                  })
            ]),
        body: ListView(
          children: [
            _buildTop(),
            _buildHomeBanner(),
            _createMenu(),
          ],
        ),
bottomNavigationBar: SizedBox.shrink(),
    );
  }

  Widget _buildTop(){
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: Hero(
                        tag: 'profilePicture',
                        child: ClipOval(
                          child: buildCacheNetworkImage(url: GLOBAL_URL+'/user/avatar.png', width: 30),
                        ),
                      ),
                  ),
                  start(),
                  Text(  _usernm ,
                    style: TextStyle(
                        color: SOFT_BLUE,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                    Text(' 님 반갑습니다.',
                      style: TextStyle(
                          color: _color2,
                          fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                ],
            ),
          ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 17,),
            child: Container(
              width: 1,
              height: 40,
              color: Colors.grey[300],
            ),
          ),
          Flexible(
            flex: 0,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                },
                child: Text(
                    'Log Out',
                    style: TextStyle(color: _color2, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
                 ],
      ),
    );
  }

  Widget _buildHomeBanner(){
    return Stack(
      children: [
        CarouselSlider(
          items: _bannerData.map((item) => Container(
            child: GestureDetector(
                onTap: (){
                  Fluttertoast.showToast(msg: 'Click banner '+item.id.toString(), toastLength: Toast.LENGTH_SHORT);
                },
                child: buildCacheNetworkImage(width: 0, height: 0, url: item.image)
            ),
          )).toList(),
          options: CarouselOptions(
              aspectRatio: 2,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 6),
              autoPlayAnimationDuration: Duration(milliseconds: 300),
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageSlider = index;
                });
              }
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _bannerData.map((item) {
              int index = _bannerData.indexOf(item);
              return AnimatedContainer(
                duration: Duration(milliseconds: 150),
                width: _currentImageSlider == index?10:5,
                height: _currentImageSlider == index?10:5,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _createMenu(){
    final double HSize = MediaQuery.of(context).size.height/1.5;
    final double WSize = MediaQuery.of(context).size.width/1;
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      ///cell ratio
      childAspectRatio: WSize / HSize,
      shrinkWrap: true,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 4,
      children: List.generate(_categoryData.length, (index) {
        return OverflowBox(
          maxHeight: double.infinity,
          child: GestureDetector(
              onTap: () {
                // Fluttertoast.showToast(msg: 'Click '+_categoryData[index].name.replaceAll('\n', ' '), toastLength: Toast.LENGTH_SHORT);
                String ls_name = _categoryData[index].name.replaceAll('\n', ' ');
                switch (ls_name){
                  case '고 장 접 수' :
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager16()));
                    break;
                  case '고 장 처 리' :
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage02()));
                    break;
                  case '점 검 계 획' :
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager15()));
                    break;
                  case '점 검 조 치' :
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AppPager13()));
                    break;
                  default:
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[100]!, width: 0.5),
                    color: Colors.white),  //Colors.white
                    padding: EdgeInsets.all(8),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCacheNetworkImage(width: 30, height: 30, url: _categoryData[index].image, plColor:  Colors.transparent),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Text(
                              _categoryData[index].name,
                              style: TextStyle(
                                color: _color1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ])),
              )
          ),
        );
      }),
    );
  }

  Widget start(){
   return Padding(
     padding: const EdgeInsets.all(2.0),
     child: DefaultTextStyle(
        style: Theme.of(context).textTheme.displayMedium!,
        textAlign: TextAlign.center,
        child: FutureBuilder<String>(
          future: _calculation, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> check;
            if (snapshot.hasData) {
              check = <Widget>[
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 20,
                ),
              ];
            } else if (snapshot.hasError) {
              check = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ];
            } else {
              check = const <Widget>[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: check,
              ),
            );
          },
        ),
      ),
   );
  }


}
