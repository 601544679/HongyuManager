import 'package:mydemo/generated/json/base/json_convert_content.dart';
import 'package:mydemo/generated/json/base/json_field.dart';

class WaybillEntity with JsonConvert<WaybillEntity> {
	List<WaybillResult> result;
}

class WaybillResult with JsonConvert<WaybillResult> {
	@JSONField(name: "photoUrl_shunfeng")
	String photourlShunfeng;
	String destinationName;
	String constructionSiteContactPerson;
	int arrivalTime;
	String supplierContactPhone;
	@JSONField(name: "waybill_ID")
	String waybillId;
	@JSONField(name: "photoUrl_yunhuo")
	String photourlYunhuo;
	String status;
	@JSONField(name: "ModeOfTransport")
	String modeOfTransport;
	String supplierContactPerson;
	int departureDate;
	String startLocationName;
	WaybillResultDriver driver;
	String constructionSiteContactPhone;
	@JSONField(name: "photoUrl_destination")
	String photourlDestination;
	WaybillResultDestination destination;
	String objectId;
	String createdAt;
	String updatedAt;
	String constructionCompanyName;
	String projectAddress;
	String carNo;
	String projectName;
	@JSONField(name: "company_ID")
	String companyId;
	List<dynamic> unitPrice;
	List<String> detailedRemarks;
	@JSONField(name: "XK_NO")
	List<String> xkNo;
	List<String> palletsNumber;
	String containerNo;
	@JSONField(name: "ShippingWeight")
	List<String> shippingWeight;
	List<String> size;
	List<String> sendQuantity;
	@JSONField(name: "BillingUnit")
	List<String> billingUnit;
	String logisticsOrderNo;
	List<String> billingColor;
	List<String> loadingRemarks;
	List<String> quantity;
	@JSONField(name: "client_ID")
	List<String> clientId;
	List<String> materialsNumber;
	@JSONField(name: "M2")
	List<String> m2;

	@override
  String toString() {
    return 'WaybillResult{photourlShunfeng: $photourlShunfeng, destinationName: $destinationName, constructionSiteContactPerson: $constructionSiteContactPerson, arrivalTime: $arrivalTime, supplierContactPhone: $supplierContactPhone, waybillId: $waybillId, photourlYunhuo: $photourlYunhuo, status: $status, modeOfTransport: $modeOfTransport, supplierContactPerson: $supplierContactPerson, departureDate: $departureDate, startLocationName: $startLocationName, driver: $driver, constructionSiteContactPhone: $constructionSiteContactPhone, photourlDestination: $photourlDestination, destination: $destination, objectId: $objectId, createdAt: $createdAt, updatedAt: $updatedAt, constructionCompanyName: $constructionCompanyName, projectAddress: $projectAddress, carNo: $carNo, projectName: $projectName, companyId: $companyId, unitPrice: $unitPrice, detailedRemarks: $detailedRemarks, xkNo: $xkNo, palletsNumber: $palletsNumber, containerNo: $containerNo, shippingWeight: $shippingWeight, size: $size, sendQuantity: $sendQuantity, billingUnit: $billingUnit, logisticsOrderNo: $logisticsOrderNo, billingColor: $billingColor, loadingRemarks: $loadingRemarks, quantity: $quantity, clientId: $clientId, materialsNumber: $materialsNumber, m2: $m2}';
  }
}

class WaybillResultDriver with JsonConvert<WaybillResultDriver> {
	String role;
	@JSONField(name: "ACL")
	WaybillResultDriverACL aCL;
	String username;
	bool emailVerified;
	String mobilePhoneNumber;
	String identityNo;
	String company;
	bool mobilePhoneVerified;
	String objectId;
	String createdAt;
	String updatedAt;

	@override
  String toString() {
    return 'WaybillResultDriver{role: $role, aCL: $aCL, username: $username, emailVerified: $emailVerified, mobilePhoneNumber: $mobilePhoneNumber, identityNo: $identityNo, company: $company, mobilePhoneVerified: $mobilePhoneVerified, objectId: $objectId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class WaybillResultDriverACL with JsonConvert<WaybillResultDriverACL> {
	@JSONField(name: "_owner")
	WaybillResultDriverACLOwner wOwner;
}

class WaybillResultDriverACLOwner with JsonConvert<WaybillResultDriverACLOwner> {
	bool write;
	bool read;
}

class WaybillResultDestination with JsonConvert<WaybillResultDestination> {
	@JSONField(name: "__type")
	String sType;
	double latitude;
	double longitude;
}
