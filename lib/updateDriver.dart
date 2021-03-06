class updateDriver {
  String logisticsOrderNo;
  String waybill_ID;
  String carNo;
  String company_ID;
  String company;
  String mobilePhoneNumber;
  String username;
  String identityNo;
  int estimatedArrivalTime;
  String roadTransportPermit;
  String qualificationCertificate;
  String deadWeight;

  updateDriver(
      {this.logisticsOrderNo,
        this.waybill_ID,
        this.carNo,
        this.company_ID,
        this.company,
        this.mobilePhoneNumber,
        this.username,
        this.identityNo,
        this.estimatedArrivalTime,
        this.roadTransportPermit,
        this.qualificationCertificate,
        this.deadWeight});

  @override
  String toString() {
    return '{$logisticsOrderNo,  $waybill_ID,  $carNo, $company_ID,  $company,'
        ' $mobilePhoneNumber, $username,  $identityNo,  $estimatedArrivalTime, $roadTransportPermit, '
        ' $qualificationCertificate, $deadWeight}';
  }

  set setLogisticsOrderNo(String logisticsOrderNo) {
    this.logisticsOrderNo = logisticsOrderNo;
  }

  String get getLogisticsOrderNo => this.logisticsOrderNo;

  set setWaybill_ID(String waybill_ID) {
    this.waybill_ID = waybill_ID;
  }

  String get getWaybill_ID => this.waybill_ID;

  set setCarNo(String carNo) {
    this.carNo = carNo;
  }

  String get getCarNo => this.carNo;

  set setCompany_ID(String company_ID) {
    this.company_ID = company_ID;
  }

  String get getCompany_ID => this.company_ID;

  set setCompany(String company) {
    this.company = company;
  }

  String get getCompany => this.company;

  set setMobilePhoneNumber(String mobilePhoneNumber) {
    this.mobilePhoneNumber = mobilePhoneNumber;
  }

  String get getMobilePhoneNumber => this.mobilePhoneNumber;

  set setUsername(String username) {
    this.username = username;
  }

  String get getUsername => this.username;

  set setIdentityNo(String identityNo) {
    this.identityNo = identityNo;
  }

  String get getIdentityNo => this.identityNo;

  set setEstimatedArrivalTime(int estimatedArrivalTime) {
    this.estimatedArrivalTime = estimatedArrivalTime;
  }

  int get getEstimatedArrivalTime => this.estimatedArrivalTime;

  set setRoadTransportPermit(String roadTransportPermit) {
    this.roadTransportPermit = roadTransportPermit;
  }

  String get getRoadTransportPermit => this.roadTransportPermit;

  set setQualificationCertificate(String qualificationCertificate) {
    this.qualificationCertificate = qualificationCertificate;
  }

  String get getQualificationCertificate => this.qualificationCertificate;

  set setDeadWeight(String deadWeight) {
    this.deadWeight = deadWeight;
  }

  String get getDeadWeight => this.deadWeight;
}
