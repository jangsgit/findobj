import 'dart:convert';
import 'package:findobj/ui/model/itemlist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';
import '../../../config/global_style.dart';
import '../home/tab_home.dart';
import 'AppPage01.dart';
import 'AppPage02.dart';
import 'appPage03Detail.dart';


class AppPage03 extends StatefulWidget {
  @override
  _AppPage03State createState() => _AppPage03State();
}

class _AppPage03State extends State<AppPage03> {

  TextEditingController _etSearch2 = TextEditingController();
  List<itemlist_model> itemDataList = itemData;
  String _subsubsub = "";
  var _usernm = "";


  List<DataRow> _dataGrid(itemlist_model itemData){
    return [
      DataRow(
        cells: <DataCell>[
          DataCell(
            ConstrainedBox(constraints: BoxConstraints(maxWidth: 75),
                child: Text('${itemData.seq}',
                    overflow: TextOverflow.ellipsis)),
          ),
          DataCell(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ConstrainedBox(constraints: BoxConstraints(maxWidth: 55, minWidth: 50),
                    child: Text('${itemData.itemsubject}',
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          DataCell(
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        this._subsubsub = '${itemData.itemsubject}';
                      });

                      //Navigator.push(context, MaterialPageRoute(builder: (context) => AppPage03Detail(itemData: itemData)));

                    },
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(minWidth: 180 , maxWidth: 180),
                      child: Text('${itemData.itemsubject}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: SOFT_BLUE, fontSize: 12, fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                  ),
                ],
              )
          ),
          DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 50), //SET max width
                      child: Text('${itemData.pernm}',
                          overflow: TextOverflow.ellipsis)),
                ],
              )
          ),
          DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // margin: EdgeInsets.only(right: 5),
                  ),
                  Text('${itemData.inputdate}')
                ],
              )
          ),

        ],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      itemlist_getdata();
    });
    initData();

  }

  @override
  Future<void> initData() async {
    await sessionData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> sessionData() async {
    String username = await SessionManager().get("username");
    // 문자열 디코딩
    setState(() {
      _usernm = utf8.decode(username.runes.toList());
    });
    print(_usernm);
  }

  Future itemlist_getdata() async {
    String _custcd = await SessionManager().get("custcd");
    String ls_search = "";
    ls_search =  _etSearch2.text;

    if(ls_search == null || ls_search.length == 0){
      ls_search = "%";
    }
    var uritxt = CLOUD_URL + '/daegun/itemlistend';
    var encoded = Uri.encodeFull(uritxt);
    Uri uri = Uri.parse(encoded);
    // try {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
      },
      body: <String, String>{
        'custcd': _custcd,
        'searchtxt': ls_search,
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> alllist = [];
      alllist = jsonDecode(utf8.decode(response.bodyBytes));
      itemData.clear();
      //print(alllist);

      for (int i = 0; i < alllist.length; i++) {
        itemlist_model Object = itemlist_model(
            seq: alllist[i]['seq'],
            custcd: alllist[i]['custcd'],
            flag: alllist[i]['flag'],
            inputdate: alllist[i]['inputdate'],
            itemsubject: alllist[i]['itemsubject'],
            pernm: alllist[i]['pernm'],
            itemmemo: alllist[i]['itemmemo'],
            location: alllist[i]['location'],
            boxpass: alllist[i]['boxpass'],
            endmemo: alllist[i]['endmemo'],
            enddate: alllist[i]['enddate'],
            flagnm: alllist[i]['flagnm']
        );
        setState(() {
          itemData.add(Object);
        });
      }
      return ;

    } else {
      // Fluttertoast.showToast(msg: e.toString());
      throw Exception('불러오는데 실패했습니다');

    }
    // } catch (e) {
    //   //만약 응답이 ok가 아니면 에러를 던집니다.
    //   Fluttertoast.showToast(msg: '에러입니다.');
    //   return <MhmanualList_model>[];
    // }
  }



  @override
  Widget build(BuildContext context){
    int _selectedIndex = 0;  //bottom index
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        elevation: GlobalStyle.appBarElevation,
        title: Text(
          '분실/습득 완료 리스트',
          style: GlobalStyle.appBarTitle,
        ),
        actions: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(onPressed: (){

                  setState(() {

                    itemlist_getdata();

                  });
                  /*searchBook(_etSearch.text);*/
                  /*searchBook2(_etSearch2.text);*/
                }, child: Text('검색하기')),
              ),

            ],
          )
        ],
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        // bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _etSearch2,
            textAlignVertical: TextAlignVertical.bottom,
            maxLines: 1,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),

            decoration: InputDecoration(
              fillColor: Colors.grey[100],
              filled: true,
              hintText: '게시글 제목검색',
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              suffixIcon: (_etSearch2.text == '')
                  ? null
                  : GestureDetector(
                  onTap: () {
                    setState(() {
                      _etSearch2 = TextEditingController(text: '');
                    });
                  },
                  child: Icon(Icons.close, color: Colors.grey[500])),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
          /*Text('점검조치사항 자료실', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
          )),*/
          Container(
            padding:EdgeInsets.only(top:16, bottom: 2, left: 10),
            child: Text('찾은 건수 ${itemData.length} 건',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: CHARCOAL
                )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 15),
              height: 0.638 * MediaQuery.of(context).size.height,
              width: 600,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  DataTable(
                      showCheckboxColumn: false,
                      columnSpacing: 25, dataRowHeight: 40,
                      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      headingRowColor:
                      MaterialStateColor.resolveWith((states) => SOFT_BLUE),

                      columns: <DataColumn>[
                        DataColumn(label: Text('No.')),
                        DataColumn(label: Text('분류')),
                        DataColumn(label: Text('위치')),
                        DataColumn(label: Text('제목')),
                        DataColumn(label: Text('작성자')),
                        DataColumn(label: Text('완료일자')),
                      ],
                      rows: List<DataRow>.generate(itemData.length,(index)
                      {
                        final itemlist_model item = itemData[index];
                        return
                          DataRow(
                              onSelectChanged: (value){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AppPage03Deatil(itemData: item)));
                              },
                              color: MaterialStateColor.resolveWith((states){
                                if (index % 2 == 0){
                                  return Color(0xB8E5E5E5);
                                }else{
                                  return Color(0x86FFFFFF);
                                }
                              }),
                              cells: [
                                DataCell(
                                    Container(
                                        child: Text('${index+1}',
                                        ))),
                                DataCell(
                                    Container(
                                        child: Text(item.flagnm
                                        ))),
                                DataCell(Container(
                                  child: Text(item.location,
                                      overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(Container(
                                  child: Text(item.itemsubject,
                                      overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(Text(item.pernm,
                                    overflow: TextOverflow.ellipsis)),
                                DataCell(
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text('${item.enddate}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: SOFT_BLUE,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ]

                          );
                      }
                      )
                  ),],
              ),
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