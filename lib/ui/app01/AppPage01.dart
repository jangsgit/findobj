import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../home/tab_home.dart';
import 'AppPage02.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AppPage01 extends StatefulWidget {

  @override
  _AppPage01State createState() => _AppPage01State();
}
class _AppPage01State extends State<AppPage01> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  List<String> dropdownList = ['분실', '습득'];
  String _selectedValue = "";
  String ? _selectedValue2;
  var _usernm = "";





  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime _selectedDate = DateTime.now(), initialDate = DateTime.now();
  late String now;
  late String now2;
  String _custcd = '';
  String usernm = "";
  String  _lsInputdate = "";
  String _lsSubject  = "";
  String _lsItemMemo = "";
  String _lsFlag     = "";
  String _lsPernm     = "";
  String _lsLocation     = "";

  TextEditingController _etItemmemo = TextEditingController();
  TextEditingController _etSubject = TextEditingController();
  TextEditingController _etInputdate = TextEditingController();
  TextEditingController _etLocation = TextEditingController();



  @override
  void initState() {
    super.initState();
    initData();
    _selectedValue = "001";
    _etInputdate.text = DateTime.now().toString().substring(0,10);
  }

  @override
  ///저장시 setData
  Future<void> initData() async {
    await sessionData();
    setData();
    _selectedValue = "001";
    _selectedValue2 = "분실";
    print("_selectedValue--->" + _selectedValue);
  }
  Future<void> sessionData() async {
    String username = await SessionManager().get("username");
    // 문자열 디코딩
    setState(() {
      _usernm = utf8.decode(username.runes.toList());
    });
  }

  void setData() {
    // 다른 데이터 설정
  }

  Future save_data() async {
    _custcd = await  SessionManager().get("custcd");
    var uritxt = CLOUD_URL + '/daegun/itemsave';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);

    if(_etInputdate.text == "") {
      showAlertDialog(context, '작성일자를 입력하세요');
      return false;
    }
    if(_etSubject.text.isEmpty || _etSubject.text == "") {
      showAlertDialog(context, '제목을 입력하세요');
      return false;
    }
    if(_etItemmemo.text.isEmpty || _etItemmemo.text == "" ) {
      showAlertDialog(context, '내용을 입력하세요');
      return false;
    }
    if(_etLocation.text.isEmpty || _etLocation.text == "" ) {
      showAlertDialog(context, '위치를 입력하세요');
      return false;
    }
    if(_selectedValue.isEmpty || _selectedValue == "" ) {
      showAlertDialog(context, '분류를 선택하세요');
      return false;
    }
    //print("_selectedValue2222--->" + _selectedValue);
    _lsInputdate = _etInputdate.text;
    _lsSubject = _etSubject.text;
    _lsItemMemo = _etItemmemo.text;
    _lsFlag = _selectedValue;
    _lsLocation = _etLocation.text;
    _lsPernm = _usernm ;
    // print('_lsFlag-->' + _lsFlag);

    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'custcd': _custcd,
        'inputdate': _lsInputdate,
        'subject': _lsSubject,
        'itemmemo': _lsItemMemo,
        'flag': _lsFlag,
        'pernm': _lsPernm,
        'location': _lsLocation
      },
    );
    if(response.statusCode == 200){
      try{
        // var result =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        var result =  utf8.decode(response.bodyBytes);
        print('result-->' + result);
        if (result == "SUCCESS"){
          return true;
          //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage01()));
        }else{
          return false;
        }
      }catch(e){
        // print(e.toString());
        showAlertDialog(context, e.toString() + " : 관리자에게 문의하세요");
      }
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context){

    int _selectedIndex = 0;  //bottom in
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '분실물 / 습득물 등록',
          style: GlobalStyle.appBarTitle,
        ),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            color: SOFT_BLUE,
            elevation: 5,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(

                  icon: Icon(Icons.keyboard_arrow_down),
                  dropdownColor: SOFT_BLUE,
                  iconEnabledColor: Colors.white,
                  /*hint: Text("합격",  style: TextStyle(color: Colors.white)),*/
                  items: dropdownList.map((item) {
                    return DropdownMenuItem<String>(
                      child: Text(item, style: TextStyle(color: Colors.white)),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (String? value) =>
                      setState(() {
                        if(value.toString() == "분실"){
                          _selectedValue = "001";
                        }

                        if(value.toString() == "습득"){
                          _selectedValue = "002";
                        }
                        this._selectedValue2 = value;
                        print(_selectedValue);
                      }),
                  value: _selectedValue2,

                ),
              ),
            ),

          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _etInputdate,
            readOnly: true,
            onTap: () {
              _selectDateWithMinMaxDate(context);
            },
            maxLines: 1,
            cursorColor: Colors.grey[600],
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            decoration: InputDecoration(
                isDense: true,
                suffixIcon: Icon(Icons.date_range, color: Colors.pinkAccent),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                labelText: '작성일자 ',
                labelStyle:
                TextStyle(color: BLACK_GREY)),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              _usernm == null ? Container() :
              Row(
                children: [
                  Text( _usernm,
                    style: TextStyle(color: SOFT_BLUE ,fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  Text( '님이 작성 중입니다.',
                    style: TextStyle(color: BLACK_GREY ,fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _etSubject,
              validator: (value){
                if(value != null  && value.isEmpty){
                  return '제목을 입력하세요';

                }
                return null;
              },
              autofocus: true,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '제목을 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '제목 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),

            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            child: TextFormField(
              autofocus: true,
              controller: _etLocation,
              validator: (value){
                if(value != null  && value.isEmpty){
                  return '위치를 입력하세요';
                }
                return null;
              },
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '위치를 입력하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '위치 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey2,
            child: TextFormField(
              autofocus: true,
              controller: _etItemmemo,
              validator: (value){
                if(value != null  && value.isEmpty){
                  return '내용을 입력하세요';

                }
                return null;
              },
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '내용을 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '내용 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => SOFT_BLUE,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      )
                  ),
                ),
                onPressed: ()  async {
                  if(_formKey.currentState!.validate() && _formKey2.currentState!.validate()){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        content: Text('등록하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                Navigator.pop(context);
                                var result = await save_data();
                                if (result){
                                  Get.off(AppPage02());
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage02()));
                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppPage02()));
                                }else{
                                  Fluttertoast.showToast(msg: "등록오류");
                                }
                              }
                            },
                          ),
                          TextButton(onPressed: (){
                            Navigator.pop(context, "취소");
                          }, child: Text('Cancael')),

                        ],
                      );
                    });
                  }
                  /*_reusableWidget.startLoading(context, '등록 되었습니다.', 1);*/
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    '등록하기',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
          ),

        ],
      ),


      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) { // 1번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TabHomePage()));          }
          if (index == 1) { // 2번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppPage01()));          }
          if (index == 2) { // 3번째 아이템을 눌렀을 때
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppPage02()));            }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '분실물등록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '분실물조회',
          ),
        ],
      ),



    );
  }





  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(initialDate.year, initialDate.month - 3, initialDate.day);
    var lastDate = DateTime(initialDate.year, initialDate.month, initialDate.day + 60);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.pinkAccent,
            colorScheme: ColorScheme.light(primary: Colors.pinkAccent, secondary: Colors.pinkAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;

        _etInputdate = TextEditingController(
            text: _selectedDate.toLocal().toString().split(' ')[0]);
      });
    }
  }




  //저장시 confirm
  void showAlertDialog(BuildContext context, String as_msg) async {

    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('분실물등록'),
          content: Text(as_msg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }


}