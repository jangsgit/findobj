import 'dart:convert';

import 'package:findobj/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:findobj/config/constant.dart';
import 'package:findobj/config/global_style.dart';
import 'package:findobj/ui/authentication/signin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';


import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  final bool fromList;

  const SignupPage({Key? key, this.fromList = false}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {


  String _lsEtUserid = '';
  String _lsEtEmail = '';
  String _lsEtName = '';
  String _lsEtPass = '';

  TextEditingController _etEmail = TextEditingController();
  TextEditingController _etName = TextEditingController();
  TextEditingController _etUserid = TextEditingController();
  TextEditingController _etPass = TextEditingController();
  TextEditingController _etWarning = TextEditingController();


  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }




  Future user_insert() async {
    String _custcd = 'DGH'; //await  SessionManager().get("custcd");

    var uritxt = CLOUD_URL + '/daegun/usersave';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
     _lsEtUserid = _etUserid.text;
     _lsEtEmail = _etEmail.text;
     _lsEtName = _etName.text;
     _lsEtPass = _etPass.text;
    //print('_lsEtUserid-->' + _lsEtUserid);
    final response = await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept' : 'application/json'
      },
      body: <String, String> {
        'custcd': _custcd,
        'userid': _lsEtUserid,
        'email': _lsEtEmail,
        'name': _lsEtName,
        'pass': _lsEtPass
      },
    );
    if(response.statusCode == 200){
      try{
        // var result =  jsonDecode(utf8.decode(response.bodyBytes))  ;
        var result =  utf8.decode(response.bodyBytes);
        //print('result-->' + result);
        if (result == "SUCCESS"){
           return true;
          //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage01()));
        }else if (result == "DUP"){
          return false;
        }else{
          return false;
        }
        return ;
      }catch(e){
        Fluttertoast.showToast(msg: "등록 오류");
        // print(e.toString()); 
      }
    }else{
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: (){
            FocusScope.of(context).unfocus();
            return Future.value(true);
          },
          child: ListView(
            padding: EdgeInsets.fromLTRB(30, 120, 30, 30),
            children: <Widget>[
              Center(
                  child: Image.asset(LOCAL_IMAGES_URL+'/signup.png',
                      height: 200)),
              SizedBox(
                height: 80,
              ),
              Text('Sign Up', style: GlobalStyle.authTitle),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _etUserid,
                style: TextStyle(color: CHARCOAL),
                onChanged: (textValue) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: 'User ID',
                  labelStyle: TextStyle(color: BLACK_GREY),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _etEmail,
                style: TextStyle(color: CHARCOAL),
                onChanged: (textValue) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: BLACK_GREY),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _etName,
                style: TextStyle(color: CHARCOAL),
                onChanged: (textValue) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: 'Name',
                  labelStyle: TextStyle(color: BLACK_GREY),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: _obscureText,
                controller: _etPass,
                style: TextStyle(color: CHARCOAL),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: PRIMARY_COLOR, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: BLACK_GREY),
                  suffixIcon: IconButton(
                      icon: Icon(_iconVisible, color: Colors.grey[400], size: 20),
                      onPressed: () {
                        _toggleObscureText();
                      }),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) => PRIMARY_COLOR,
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          )
                      ),
                    ),
                    onPressed: () {
                      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
                      // if(!widget.fromList){
                      //   Navigator.pop(context);
                      // }

                      USERINFO_Save(context);
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),

                    )
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SigninPage()));
                    FocusScope.of(context).unfocus();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GlobalStyle.iconBack,
                      Text(
                        ' Back to login',
                        style: GlobalStyle.back,
                      ),
                    ],
                  ),

                ),
              ),
            ],
          ),
        ));
  }

  void USERINFO_Save(BuildContext context) async {
    var result = await user_insert();
    if(result){
      print("저장성공!");
      Fluttertoast.showToast(msg: "등록되었습니다.");
      if(!widget.fromList){
        Navigator.pop(context);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => SigninPage()));
    }else{
      print("저장error!");
      //Fluttertoast.showToast(msg: "아이디 중복");
      showAlertDialog(context, "같은 아이디가 있습니다.");
      return ;
    }

  }



  void showAlertDialog(BuildContext context, String as_msg) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입'),
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
