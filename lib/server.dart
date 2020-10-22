import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:leancloud_storage/leancloud.dart';

import 'login.dart';
import 'userClass.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';

class Server {
  static GlobalKey<NavigatorState> navigatorState;

  final String _baseUrl = 'https://24pjdwah.lc-cn-n1-shared.com';
  final String _appID = '24PJDWahD7Pww2cDice6F6Er-gzGzoHsz';
  final String _appKey = 'mrcuLNzhXH6uJ3gTtGi0Ttg7';

  final String _signUpUrl = '/1.1/usersByMobilePhone';
  final String _mobilePhoneVerifyUrl = '/1.1/requestSmsCode';
  final String _loginUpUrl = '/1.1/login';
  final String _uploadUrl = '/1.1/files/test.png';
  final String _updateWaybillFile = '/1.1/functions/updateWaybillFile';

  //用dio代替,dio网址后面不能有/
  useDio(String url, Map map, String who) async {
    var result;
    var error;
    print('who is==${who}');
    User user = await User().getUser();
    print('useDio--token--${user.sessionToken}');
    print('useDio--map: $map');
    BaseOptions options = BaseOptions(baseUrl: _baseUrl);
    options.headers['X-LC-Id'] = _appID;
    options.headers["X-LC-Key"] = _appKey;
    options.headers['X-LC-Session'] = user.sessionToken;
    options.headers['content-type'] = 'application/json';
    options.connectTimeout = 10000;
    options.receiveTimeout = 10000;
    print('useDio--headers--${options.headers}');
    Dio dio = Dio(options);
    try {
      result = await dio.post(_baseUrl + url, data: map);
      print('网址--${_baseUrl + url}');
    } on DioError catch (e) {
      print('useDio--error=${e.response.data}');
      print('useDio--error=${e.response.headers}');
      print('useDio--error=${e.response.request.data}');
      error = e.response.data;
    }
    if (error != null) {
      print('useDio--error--${error['code']}--message${error['message']}');
      return error['code'];
    } else if (error == null) {
      print('useDio--${result}');
      print('useDio--200--${error}');
      if (result.statusCode == 200) {
        return jsonDecode(result.toString());
      }
    }
  }

  _upload(String localImagePath, filename) async {
    User user = User();
    await user.getUser();
    BaseOptions options = BaseOptions();

    ///请求header的配置
    options.headers['X-LC-Id'] = _appID;
    options.headers["X-LC-Key"] = _appKey;
    options.headers["X-LC-Session"] = user.sessionToken;

    options.contentType = "image/png";
    options.method = "POST";
    options.connectTimeout = 30000;

    Dio dio = new Dio(options);

    Map<String, dynamic> map = Map();

    map["file"] =
        await MultipartFile.fromFile(localImagePath, filename: filename);

    ///通过FormData
    FormData formData = FormData.fromMap(map);

    ///发送post
    Response response = await dio.post(
      _baseUrl + _uploadUrl, data: formData,

      ///这里是发送请求回调函数
      ///[progress] 当前的进度
      ///[total] 总进度
      onSendProgress: (int progress, int total) {
        print("当前进度是 $progress 总进度是 $total");
      },
    );

    ///服务器响应结果
    var data = response.data;
    return data;
  }

