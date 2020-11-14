import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  Server server = Server();
  String phoneNumber;
  String password;
  String idNumber;
  String sessionToken;
  String name;
  String company;
  String realName;
  String role;
  String currentWaybill;
  String objectId;
  bool isSave;

  User() {
    phoneNumber = null;
    password = null;
    idNumber = null;
    sessionToken = null;
    name = null;
    company = null;
    realName = null;
    role = null;
    currentWaybill = null;
    objectId = null;
    isSave = null;
  }

  checkLogin() async {
    User userT = await getUser();
    return server.checkLogin(userT.sessionToken);
  }

  checkWaybill() async {
    User userT = await getUser();
    return userT.currentWaybill != null;
  }

  saveUser(User data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(data.toJson()));
    if (data.isSave == true) {
      final storage = new FlutterSecureStorage();
      storage.write(key: 'user', value: json.encode(data.toJson()));
    }
  }

  getUser() async {
    var userT;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userT = prefs.getString('user');
    if (userT == null) {
      return null;
    }
    userT = User.fromJson(json.decode(userT));
    return (userT);
  }

  int numHistoryOrders() {
    return 3; //测试数据
  }

  String getHistoryWaybill(int index) {
    return ' ';
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

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phoneNumber = json['phoneNumber'],
        idNumber = json['idNumber'],
        sessionToken = json['sessionToken'],
        company = json['company'],
        realName = json['realName'],
        role = json['role'],
        currentWaybill = json['currentWaybill'],
        objectId = json['objectId'],
        password = json['password'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'phoneNumber': phoneNumber,
        'idNumber': idNumber,
        'sessionToken': sessionToken,
        'company': company,
        'realName': realName,
        'role': role,
        'currentWaybill': currentWaybill,
        'objectId': objectId,
        'password': password,
      };
}

class Waybill {
  String ID;
  String destinationName;
  double destinationLon;
  double destinationLat;
  String receiver;
  String receiverPhone;
  String supplierPhone;
  String supplier;

  Waybill();

  getWaybill() async {
    var waybill;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    waybill = prefs.getString('waybill');
    print('getWaybill():${waybill}');
    if (waybill == null) {
      return null;
    }
    waybill = Waybill.fromJson(json.decode(waybill));
    print('Waybill.fromJson():${waybill}');
    return (waybill);
  }

  updateWaybill() async {
    Waybill waybill;
    var waybillT;
    await Server()
        .getCurrentWaybill()
        .timeout(const Duration(seconds: 10))
        .then((onValue) async {
      print('getCurrentWaybill的值:${onValue}');
      try {
        waybillT = onValue['result'];
        print('updateWaybill--waybill:  ${waybillT}');
        print(waybillT['state']);
        print('state');
        if (waybillT['state'] == 'notInProgress') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('waybill');
          User user = await User().getUser();
          user.currentWaybill = 'No';
          await user.saveUser(user);
        } else {
          waybill = Waybill.fromJson(waybillT);
          await waybill.saveWaybill(waybill);
          User user = await User().getUser();
          user.currentWaybill = 'YES';
          await user.saveUser(user);
        }
      } catch (e) {
        print(e);
        waybillT = null;
      }
    });
    if (waybillT != null) {
      return 'success';
    } else {
      return 'fail';
    }
  }

  saveWaybill(Waybill data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('waybill', json.encode(data.toJson()));
  }

  Waybill.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        destinationName = json['destinationName'],
        destinationLat = json['destinationLat'],
        destinationLon = json['destinationLon'],
        receiver = json['receiver'],
        receiverPhone = json['receiverPhone'],
        supplier = json['supplier'],
        supplierPhone = json['supplierPhone'];

  Map<String, dynamic> toJson() => {
  'ID': ID,
  'destinationName': destinationName,
  'destinationLat': destinationLat,
  'destinationLon': destinationLon,
  'receiver': receiver,
  'receiverPhone': receiverPhone,
  'supplier': supplier,
  'supplierPhone': supplierPhone
};

@override
String toString() {
  return 'Waybill{ID: $ID, destinationName: $destinationName, destinationLon: $destinationLon, destinationLat: $destinationLat, receiver: $receiver, receiverPhone: $receiverPhone, supplierPhone: $supplierPhone, supplier: $supplier}';
}}
