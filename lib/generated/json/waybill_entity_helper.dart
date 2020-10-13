import 'package:mydemo/waybill_entity.dart';

waybillEntityFromJson(WaybillEntity data, Map<String, dynamic> json) {
	if (json['result'] != null) {
		data.result = new List<WaybillResult>();
		(json['result'] as List).forEach((v) {
			data.result.add(new WaybillResult().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> waybillEntityToJson(WaybillEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.result != null) {
		data['result'] =  entity.result.map((v) => v.toJson()).toList();
	}
	return data;
}

waybillResultFromJson(WaybillResult data, Map<String, dynamic> json) {
	if (json['constructionCompanyName'] != null) {
		data.constructionCompanyName = json['constructionCompanyName']?.toString();
	}
	if (json['detailedRemarks'] != null) {
		data.detailedRemarks = json['detailedRemarks']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['projectAddress'] != null) {
		data.projectAddress = json['projectAddress']?.toString();
	}
	if (json['photoUrl_shunfeng'] != null) {
		data.photourlShunfeng = json['photoUrl_shunfeng']?.toString();
	}
	if (json['XK_NO'] != null) {
		data.xkNo = json['XK_NO']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['car'] != null) {
		data.car = new WaybillResultCar().fromJson(json['car']);
	}
	if (json['color'] != null) {
		data.color = json['color']?.toString();
	}
	if (json['estimatedArrivalTime'] != null) {
		data.estimatedArrivalTime = json['estimatedArrivalTime']?.toInt();
	}
	if (json['destinationName'] != null) {
		data.destinationName = json['destinationName']?.toString();
	}
	if (json['carNo'] != null) {
		data.carNo = json['carNo']?.toString();
	}
	if (json['amountInSquare'] != null) {
		data.amountInSquare = json['amountInSquare']?.toInt();
	}
	if (json['constructionSiteContactPerson'] != null) {
		data.constructionSiteContactPerson = json['constructionSiteContactPerson']?.toString();
	}
	if (json['arrivalTime'] != null) {
		data.arrivalTime = json['arrivalTime']?.toInt();
	}
	if (json['palletsNumber'] != null) {
		data.palletsNumber = json['palletsNumber']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['containerNo'] != null) {
		data.containerNo = json['containerNo']?.toString();
	}
	if (json['projectName'] != null) {
		data.projectName = json['projectName']?.toString();
	}
	if (json['signedWaybillPhoto'] != null) {
		data.signedWaybillPhoto = new WaybillResultSignedWaybillPhoto().fromJson(json['signedWaybillPhoto']);
	}
	if (json['ShippingWeight'] != null) {
		data.shippingWeight = json['ShippingWeight']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['supplierContactPhone'] != null) {
		data.supplierContactPhone = json['supplierContactPhone']?.toString();
	}
	if (json['size'] != null) {
		data.size = json['size']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['waybill_ID'] != null) {
		data.waybillId = json['waybill_ID']?.toString();
	}
	if (json['photoUrl_yunhuo'] != null) {
		data.photourlYunhuo = json['photoUrl_yunhuo']?.toString();
	}
	if (json['sendQuantity'] != null) {
		data.sendQuantity = json['sendQuantity']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['BillingUnit'] != null) {
		data.billingUnit = json['BillingUnit']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['projectOwnerCompanyName'] != null) {
		data.projectOwnerCompanyName = json['projectOwnerCompanyName']?.toString();
	}
	if (json['logisticsOrderNo'] != null) {
		data.logisticsOrderNo = json['logisticsOrderNo']?.toString();
	}
	if (json['ModeOfTransport'] != null) {
		data.modeOfTransport = json['ModeOfTransport']?.toString();
	}
	if (json['company_ID'] != null) {
		data.companyId = json['company_ID']?.toString();
	}
	if (json['billingColor'] != null) {
		data.billingColor = json['billingColor']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['supplierContactPerson'] != null) {
		data.supplierContactPerson = json['supplierContactPerson']?.toString();
	}
	if (json['departureDate'] != null) {
		data.departureDate = json['departureDate']?.toInt();
	}
	if (json['startLocationName'] != null) {
		data.startLocationName = json['startLocationName']?.toString();
	}
	if (json['loadingRemarks'] != null) {
		data.loadingRemarks = json['loadingRemarks']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['quantity'] != null) {
		data.quantity = json['quantity']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['client_ID'] != null) {
		data.clientId = json['client_ID']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['driver'] != null) {
		data.driver = new WaybillResultDriver().fromJson(json['driver']);
	}
	if (json['constructionSiteContactPhone'] != null) {
		data.constructionSiteContactPhone = json['constructionSiteContactPhone']?.toString();
	}
	if (json['photoUrl_destination'] != null) {
		data.photourlDestination = json['photoUrl_destination']?.toString();
	}
	if (json['materialsNumber'] != null) {
		data.materialsNumber = json['materialsNumber']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['unitPrice'] != null) {
		data.unitPrice = json['unitPrice']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['destination'] != null) {
		data.destination = new WaybillResultDestination().fromJson(json['destination']);
	}
	if (json['arrivedAmount'] != null) {
		data.arrivedAmount = json['arrivedAmount']?.toInt();
	}
	if (json['M2'] != null) {
		data.m2 = json['M2']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['amountInBlock'] != null) {
		data.amountInBlock = json['amountInBlock']?.toInt();
	}
	if (json['objectId'] != null) {
		data.objectId = json['objectId']?.toString();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt']?.toString();
	}
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt']?.toString();
	}
	return data;
}

Map<String, dynamic> waybillResultToJson(WaybillResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['constructionCompanyName'] = entity.constructionCompanyName;
	data['detailedRemarks'] = entity.detailedRemarks;
	data['projectAddress'] = entity.projectAddress;
	data['photoUrl_shunfeng'] = entity.photourlShunfeng;
	data['XK_NO'] = entity.xkNo;
	if (entity.car != null) {
		data['car'] = entity.car.toJson();
	}
	data['color'] = entity.color;
	data['estimatedArrivalTime'] = entity.estimatedArrivalTime;
	data['destinationName'] = entity.destinationName;
	data['carNo'] = entity.carNo;
	data['amountInSquare'] = entity.amountInSquare;
	data['constructionSiteContactPerson'] = entity.constructionSiteContactPerson;
	data['arrivalTime'] = entity.arrivalTime;
	data['palletsNumber'] = entity.palletsNumber;
	data['containerNo'] = entity.containerNo;
	data['projectName'] = entity.projectName;
	if (entity.signedWaybillPhoto != null) {
		data['signedWaybillPhoto'] = entity.signedWaybillPhoto.toJson();
	}
	data['ShippingWeight'] = entity.shippingWeight;
	data['supplierContactPhone'] = entity.supplierContactPhone;
	data['size'] = entity.size;
	data['waybill_ID'] = entity.waybillId;
	data['photoUrl_yunhuo'] = entity.photourlYunhuo;
	data['sendQuantity'] = entity.sendQuantity;
	data['BillingUnit'] = entity.billingUnit;
	data['status'] = entity.status;
	data['projectOwnerCompanyName'] = entity.projectOwnerCompanyName;
	data['logisticsOrderNo'] = entity.logisticsOrderNo;
	data['ModeOfTransport'] = entity.modeOfTransport;
	data['company_ID'] = entity.companyId;
	data['billingColor'] = entity.billingColor;
	data['supplierContactPerson'] = entity.supplierContactPerson;
	data['departureDate'] = entity.departureDate;
	data['startLocationName'] = entity.startLocationName;
	data['loadingRemarks'] = entity.loadingRemarks;
	data['quantity'] = entity.quantity;
	data['client_ID'] = entity.clientId;
	if (entity.driver != null) {
		data['driver'] = entity.driver.toJson();
	}
	data['constructionSiteContactPhone'] = entity.constructionSiteContactPhone;
	data['photoUrl_destination'] = entity.photourlDestination;
	data['materialsNumber'] = entity.materialsNumber;
	data['unitPrice'] = entity.unitPrice;
	if (entity.destination != null) {
		data['destination'] = entity.destination.toJson();
	}
	data['arrivedAmount'] = entity.arrivedAmount;
	data['M2'] = entity.m2;
	data['amountInBlock'] = entity.amountInBlock;
	data['objectId'] = entity.objectId;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

waybillResultCarFromJson(WaybillResultCar data, Map<String, dynamic> json) {
	if (json['__type'] != null) {
		data.sType = json['__type']?.toString();
	}
	if (json['className'] != null) {
		data.className = json['className']?.toString();
	}
	if (json['objectId'] != null) {
		data.objectId = json['objectId']?.toString();
	}
	return data;
}

Map<String, dynamic> waybillResultCarToJson(WaybillResultCar entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['__type'] = entity.sType;
	data['className'] = entity.className;
	data['objectId'] = entity.objectId;
	return data;
}

waybillResultSignedWaybillPhotoFromJson(WaybillResultSignedWaybillPhoto data, Map<String, dynamic> json) {
	if (json['__type'] != null) {
		data.sType = json['__type']?.toString();
	}
	if (json['className'] != null) {
		data.className = json['className']?.toString();
	}
	if (json['objectId'] != null) {
		data.objectId = json['objectId']?.toString();
	}
	return data;
}

Map<String, dynamic> waybillResultSignedWaybillPhotoToJson(WaybillResultSignedWaybillPhoto entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['__type'] = entity.sType;
	data['className'] = entity.className;
	data['objectId'] = entity.objectId;
	return data;
}

waybillResultDriverFromJson(WaybillResultDriver data, Map<String, dynamic> json) {
	if (json['role'] != null) {
		data.role = json['role']?.toString();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['emailVerified'] != null) {
		data.emailVerified = json['emailVerified'];
	}
	if (json['mobilePhoneNumber'] != null) {
		data.mobilePhoneNumber = json['mobilePhoneNumber']?.toString();
	}
	if (json['identityNo'] != null) {
		data.identityNo = json['identityNo']?.toString();
	}
	if (json['company'] != null) {
		data.company = json['company']?.toString();
	}
	if (json['mobilePhoneVerified'] != null) {
		data.mobilePhoneVerified = json['mobilePhoneVerified'];
	}
	if (json['objectId'] != null) {
		data.objectId = json['objectId']?.toString();
	}
	if (json['createdAt'] != null) {
		data.createdAt = json['createdAt']?.toString();
	}
	if (json['updatedAt'] != null) {
		data.updatedAt = json['updatedAt']?.toString();
	}
	return data;
}

Map<String, dynamic> waybillResultDriverToJson(WaybillResultDriver entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['role'] = entity.role;
	data['username'] = entity.username;
	data['emailVerified'] = entity.emailVerified;
	data['mobilePhoneNumber'] = entity.mobilePhoneNumber;
	data['identityNo'] = entity.identityNo;
	data['company'] = entity.company;
	data['mobilePhoneVerified'] = entity.mobilePhoneVerified;
	data['objectId'] = entity.objectId;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

waybillResultDestinationFromJson(WaybillResultDestination data, Map<String, dynamic> json) {
	if (json['__type'] != null) {
		data.sType = json['__type']?.toString();
	}
	if (json['latitude'] != null) {
		data.latitude = json['latitude']?.toDouble();
	}
	if (json['longitude'] != null) {
		data.longitude = json['longitude']?.toDouble();
	}
	return data;
}

Map<String, dynamic> waybillResultDestinationToJson(WaybillResultDestination entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['__type'] = entity.sType;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	return data;
}