  _post(String url, Map data, [Map header, bool second = true]) async {
    //second 为出现invalid user时是否尝试自动登录
    User user = await User().getUser();
    var responseBody;
    var httpClient = new HttpClient();
    var request = await httpClient.postUrl(Uri.parse(_baseUrl + url));
    request.headers.set('X-LC-Id', _appID);
    request.headers.set('X-LC-Key', _appKey);
    if (user != null && _baseUrl != _signUpUrl) {
      request.headers.set("X-LC-Session", user.sessionToken);
    }
    //print('post--token${user.sessionToken}');
    request.headers.set('Content-Type', 'application/json');
    if (header != null) {
      header.forEach((k, v) {
        request.headers.set(k, v);
      });
    }
    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200 || response.statusCode == 201) {
      responseBody = await response.transform(utf8.decoder).join();
      responseBody = json.decode(responseBody);
      print('成功信息--$responseBody');
      return responseBody;
    } else {
      print("error");
      print(response.statusCode);
      print(json.encode(data));
    }
    //print('身份---${responseBody}');
    if (responseBody == 'Invalid User') {
      if (second == true) {
        responseBody = await this
            .mobilePhoneLogin(user?.phoneNumber, user?.password, false);
        print('登录--$responseBody');
        if (responseBody == null) {
          Fluttertoast.showToast(
            msg: "自动登录失败",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
          );
          MyApp.navigatorState.currentState.pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => LoginPage(user: user ?? null),
                  fullscreenDialog: true),
              (Route<dynamic> route) => false);
        } else {
          Fluttertoast.showToast(
            msg: "自动登录成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
          );
          user.sessionToken = responseBody['sessionToken'];
          user.saveUser(user);
          responseBody = await _post(url, data, header, false);
          return (responseBody);
        }
      }
    }
    return null;
  }

  mobilePhoneLogin(String mobilePhoneNumber, password, [bool second = false]) {
    var responseBody;
    responseBody = _post(
        _loginUpUrl,
        {'mobilePhoneNumber': mobilePhoneNumber, 'password': password},
        {},
        second);
    return responseBody;
  }

  getCurrentWaybill() async {
    var responseBody;
    responseBody = await useDio('/1.1/functions/getCurrentWaybill', {},'getCurrentWaybill');
    return responseBody;
  }

  //todo
  //根据订单号查询订单信息
  getWaybillAdmin(String waybillid) async {
    var responseBody;
    responseBody = await useDio(
        '/1.1/functions/getWaybillAdmin', {'waybillid': waybillid},'getWaybillAdmin');
    print('getWaybillAdmin--${responseBody.runtimeType}');
    return responseBody;
  }

//todo 遍历
  getAll(String tableName, String waybillId, bool hasCursor,
      {String cursor}) async {
    var responseBody;
    final String _appKey = 'U6rS9PAaDubYYkd8ejK3Eoho,master';
    BaseOptions options = BaseOptions(baseUrl: _baseUrl);
    options.headers['X-LC-Id'] = _appID;
    options.headers["X-LC-Key"] = _appKey;
    options.headers['content-type'] = 'application/json';
    print('headers--${options.headers}');
    Dio dio = Dio(options);
    //{"waybill_ID":"GCZC00021375"}
    //一定要加双引号完全按照api测试工具的形式，传入map缺少双引号，会返回400
    print(
        '网址=${_baseUrl + '/1.1/scan/classes/$tableName?where={"waybill_ID":"$waybillId"}'}');
    hasCursor == true
        ? responseBody = await dio.get(_baseUrl +
            '/1.1/scan/classes/$tableName?where={"waybill_ID":"$waybillId"}&cursor=$cursor')
        // &order=createdAt  createdAt从新到旧，-createdAt从旧到新
        : responseBody = await dio.get(_baseUrl +
            '/1.1/scan/classes/$tableName?where={"waybill_ID":"$waybillId"}');
    print('获取所有--${jsonDecode(responseBody.toString())['cursor']}');
    return jsonDecode(responseBody.toString());
  }

  // todo 根据value返回订单
  //value=0 返回所有订单
  //value=1 返回运输中订单
  //value=2 返回已完成订单
  getWaybillByValue(String value) async {
    var responseBody;
    responseBody =
        await useDio('/1.1/functions/getWaybillByValue', {'value': value},'getWaybillByValue');
    print('getWaybillByValue--${responseBody}');
    return responseBody;
    /* User user = await User().getUser();
    print('token--${user.sessionToken}');
    BaseOptions options = BaseOptions(baseUrl: _baseUrl);
    options.headers['X-LC-Id'] = _appID;
    options.headers["X-LC-Key"] = _appKey;
    options.headers['X-LC-Session'] = user.sessionToken;
    options.headers['content-type'] = 'application/json';
    Map<String, dynamic> map = {"value": value};
    FormData formData = FormData.fromMap(map);
    print('headers--${options.headers}');
    Dio dio = Dio(options);
    print('option--${formData.length}');
    var response = await dio.post(_baseUrl + '/1.1/functions/getWaybillByValue',
        data: formData);
    print('response ${response}');
    if (response.statusCode == 200) {
      responseBody = WaybillEntity().fromJson(jsonDecode(response.toString()));
    }*/

    /* var responseBody;
    print('值--$value');
    responseBody =
        await _post('/1.1/functions/getWaybillByValue/', {'value': value});
    print('打印$responseBody');
    return responseBody;*/
  }

  //todo 发布订单
  releaseWaybill(Map map) async {
    var responseBody;
    responseBody = await useDio('/1.1/functions/releaseWaybill', map,'releaseWaybill');
    return responseBody;
    /*var responseBody;
    responseBody = _post('/1.1/functions/releaseWaybill/', map);
    return responseBody;*/
  }

