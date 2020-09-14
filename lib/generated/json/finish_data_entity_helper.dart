import 'package:mydemo/finish_data_entity.dart';

finishDataEntityFromJson(FinishDataEntity data, Map<String, dynamic> json) {
	if (json['result'] != null) {
		data.result = new FinishDataResult().fromJson(json['result']);
	}
	return data;
}

Map<String, dynamic> finishDataEntityToJson(FinishDataEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.result != null) {
		data['result'] = entity.result.toJson();
	}
	return data;
}

finishDataResultFromJson(FinishDataResult data, Map<String, dynamic> json) {
	if (json['imageUrl'] != null) {
		data.imageUrl = json['imageUrl']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['allMessage'] != null) {
		data.allMessage = new FinishDataResultAllMessage().fromJson(json['allMessage']);
	}
	return data;
}

Map<String, dynamic> finishDataResultToJson(FinishDataResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['imageUrl'] = entity.imageUrl;
	if (entity.allMessage != null) {
		data['allMessage'] = entity.allMessage.toJson();
	}
	return data;
}

finishDataResultAllMessageFromJson(FinishDataResultAllMessage data, Map<String, dynamic> json) {
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
	if (json['destinationName'] != null) {
		data.destinationName = json['destinationName']?.toString();
	}
	if (json['carNo'] != null) {
		data.carNo = json['carNo']?.toString();
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
		data.driver = new FinishDataResultAllMessageDriver().fromJson(json['driver']);
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
		data.destination = new FinishDataResultAllMessageDestination().fromJson(json['destination']);
	}
	if (json['M2'] != null) {
		data.m2 = json['M2']?.map((v) => v?.toString())?.toList()?.cast<String>();
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

Map<String, dynamic> finishDataResultAllMessageToJson(FinishDataResultAllMessage entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['constructionCompanyName'] = entity.constructionCompanyName;
	data['detailedRemarks'] = entity.detailedRemarks;
	data['projectAddress'] = entity.projectAddress;
	data['photoUrl_shunfeng'] = entity.photourlShunfeng;
	data['XK_NO'] = entity.xkNo;
	data['destinationName'] = entity.destinationName;
	data['carNo'] = entity.carNo;
	data['constructionSiteContactPerson'] = entity.constructionSiteContactPerson;
	data['arrivalTime'] = entity.arrivalTime;
	data['palletsNumber'] = entity.palletsNumber;
	data['containerNo'] = entity.containerNo;
	data['projectName'] = entity.projectName;
	data['ShippingWeight'] = entity.shippingWeight;
	data['supplierContactPhone'] = entity.supplierContactPhone;
	data['size'] = entity.size;
	data['waybill_ID'] = entity.waybillId;
	data['photoUrl_yunhuo'] = entity.photourlYunhuo;
	data['sendQuantity'] = entity.sendQuantity;
	data['BillingUnit'] = entity.billingUnit;
	data['status'] = entity.status;
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
	data['M2'] = entity.m2;
	data['objectId'] = entity.objectId;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	return data;
}

finishDataResultAllMessageDriverFromJson(FinishDataResultAllMessageDriver data, Map<String, dynamic> json) {
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

Map<String, dynamic> finishDataResultAllMessageDriverToJson(FinishDataResultAllMessageDriver entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['__type'] = entity.sType;
	data['className'] = entity.className;
	data['objectId'] = entity.objectId;
	return data;
}

finishDataResultAllMessageDestinationFromJson(FinishDataResultAllMessageDestination data, Map<String, dynamic> json) {
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

Map<String, dynamic> finishDataResultAllMessageDestinationToJson(FinishDataResultAllMessageDestination entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['__type'] = entity.sType;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	return data;
}