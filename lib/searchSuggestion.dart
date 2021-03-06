import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydemo/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'userClass.dart';

class searchSuggestion extends StatefulWidget {
  String query;
  List history;
  final Function popResults;
  final Function popSuggestion;
  final Function setSearchKeyword;

  searchSuggestion(this.query, this.popResults, this.setSearchKeyword,
      this.history, this.popSuggestion);

  @override
  _searchSuggestionState createState() => _searchSuggestionState();
}

class _searchSuggestionState extends State<searchSuggestion> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var response;
  var saveHistory;

  getDataFuture() async {
    print('传入单号:${widget.query}');
    User _user = await User().getUser();

    response = await Server().searchSuggestion(widget.query, _user.realName);
    return response;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveHistory = widget.history;
    print('searchSuggestion--initState');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print('searchSuggestion--didChangeDependencies');
  }

  @override
  void didUpdateWidget(searchSuggestion oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('searchSuggestion--didUpdateWidget');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('searchSuggestion--deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('searchSuggestion--dispose');
  }

//展示历史记录
  List<Widget> showHistory(BuildContext context, List historyList) {
    List<Widget> history = List();
    if (historyList != null) {
      historyList.reversed;
      for (int i = 0; i < historyList.length; i++) {
        history.add(InkWell(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                '${historyList[i]}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        ScreenUtil().setSp(35, allowFontScalingSelf: true)),
              ),
            ),
          ),
          onTap: () {
            //显示结果页面
            widget.popResults(context);
            //更改query
            widget.setSearchKeyword(historyList[i]);
            putHistory(historyList[i]);
            //todo 跳转到订单
          },
        ));
      }
    }
    return history;
  }

  //清除历史记录
  clearHistory() async {
    final SharedPreferences preferences = await _prefs;
    await preferences.setStringList('historyList', null);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement buildSuggestions
    return widget.query.isEmpty
        ? Padding(
            padding: EdgeInsets.fromLTRB(
              setWidth(20),
              setWidth(10),
              setWidth(20),
              setWidth(0),
            ),
            child: saveHistory == null
                ? Center(
                    child: Text(
                      '无历史记录',
                      style: TextStyle(
                          fontSize: ScreenUtil()
                              .setSp(50, allowFontScalingSelf: true)),
                    ),
                  )
                : Column(
                    children: [
                      Wrap(
                        children: showHistory(context, widget.history),
                      ),
                      SizedBox(
                        height: setHeight(50),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                saveHistory = null;
                              });
                              clearHistory();
                              widget.popSuggestion(context);
                            },
                            child: Text(
                              '清除历史记录',
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(40, allowFontScalingSelf: true)),
                            ),
                          )
                        ],
                      )
                    ],
                  ))
        : FutureBuilder(
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  print('done');
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    print('hasData-- ${snapshot.data}');
                    return suggesBuilder(snapshot.data, widget.query,
                        widget.setSearchKeyword, widget.popResults);
                  }
                  break;
                case ConnectionState.none:
                  print('none');
                  break;
                case ConnectionState.waiting:
                  print('waiting');
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: setHeight(10),
                          ),
                          CircularProgressIndicator(),
                          SizedBox(
                            height: setHeight(30),
                          ),
                          Text('正在加载...')
                        ],
                      ),
                    ),
                  );
                  break;
                case ConnectionState.active:
                  print('active');
                  break;
              }
            },
            future: getDataFuture(),
          );
  }
}

//富文本样式
TextSpan fontBold(String title, String query) {
  query = query.trim();
  int index = title.indexOf(query);
  if (index == -1 || query.length > title.length) {
    return TextSpan(
      text: title,
      style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true)),
      children: null,
    );
  } else {
    // 构建富文本，对输入的字符加粗显示
    String before = title.substring(0, index);
    String hit = title.substring(index, index + query.length);
    String after = title.substring(index + query.length);
    return TextSpan(
      text: '',
      style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true)),
      //高亮，加粗设置在children
      children: <TextSpan>[
        TextSpan(text: before),
        TextSpan(
            text: hit,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: true),
                fontWeight: FontWeight.bold)),
        TextSpan(text: after),
      ],
    );
  }
}

//futureBuild有数据后加载suggesBuilder
class suggesBuilder extends StatefulWidget {
  final data;
  String query;
  final Function popResults;
  final Function setSearchKeyword;

  suggesBuilder(this.data, this.query, this.setSearchKeyword, this.popResults);

  @override
  _suggesBuilderState createState() => _suggesBuilderState();
}

class _suggesBuilderState extends State<suggesBuilder> {
  @override
  Widget build(BuildContext context) {
    print('suggestion--${widget.data['result']}');
    return widget.data['result'].length == 0
        ? Center(
            child: Text(
              '无此送货单',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: true)),
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: RichText(
                    text: fontBold(widget.data['result'][index], widget.query)),
                onTap: () {
                  putHistory(widget.data['result'][index]);
                  widget.popResults(context);
                  widget.setSearchKeyword(widget.data['result'][index]);
                },
              );
            },
            itemCount: widget.data['result'].length,
          );
  }
}
