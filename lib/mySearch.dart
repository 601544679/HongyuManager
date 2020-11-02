import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mydemo/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'searchSuggestion.dart';
import 'constant.dart';
import 'searchResultView.dart';
import 'package:mydemo/myEventBus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class searchbar extends SearchDelegate<String> {
  List result;
  List history;
  var historyList;
  StreamSubscription _searchSubscription;

  searchbar(this.result, this.history);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<String>> getHistory() async {
    final SharedPreferences preferences = await _prefs;
    List<String> history = preferences.getStringList('historyList');
    return history;
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => '请输入送货单号';

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return ThemeData(
      primaryColor: Colors.indigo[colorNum],
    );
  }

  @override
  //右侧图标
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      MaterialButton(
        onPressed: () async {
          if (query.trim().isEmpty) {
            Fluttertoast.showToast(
                msg: '请输入送货单号', toastLength: Toast.LENGTH_SHORT);
          } else {
            showResults(context);
            putHistory(query);
          }
        },
        child: Text(
          '搜索',
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: true)),
        ),
      ),
      IconButton(
          icon: Icon(
            Icons.clear,
            size: ScreenUtil().setHeight(40),
          ),
          onPressed: () async {
            history = await getHistory().then((value) {
              return value;
            });
            showSuggestions(context);
            //print('ddd$historyList');
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  // 搜索结果展示,回调
  void popResults(BuildContext context) {
    showResults(context);
  }

  // 推荐词展示,回调
  void popSuggestion(BuildContext context) {
    showSuggestions(context);
    print('我被毁掉了');
  }

  // 设置query,回调
  Future<void> setSearchKeyword(String searchKeyword) async {
    query = searchKeyword;
    print('回调query--$query');
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    _searchSubscription.cancel();
    return resultView(query.trim());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _searchSubscription = eventBus.on<SearchEvent>().listen((event) {
      print('SearchEvent $event');
      this.popResults(context);
      this.popSuggestion(context);
      this.setSearchKeyword(event.keywords);
    });
    // TODO: implement buildSuggestions

    return searchSuggestion(query, this.popResults, this.setSearchKeyword,
        history, this.popSuggestion);
  }
}
