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
	if (json['photoUrl_shunfeng'] != null) {
		data.photourlShunfeng = json['photoUrl_shunfeng']?.toString();
	}
	if (json['destinationName'] != null) {
		data.destinationName = json['destinationName']?.toString();
	}
	if (json['constructionSiteContactPerson'] != null) {
		data.constructionSiteContactPerson = json['constructionSiteContactPerson']?.toString();
	}
	if (json['arrivalTime'] != null) {
		data.arrivalTime = json['arrivalTime']?.toInt();
	}
	if (json['supplierContactPhone'] != null) {
		data.supplierContactPhone = json['supplierContactPhone']?.toString();
	}
	if (json['waybill_ID'] != null) {
		data.waybillId = json['waybill_ID']?.toString();
	}
	if (json['photoUrl_yunhuo'] != null) {
		data.photourlYunhuo = json['photoUrl_yunhuo']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['ModeOfTransport'] != null) {
		data.modeOfTransport = json['ModeOfTransport']?.toString();
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
	if (json['driver'] != null) {
		data.driver = new WaybillResultDriver().fromJson(json['driver']);
	}
	if (json['constructionSiteContactPhone'] != null) {
		data.constructionSiteContactPhone = json['constructionSiteContactPhone']?.toString();
	}
	if (json['photoUrl_destination'] != null) {
		data.photourlDestination = json['photoUrl_destination']?.toString();
	}
	if (json['destination'] != null) {
		data.destination = new WaybillResultDestination().fromJson(json['destination']);
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
	if (json['constructionCompanyName'] != null) {
		data.constructionCompanyName = json['constructionCompanyName']?.toString();
	}
	if (json['projectAddress'] != null) {
		data.projectAddress = json['projectAddress']?.toString();
	}
	if (json['carNo'] != null) {
		data.carNo = json['carNo']?.toString();
	}
	if (json['projectName'] != null) {
		data.projectName = json['projectName']?.toString();
	}
	if (json['company_ID'] != null) {
		data.companyId = json['company_ID']?.toString();
	}
	if (json['unitPrice'] != null) {
		data.unitPrice = new List<dynamic>();
		data.unitPrice.addAll(json['unitPrice']);
	}
	if (json['detailedRemarks'] != null) {
		data.detailedRemarks = json['detailedRemarks']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['XK_NO'] != null) {
		data.xkNo = json['XK_NO']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['palletsNumber'] != null) {
		data.palletsNumber = json['palletsNumber']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['containerNo'] != null) {
		data.containerNo = json['containerNo']?.toString();
	}
	if (json['ShippingWeight'] != null) {
		data.shippingWeight = json['ShippingWeight']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['size'] != null) {
		data.size = json['size']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['sendQuantity'] != null) {
		data.sendQuantity = json['sendQuantity']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['BillingUnit'] != null) {
		data.billingUnit = json['BillingUnit']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['logisticsOrderNo'] != null) {
		data.logisticsOrderNo = json['logisticsOrderNo']?.toString();
	}
	if (json['billingColor'] != null) {
		data.billingColor = json['billingColor']?.map((v) => v?.toString())?.toList()?.cast<String>();
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
	if (json['materialsNumber'] != null) {
		data.materialsNumber = json['materialsNumber']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['M2'] != null) {
		data.m2 = json['M2']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	return data;
}

Map<String, dynamic> waybillResultToJson(WaybillResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['photoUrl_shunfeng'] = entity.photourlShunfeng;
	data['destinationName'] = entity.destinationName;
	data['constructionSiteContactPerson'] = entity.constructionSiteContactPerson;
	data['arrivalTime'] = entity.arrivalTime;
	data['supplierContactPhone'] = entity.supplierContactPhone;
	data['waybill_ID'] = entity.waybillId;
	data['photoUrl_yunhuo'] = entity.photourlYunhuo;
	data['status'] = entity.status;
	data['ModeOfTransport'] = entity.modeOfTransport;
	data['supplierContactPerson'] = entity.supplierContactPerson;
	data['departureDate'] = entity.departureDate;
	data['startLocationName'] = entity.startLocationName;
	if (entity.driver != null) {
		data['driver'] = entity.driver.toJson();
	}
	data['constructionSiteContactPhone'] = entity.constructionSiteContactPhone;
	data['photoUrl_destination'] = entity.photourlDestination;
	if (entity.destination != null) {
		data['destination'] = entity.destination.toJson();
	}
	data['objectId'] = entity.objectId;
	data['createdAt'] = entity.createdAt;
	data['updatedAt'] = entity.updatedAt;
	data['constructionCompanyName'] = entity.constructionCompanyName;
	data['projectAddress'] = entity.projectAddress;
	data['carNo'] = entity.carNo;
	data['projectName'] = entity.projectName;
	data['company_ID'] = entity.companyId;
	if (entity.unitPrice != null) {
		data['unitPrice'] =  [];
	}
	data['detailedRemarks'] = entity.detailedRemarks;
	data['XK_NO'] = entity.xkNo;
	data['palletsNumber'] = entity.palletsNumber;
	data['containerNo'] = entity.containerNo;
	data['ShippingWeight'] = entity.shippingWeight;
	data['size'] = entity.size;
	data['sendQuantity'] = entity.sendQuantity;
	data['BillingUnit'] = entity.billingUnit;
	data['logisticsOrderNo'] = entity.logisticsOrderNo;
	data['billingColor'] = entity.billingColor;
	data['loadingRemarks'] = entity.loadingRemarks;
	data['quantity'] = entity.quantity;
	data['client_ID'] = entity.clientId;
	data['materialsNumber'] = entity.materialsNumber;
	data['M2'] = entity.m2;
	return data;
}

waybillResultDriverFromJson(WaybillResultDriver data, Map<String, dynamic> json) {
	if (json['role'] != null) {
		data.role = json['role']?.toString();
	}
	if (json['ACL'] != null) {
		data.aCL = new WaybillResultDriverACL().fromJson(json['ACL']);
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
	if (entity.aCL != null) {
		data['ACL'] = entity.aCL.toJson();
	}
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

waybillResultDriverACLFromJson(WaybillResultDriverACL data, Map<String, dynamic> json) {
	if (json['_owner'] != null) {
		data.wOwner = new WaybillResultDriverACLOwner().fromJson(json['_owner']);
	}
	return data;
}

Map<String, dynamic> waybillResultDriverACLToJson(WaybillResultDriverACL entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.wOwner != null) {
		data['_owner'] = entity.wOwner.toJson();
	}
	return data;
}

waybillResultDriverACLOwnerFromJson(WaybillResultDriverACLOwner data, Map<String, dynamic> json) {
	if (json['write'] != null) {
		data.write = json['write'];
	}
	if (json['read'] != null) {
		data.read = json['read'];
	}
	return data;
}

Map<String, dynamic> waybillResultDriverACLOwnerToJson(WaybillResultDriverACLOwner entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['write'] = entity.write;
	data['read'] = entity.read;
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