import 'package:mydemo/generated/json/base/json_convert_content.dart';
import 'package:mydemo/generated/json/base/json_field.dart';

class WaybillEntity with JsonConvert<WaybillEntity> {
	List<WaybillResult> result;
}

class WaybillResult with JsonConvert<WaybillResult> {
	String constructionCompanyName;
	List<String> detailedRemarks;
	String projectAddress;
	@JSONField(name: "photoUrl_shunfeng")
	String photourlShunfeng;
	@JSONField(name: "XK_NO")
	List<String> xkNo;
	WaybillResultCar car;
	String color;
	int estimatedArrivalTime;
	String destinationName;
	String carNo;
	int amountInSquare;
	String constructionSiteContactPerson;
	int arrivalTime;
	List<String> palletsNumber;
	String containerNo;
	String projectName;
	WaybillResultSignedWaybillPhoto signedWaybillPhoto;
	@JSONField(name: "ShippingWeight")
	List<String> shippingWeight;
	String supplierContactPhone;
	List<String> size;
	@JSONField(name: "waybill_ID")
	String waybillId;
	@JSONField(name: "photoUrl_yunhuo")
	String photourlYunhuo;
	List<String> sendQuantity;
	@JSONField(name: "BillingUnit")
	List<String> billingUnit;
	String status;
	String projectOwnerCompanyName;
	String logisticsOrderNo;
	@JSONField(name: "ModeOfTransport")
	String modeOfTransport;
	@JSONField(name: "company_ID")
	String companyId;
	List<String> billingColor;
	String supplierContactPerson;
	int departureDate;
	String startLocationName;
	List<String> loadingRemarks;
	List<String> quantity;
	@JSONField(name: "client_ID")
	List<String> clientId;
	WaybillResultDriver driver;
	String constructionSiteContactPhone;
	@JSONField(name: "photoUrl_destination")
	String photourlDestination;
	List<String> materialsNumber;
	List<String> unitPrice;
	WaybillResultDestination destination;
	int arrivedAmount;
	@JSONField(name: "M2")
	List<String> m2;
	int amountInBlock;
	String objectId;
	String createdAt;
	String updatedAt;
}

class WaybillResultCar with JsonConvert<WaybillResultCar> {
	@JSONField(name: "__type")
	String sType;
	String className;
	String objectId;
}

class WaybillResultSignedWaybillPhoto with JsonConvert<WaybillResultSignedWaybillPhoto> {
	@JSONField(name: "__type")
	String sType;
	String className;
	String objectId;
}

class WaybillResultDriver with JsonConvert<WaybillResultDriver> {
	String role;
	String username;
	bool emailVerified;
	String mobilePhoneNumber;
	String identityNo;
	String company;
	bool mobilePhoneVerified;
	String objectId;
	String createdAt;
	String updatedAt;
}

class WaybillResultDestination with JsonConvert<WaybillResultDestination> {
	@JSONField(name: "__type")
	String sType;
	double latitude;
	double longitude;
}
