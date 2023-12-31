import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../config/constant.dart';
import '../../config/global_style.dart';
import '../model/itemlist_model.dart';
import 'AppPage02.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class AppPage03Deatil extends StatefulWidget {
  final itemlist_model itemData;
  const AppPage03Deatil({Key? key, required this.itemData}) : super(key: key);

  @override
  State<AppPage03Deatil> createState() => _AppPage03DeatilState();
}

class _AppPage03DeatilState extends State<AppPage03Deatil> {

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
  String _lsBoxPass = "";
  String _lsEndMemo = "";

  bool _lsModify = false;
  bool _lsModify_admin = false;
  bool _lsUpdate = false;
  bool _lsDelete = false;
  String _lsSeq     = "";
  int _llSeq     = 0;


  TextEditingController _etItemmemo = TextEditingController();
  TextEditingController _etSubject = TextEditingController();
  TextEditingController _etInputdate = TextEditingController();
  TextEditingController _etLocation = TextEditingController();
  TextEditingController _etPernm = TextEditingController();
  TextEditingController _etEndmemo = TextEditingController();
  TextEditingController _etBoxpass = TextEditingController();


  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Future<void> initData() async {
    await sessionData();
    setData();
  }
  Future<void> sessionData() async {
    String username = await SessionManager().get("username");
    // 문자열 디코딩
    setState(() {
      _usernm = utf8.decode(username.runes.toList());
    });
  }

  void setData(){
    // _selectedValue = "001";
    // _selectedValue2 = "분실";
    _llSeq= widget.itemData.seq;
    _etItemmemo = TextEditingController(text:widget.itemData.itemmemo);
    _etSubject = TextEditingController(text:widget.itemData.itemsubject);
    _etInputdate = TextEditingController(text:widget.itemData.inputdate);
    _etLocation = TextEditingController(text:widget.itemData.location);
    _etPernm = TextEditingController(text:widget.itemData.pernm);
    _etBoxpass = TextEditingController(text:widget.itemData.boxpass);
    _etEndmemo = TextEditingController(text:widget.itemData.endmemo);


    _selectedValue= widget.itemData.flag;
    _selectedValue2= widget.itemData.flagnm;


  }

  Future update_data() async {
    _custcd = await  SessionManager().get("custcd");
    var uritxt = CLOUD_URL + '/daegun/itemupdate';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    if(!_lsModify) {
      showAlertDialog(context, '등록자만 수정할 수 있습니다.');
      return false;
    }
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
    _lsBoxPass = _etBoxpass.text;
    _lsSeq = _llSeq.toString();

    print('_lsInputdate-->' + _lsInputdate);
    print('_lsSubject-->' + _lsSubject);
    print('_lsItemMemo-->' + _lsItemMemo);
    print('_lsFlag-->' + _lsFlag);
    print('_lsLocation-->' + _lsLocation);
    print('_lsPernm-->' + _lsPernm);
    print('_lsSeq-->' + _lsSeq);

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
        'location': _lsLocation,
        'boxpass': _lsBoxPass,
        'seq': _lsSeq
      },
    );
    if(response.statusCode == 200){
      try{
        // var result =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        var result =  utf8.decode(response.bodyBytes);
        print('result-->' + result);
        if (result == "SUCCESS"){
          _lsUpdate = true;
          return true;
          //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage01()));
        }else{
          _lsUpdate = false;
          return false;
        }
      }catch(e){
        // print(e.toString());
        showAlertDialog(context, e.toString() + " : 관리자에게 문의하세요");
      }
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('업데이트중 오류가났습니다.');
    }
  }


  Future delete_data() async{
    if(!_lsModify) {
      showAlertDialog(context, '등록자만 삭제할 수 있습니다.');
      return false;
    }
    var uritxt = CLOUD_URL + '/daegun/itemdelete';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    _lsSeq = _llSeq.toString();

    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'seq': _lsSeq
      },
    );
    if(response.statusCode == 200){
      try{
        // var result =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        var result =  utf8.decode(response.bodyBytes);
        print('result-->' + result);
        if (result == "SUCCESS"){
          _lsDelete = true;
          return true;
          //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage01()));
        }else{
          _lsDelete = false;
          return false;
        }
      }catch(e){
        // print(e.toString());
        showAlertDialog(context, e.toString() + " : 관리자에게 문의하세요");
      }
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('삭제중 오류가났습니다.');
    }
  }


  Future complete_data() async{
    if(!_lsModify_admin) {
      showAlertDialog(context, '관리자만 처리할 수 있습니다.');
      return false;
    }
    var uritxt = CLOUD_URL + '/daegun/itemcomplete';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    _lsSeq = _llSeq.toString();
    _lsEndMemo =  _etEndmemo.text;

    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'seq': _lsSeq,
        'endmemo': _lsEndMemo
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
      throw Exception('삭제중 오류가났습니다.');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '상세보기',
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
            enabled: _lsModify,
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
          Form(
            child: TextFormField(
              controller: _etPernm,
              autofocus: true,
              enabled: _lsModify,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),

            ),
          ),

          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _etSubject,
              enabled: _lsModify,
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
            child:  _usernm != "관리자" ? Container() : TextFormField(
              controller: _etBoxpass,
              enabled: _lsModify,
              autofocus: true,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '보관함 비밀번호를 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '보관함 비밀번호 *',
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
              enabled: _lsModify,
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
              enabled: _lsModify,
              maxLines: 3,
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
            height: 12,
          ) ,
          SizedBox(
            height: 20,
          ),
          Form(
            child: TextFormField(
              autofocus: true,
              controller: _etEndmemo,
              enabled: _lsModify_admin,
              maxLines: 3,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: '인적사항 또는 완료처리 참고사항을 작성하세요',
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: '완료처리 기타내용 *',
                  labelStyle:
                  TextStyle(fontSize: 23,  fontWeight: FontWeight.bold, color: BLACK_GREY)),
            ),
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
          title: Text('분실물상세내용'),
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
