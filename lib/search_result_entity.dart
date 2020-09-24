import 'package:mydemo/generated/json/base/json_convert_content.dart';
import 'package:mydemo/generated/json/base/json_field.dart';

class SearchResultEntity with JsonConvert<SearchResultEntity> {
	List<SearchResultResult> result;
}

class SearchResultResult with JsonConvert<SearchResultResult> {
	String waybillID;
	String startLocationName;
	String constructionCompanyName;
	String supplierContactPerson;
	String destinationName;
	SearchResultResultDriverName driverName;
	String state;
	String projectName;
	@JSONField(name: "ConstructionUnit")
	String constructionUnit;
	int arrivalTime;
	int departureDate;
	@JSONField(name: "XK_NO")
	List<String> xkNo;
	List<String> billingColor;
	List<String> size;
	List<String> quantity;
	List<String> sendQuantity;
	@JSONField(name: "BillingUnit")
	List<String> billingUnit;
	List<String> unitPrice;
	List<String> detailedRemarks;
}

class SearchResultResultDriverName with JsonConvert<SearchResultResultDriverName> {
	String role;
	@JSONField(name: "ACL")
	SearchResultResultDriverNameACL aCL;
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

class SearchResultResultDriverNameACL with JsonConvert<SearchResultResultDriverNameACL> {
	@JSONField(name: "_owner")
	SearchResultResultDriverNameACLOwner sOwner;
}

class SearchResultResultDriverNameACLOwner with JsonConvert<SearchResultResultDriverNameACLOwner> {
	bool write;
	bool read;
}
