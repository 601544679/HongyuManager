import 'package:mydemo/generated/json/base/json_convert_content.dart';
import 'package:mydemo/generated/json/base/json_field.dart';

class FinishDataEntity with JsonConvert<FinishDataEntity> {
	FinishDataResult result;
}

class FinishDataResult with JsonConvert<FinishDataResult> {
	List<String> imageUrl;
	FinishDataResultAllMessage allMessage;
}

class FinishDataResultAllMessage with JsonConvert<FinishDataResultAllMessage> {
	String constructionCompanyName;
	List<String> detailedRemarks;
	String projectAddress;
	@JSONField(name: "photoUrl_shunfeng")
	String photourlShunfeng;
	@JSONField(name: "XK_NO")
	List<String> xkNo;
	String destinationName;
	String carNo;
	String constructionSiteContactPerson;
	int arrivalTime;
	List<String> palletsNumber;
	String containerNo;
	String projectName;
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
	FinishDataResultAllMessageDriver driver;
	String constructionSiteContactPhone;
	@JSONField(name: "photoUrl_destination")
	String photourlDestination;
	List<String> materialsNumber;
	List<String> unitPrice;
	FinishDataResultAllMessageDestination destination;
	@JSONField(name: "M2")
	List<String> m2;
	String objectId;
	String createdAt;
	String updatedAt;
}

class FinishDataResultAllMessageDriver with JsonConvert<FinishDataResultAllMessageDriver> {
	@JSONField(name: "__type")
	String sType;
	String className;
	String objectId;
}

class FinishDataResultAllMessageDestination with JsonConvert<FinishDataResultAllMessageDestination> {
	@JSONField(name: "__type")
	String sType;
	double latitude;
	double longitude;
}