//todo 根据Excel发布订单
  releaseByExcel(Map map) async {
    var responseBody;
    responseBody = await useDio('/1.1/functions/releaseByExcel', map,'releaseByExcel');
    return responseBody;

    /*  var responseBody;
    responseBody = _post('/1.1/functions/releaseByExcel/', map);
    return responseBody;*/
  }

  //todo 更新司机信息
  updateDriverMessage(Map map) async {
    var responseBody;
    responseBody = await useDio('/1.1/functions/updateDriverMessage', map,'updateDriverMessage');
    print('updateDriverMessage--${responseBody}');
    return responseBody;

    /*  var responseBody;
    responseBody = _post('/1.1/functions/releaseByExcel/', map);
    return responseBody;*/
  }

//todo 获取订单的所有信息
  getFinishImage(String orderNumber) async {
    var responseBody;
    print('getFinishImage--单号--${orderNumber}');
    responseBody = await useDio(
        '/1.1/functions/getFinishImage', {'waybillid': orderNumber},'getFinishImage');
    print('getFinishImage---${responseBody.runtimeType}');
    return responseBody;
  }

  //todo搜索单张订单
  searchWaybill(String waybillId) async {
    var responseBody;
    responseBody =
        await useDio('/1.1/functions/searchWaybill', {'waybillid': waybillId},'searchWaybill');
    return responseBody;
    /*var responseBody;
    responseBody =
        _post('/1.1/functions/searchWaybill/', {'waybillid': waybillId});
    return responseBody;*/
  }

  //todo 搜索
  searchSuggestion(String text) async {
    var responseBody;
    responseBody =
        await useDio('/1.1/functions/suggestion', {'waybillid': text},'searchSuggestion');
    return responseBody;
    /* var responseBody;
    responseBody = _post('/1.1/functions/suggestion/', {'waybillid': text});
    return responseBody;*/
  }

  //单设备登录刷新token
  refreshToken(String token, String objectId) async {
    print(
        '网址--${_baseUrl + '/1.1/users/' + objectId + '/refreshSessionToken'}');
    var responseBody;
    BaseOptions options = BaseOptions(baseUrl: _baseUrl);
    options.headers['X-LC-Id'] = _appID;
    options.headers['X-LC-Key'] = _appKey;
    options.headers['X-LC-Session'] = token;
    Dio dio = Dio(options);
    responseBody = await dio
        .put(_baseUrl + '/1.1/users/' + objectId + '/refreshSessionToken');
    print('Server--refreshToken--${refreshToken}');
    return jsonDecode(responseBody.toString());
  }

  checkLogin(String sessionToken) {
    if (sessionToken != null) {
      return true;
    } else {
      return false;
    }
  }

  finishWaybill(String waybillid) {
    var responseBody;
    responseBody =
        _post('/1.1/functions/finishWaybill', {'waybillid': waybillid});
    return responseBody;
  }

  int numHistoryOrders() {
    return 3; //测试数据
  }

  String getHistoryWaybill(int index) {
    return '';
  }

  String getHistoryDeparture(int index) {
    return ' ';
  }

  String getHistoryArrival(int index) {
    return ' ';
  }

  String getHistoryReciever(int index) {
    return ' ';
  }

  DateTime getHistoryDate(int index) {
    DateTime _datetime = DateTime.now();
    return _datetime;
  }

  String getHistoryMaterialInfo(int index) {
    return ' ';
  }

  Server();
}
