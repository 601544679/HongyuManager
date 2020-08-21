List<logisticsInformation> ff() {
  List<logisticsInformation> information = new List<logisticsInformation>();
  information.add(new logisticsInformation(
      1255, '佛山', '北京', '张三', '三宝', '600*600吉祥三宝', '运输中', 1,1597104000000));
  information.add(new logisticsInformation(
      7555, '佛山', '广州', '天亮', '冰玑', '1200*1200大理石瓷砖', '运输中', 1,1596585600000));
  information.add(new logisticsInformation(
      9527, '云浮', '海南', '张伟', '仿古', '800*800仿古砖', '运输中', 1,1596931200000));
  information.add(new logisticsInformation(
      4589, '南京', '佛山', '李元浩', '玉瓷', '800*800玉瓷砖', '已完成', 2,1593648000000));
  information.add(new logisticsInformation(
      7581, '佛山', '铁岭', '天亮', '冰玑', '1000*1000冰玑石', '已完成', 2,1591315200000));
  information.add(new logisticsInformation(
      6598, '西藏', '浙江', '明凯', '抛釉', '1000*1000抛釉砖', '已完成', 2,1594252800000));
  information.add(new logisticsInformation(
      6598, '西安', '宁夏', '林司机', '现代', '1000*1000现代砖', '运输中', 1,1596240000000));
  information.add(new logisticsInformation(
      6598, '雄安', '天津', '关羽', '磨砂', '200*200磨砂砖', '已完成', 2,1589760000000));
  information.sort((a, b) => b.orderTime.compareTo(a.orderTime));
  return information;
}

class logisticsInformation {
  //私有字段才能set，get
  int _orderNumber;
  String _Departure;
  String _destination;
  String _driverName;
  String _projectName;
  String _message;
  String _state;
  int _isFinish;
  int _orderTime;

  logisticsInformation(
      this._orderNumber,
      this._Departure,
      this._destination,
      this._driverName,
      this._projectName,
      this._message,
      this._state,
      this._isFinish,
      this._orderTime);

  int get orderTime => _orderTime;

  set orderTime(int value) {
    _orderTime = value;
  }

  int get orderNumber => _orderNumber;

  set orderNumber(int value) {
    _orderNumber = value;
  }

  int get isFinish => _isFinish;

  set isFinish(int value) {
    _isFinish = value;
  }

  String get Departure => _Departure;

  set Departure(String value) {
    _Departure = value;
  }

  String get destination => _destination;

  set destination(String value) {
    _destination = value;
  }

  String get driverName => _driverName;

  set driverName(String value) {
    _driverName = value;
  }

  String get projectName => _projectName;

  set projectName(String value) {
    _projectName = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  @override
  String toString() {
    return 'logisticsInformation{_orderNumber: $_orderNumber, _Departure: $_Departure, _destination: $_destination, _driverName: $_driverName, _projectName: $_projectName, _message: $_message, _state: $_state, _isFinish: $_isFinish, _orderTime: $_orderTime}';
  }
}
