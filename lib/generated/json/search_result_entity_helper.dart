

import '../../search_result_entity.dart';


searchResultEntityFromJson(SearchResultEntity data, Map<String, dynamic> json) {
	if (json['result'] != null) {
		data.result = new List<SearchResultResult>();
		(json['result'] as List).forEach((v) {
			data.result.add(new SearchResultResult().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> searchResultEntityToJson(SearchResultEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.result != null) {
		data['result'] =  entity.result.map((v) => v.toJson()).toList();
	}
	return data;
}

searchResultResultFromJson(SearchResultResult data, Map<String, dynamic> json) {
	if (json['waybillID'] != null) {
		data.waybillID = json['waybillID']?.toString();
	}
	if (json['startLocationName'] != null) {
		data.startLocationName = json['startLocationName']?.toString();
	}
	if (json['constructionCompanyName'] != null) {
		data.constructionCompanyName = json['constructionCompanyName']?.toString();
	}
	if (json['supplierContactPerson'] != null) {
		data.supplierContactPerson = json['supplierContactPerson']?.toString();
	}
	if (json['destinationName'] != null) {
		data.destinationName = json['destinationName']?.toString();
	}
	if (json['driverName'] != null) {
		data.driverName = new SearchResultResultDriverName().fromJson(json['driverName']);
	}
	if (json['state'] != null) {
		data.state = json['state']?.toString();
	}
	if (json['projectName'] != null) {
		data.projectName = json['projectName']?.toString();
	}
	if (json['ConstructionUnit'] != null) {
		data.constructionUnit = json['ConstructionUnit']?.toString();
	}
	if (json['arrivalTime'] != null) {
		data.arrivalTime = json['arrivalTime']?.toInt();
	}
	if (json['departureDate'] != null) {
		data.departureDate = json['departureDate']?.toInt();
	}
	if (json['XK_NO'] != null) {
		data.xkNo = json['XK_NO']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['billingColor'] != null) {
		data.billingColor = json['billingColor']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['size'] != null) {
		data.size = json['size']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['quantity'] != null) {
		data.quantity = json['quantity']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['sendQuantity'] != null) {
		data.sendQuantity = json['sendQuantity']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['BillingUnit'] != null) {
		data.billingUnit = json['BillingUnit']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['unitPrice'] != null) {
		data.unitPrice = json['unitPrice']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	if (json['detailedRemarks'] != null) {
		data.detailedRemarks = json['detailedRemarks']?.map((v) => v?.toString())?.toList()?.cast<String>();
	}
	return data;
}

Map<String, dynamic> searchResultResultToJson(SearchResultResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['waybillID'] = entity.waybillID;
	data['startLocationName'] = entity.startLocationName;
	data['constructionCompanyName'] = entity.constructionCompanyName;
	data['supplierContactPerson'] = entity.supplierContactPerson;
	data['destinationName'] = entity.destinationName;
	if (entity.driverName != null) {
		data['driverName'] = entity.driverName.toJson();
	}
	data['state'] = entity.state;
	data['projectName'] = entity.projectName;
	data['ConstructionUnit'] = entity.constructionUnit;
	data['arrivalTime'] = entity.arrivalTime;
	data['departureDate'] = entity.departureDate;
	data['XK_NO'] = entity.xkNo;
	data['billingColor'] = entity.billingColor;
	data['size'] = entity.size;
	data['quantity'] = entity.quantity;
	data['sendQuantity'] = entity.sendQuantity;
	data['BillingUnit'] = entity.billingUnit;
	data['unitPrice'] = entity.unitPrice;
	data['detailedRemarks'] = entity.detailedRemarks;
	return data;
}

searchResultResultDriverNameFromJson(SearchResultResultDriverName data, Map<String, dynamic> json) {
	if (json['role'] != null) {
		data.role = json['role']?.toString();
	}
	if (json['ACL'] != null) {
		data.aCL = new SearchResultResultDriverNameACL().fromJson(json['ACL']);
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

Map<String, dynamic> searchResultResultDriverNameToJson(SearchResultResultDriverName entity) {
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

searchResultResultDriverNameACLFromJson(SearchResultResultDriverNameACL data, Map<String, dynamic> json) {
	if (json['_owner'] != null) {
		data.sOwner = new SearchResultResultDriverNameACLOwner().fromJson(json['_owner']);
	}
	return data;
}

Map<String, dynamic> searchResultResultDriverNameACLToJson(SearchResultResultDriverNameACL entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.sOwner != null) {
		data['_owner'] = entity.sOwner.toJson();
	}
	return data;
}

searchResultResultDriverNameACLOwnerFromJson(SearchResultResultDriverNameACLOwner data, Map<String, dynamic> json) {
	if (json['write'] != null) {
		data.write = json['write'];
	}
	if (json['read'] != null) {
		data.read = json['read'];
	}
	return data;
}

Map<String, dynamic> searchResultResultDriverNameACLOwnerToJson(SearchResultResultDriverNameACLOwner entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['write'] = entity.write;
	data['read'] = entity.read;
	return data;
}