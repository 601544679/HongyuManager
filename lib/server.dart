import 'dart:io';
import 'dart:convert';
import 'userClass.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'login.dart';
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
  final String _updateWaybillFile = '/1.1/functions/updateWaybillFile/';

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
      return responseBody;
    } else {
      print("error");
      print(response.statusCode);
      print(json.encode(data));
    }
    if (responseBody == 'Invalid User') {
      if (second == true) {
        responseBody = await this
            .mobilePhoneLogin(user?.phoneNumber, user?.password, false);
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

  signUp(Map signUpInform) async {
    // List<Map> _newTitle=new List();
    var responseBody;
    responseBody = _post(_signUpUrl, signUpInform);
    return responseBody;
  }

  requestMobilePhoneVerify(String phoneNum) {
    var responseBody;
    phoneNum = '+86' + phoneNum;
    responseBody =
        _post(_mobilePhoneVerifyUrl, {'mobilePhoneNumber': phoneNum});
    return responseBody;
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
    responseBody = _post('/1.1/functions/getCurrentWaybill/', {});
    print('getCurrentWaybill: ${getCurrentWaybill}');
    return responseBody;
  }

  //todo
  //根据订单号查询订单信息
  getWaybillAdmin(String waybillid) async {
    var responseBody;
    responseBody =
        _post('/1.1/functions/getWaybillAdmin/', {'waybillid': waybillid});
    print('getWaybillAdmin:${responseBody}');
    return responseBody;
  }

//todo 返回运输中订单
  getWaybillTransport() async {
    var responseBody;
    responseBody = _post('/1.1/functions/getWaybillTransport/', {});
    return responseBody
        /*{
      'ID': '运输单号',
      'startLocationName': '出发地',
      'destinationName': '目的地',
      'driverName': '司机名',
      'state': '订单状态',
      'projectName': '项目名称',
      'ConstructionUnit': '施工单位',
      'arrivalTime': '计划到达时间',
      'message': '送货单信息',
      'supplier': '业务员姓名',
      'date': '发货日期'
    }*/
        ;
  }

//todo 返回已完成订单
  getWaybillHistoryAdmin() async {
    var responseBody;
    responseBody = _post('/1.1/functions/getWaybillHistoryAdmin/', {});
    return responseBody;

    /* {
      'ID': '运输单号',
      'startLocationName': '出发地',
      'destinationName': '目的地',
      'driverName': '司机名',
      'state': '订单状态',
      'projectName': '项目名称',
      'ConstructionUnit': '施工单位',
      'arrivalTime': '计划到达时间',
      'message': '送货单信息',
      'supplier': '业务员姓名',
      'date': '发货日期'
    }*/
  }

  // todo 根据value返回订单
  //value=0 返回所有订单
  //value=1 返回运输中订单
  //value=2 返回已完成订单
  getWaybillByValue(String value) {
    var responseBody;
    responseBody = _post('/1.1/functions/getWaybillByValue/', {'value': value});
    return responseBody;
  }

  //todo 返回所有订单
  getAllWaybill() async {
    var responseBody;
    responseBody = _post('/1.1/functions/getAllWaybill/', {});
    return /* {
      'ID': '运输单号',
      'startLocationName': '出发地',
      'destinationName': '目的地',
      'driverName': '司机名',
      'state': '订单状态',
      'projectName': '项目名称',
      'ConstructionUnit': '施工单位',
      'arrivalTime': '计划到达时间',
      'message': '送货单信息',
      'supplier': '业务员姓名',
      'departureDate': '发货日期',
    }*/
        responseBody;
  }

  //todo 发布订单
  releaseWaybill(Map map) async {
    var responseBody;
    responseBody = _post('/1.1/functions/releaseWaybill/', map);
    return responseBody;
  }

//todo 根据Excel发布订单
  releaseByExcel(Map map) {
    var responseBody;
    for (int i = 0; i < map.length; i++) {
      responseBody = _post('/1.1/functions/releaseByExcel/', map);
    }

    return responseBody;
  }

//todo 获取订单的所有信息
  getFinishImage(String orderNumber) async {
    var responseBody;
    responseBody =
        _post('/1.1/functions/getFinishImage/', {'waybillid': orderNumber});
    return /*[
      {
        'allMessage':
         {
        '订单的所有信息'
        ...
      'XK_NO':[销售单号,销售单号1,销售单号2],
      'materialsNumber':[物料号,物料号1,物料号2],
      'client_ID':[客户编码,客户编码1,客户编码2]
      'size':[规格,规格1,规格2]
      'billingColor':[色号,色号1,色号2]，
      'BillingUnit':[单位,单位1,单位2],
      'sendQuantity':[发货数量,发货数量1,发货数量2]
      'quantity':[数量,数量1,数量2]
      'M2':[M2,M2(1),M2(2)]
      'unitPrice':[单价,单价1,单价2]
      'palletsNumber':[托板数,托板数1,托板数2]
      'ShippingWeight':[发货重量,发货重量1,发货重量2]
      'detailedRemark':[明细备注,明细备注1,明细备注2]
      'loadingRemarks':[装车备注,装车备注,装车备注]
        }
      },
    ]*/
        responseBody;
  }

  posUpdate(String waybillid, double lat, lon, String positionname) {
    //上传位置
    var responseBody;
    responseBody = _post('/1.1/functions/posUpdate/', {
      'waybillid': waybillid,
      'positionLat': lat,
      'positionLon': lon,
      'positionname': positionname
    });
    return responseBody;
  }

  uploadImage(String waybillid, File i1, i2, i3) async {
    var responseBody;
    print('------------------上传开始-------------------');
    responseBody = await _upload(i1.path, 'file1.png');
    String url = responseBody['url'];
    responseBody = await _upload(i2.path, 'file2.png');
    String url2 = responseBody['url'];
    responseBody = await _upload(i3.path, 'file3.png');
    String url3 = responseBody['url'];
    responseBody = await _post(_updateWaybillFile, {
      'waybillid': waybillid,
      'photoUrl_d': url,
      'photoUrl_s': url2,
      'photoUrl_y': url3,
    });
    return responseBody;
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
        _post('/1.1/functions/finishWaybill/', {'waybillid': waybillid});
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
