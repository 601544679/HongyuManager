// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:mydemo/finish_data_entity.dart';
import 'package:mydemo/generated/json/finish_data_entity_helper.dart';
import 'package:mydemo/waybill_entity.dart';
import 'package:mydemo/generated/json/waybill_entity_helper.dart';
import 'package:mydemo/search_result_entity.dart';
import 'package:mydemo/generated/json/search_result_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {			case FinishDataEntity:
			return finishDataEntityFromJson(data as FinishDataEntity, json) as T;			case FinishDataResult:
			return finishDataResultFromJson(data as FinishDataResult, json) as T;			case FinishDataResultAllMessage:
			return finishDataResultAllMessageFromJson(data as FinishDataResultAllMessage, json) as T;			case FinishDataResultAllMessageDriver:
			return finishDataResultAllMessageDriverFromJson(data as FinishDataResultAllMessageDriver, json) as T;			case FinishDataResultAllMessageDestination:
			return finishDataResultAllMessageDestinationFromJson(data as FinishDataResultAllMessageDestination, json) as T;			case WaybillEntity:
			return waybillEntityFromJson(data as WaybillEntity, json) as T;			case WaybillResult:
			return waybillResultFromJson(data as WaybillResult, json) as T;			case WaybillResultCar:
			return waybillResultCarFromJson(data as WaybillResultCar, json) as T;			case WaybillResultSignedWaybillPhoto:
			return waybillResultSignedWaybillPhotoFromJson(data as WaybillResultSignedWaybillPhoto, json) as T;			case WaybillResultDriver:
			return waybillResultDriverFromJson(data as WaybillResultDriver, json) as T;			case WaybillResultDestination:
			return waybillResultDestinationFromJson(data as WaybillResultDestination, json) as T;			case SearchResultEntity:
			return searchResultEntityFromJson(data as SearchResultEntity, json) as T;			case SearchResultResult:
			return searchResultResultFromJson(data as SearchResultResult, json) as T;			case SearchResultResultDriverName:
			return searchResultResultDriverNameFromJson(data as SearchResultResultDriverName, json) as T;			case SearchResultResultDriverNameACL:
			return searchResultResultDriverNameACLFromJson(data as SearchResultResultDriverNameACL, json) as T;			case SearchResultResultDriverNameACLOwner:
			return searchResultResultDriverNameACLOwnerFromJson(data as SearchResultResultDriverNameACLOwner, json) as T;    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
		switch (type) {			case FinishDataEntity:
			return finishDataEntityToJson(data as FinishDataEntity);			case FinishDataResult:
			return finishDataResultToJson(data as FinishDataResult);			case FinishDataResultAllMessage:
			return finishDataResultAllMessageToJson(data as FinishDataResultAllMessage);			case FinishDataResultAllMessageDriver:
			return finishDataResultAllMessageDriverToJson(data as FinishDataResultAllMessageDriver);			case FinishDataResultAllMessageDestination:
			return finishDataResultAllMessageDestinationToJson(data as FinishDataResultAllMessageDestination);			case WaybillEntity:
			return waybillEntityToJson(data as WaybillEntity);			case WaybillResult:
			return waybillResultToJson(data as WaybillResult);			case WaybillResultCar:
			return waybillResultCarToJson(data as WaybillResultCar);			case WaybillResultSignedWaybillPhoto:
			return waybillResultSignedWaybillPhotoToJson(data as WaybillResultSignedWaybillPhoto);			case WaybillResultDriver:
			return waybillResultDriverToJson(data as WaybillResultDriver);			case WaybillResultDestination:
			return waybillResultDestinationToJson(data as WaybillResultDestination);			case SearchResultEntity:
			return searchResultEntityToJson(data as SearchResultEntity);			case SearchResultResult:
			return searchResultResultToJson(data as SearchResultResult);			case SearchResultResultDriverName:
			return searchResultResultDriverNameToJson(data as SearchResultResultDriverName);			case SearchResultResultDriverNameACL:
			return searchResultResultDriverNameACLToJson(data as SearchResultResultDriverNameACL);			case SearchResultResultDriverNameACLOwner:
			return searchResultResultDriverNameACLOwnerToJson(data as SearchResultResultDriverNameACLOwner);    }
    return data as T;
  }
  //Go back to a single instance by type
  static _fromJsonSingle(String type, json) {
    switch (type) {			case 'FinishDataEntity':
			return FinishDataEntity().fromJson(json);			case 'FinishDataResult':
			return FinishDataResult().fromJson(json);			case 'FinishDataResultAllMessage':
			return FinishDataResultAllMessage().fromJson(json);			case 'FinishDataResultAllMessageDriver':
			return FinishDataResultAllMessageDriver().fromJson(json);			case 'FinishDataResultAllMessageDestination':
			return FinishDataResultAllMessageDestination().fromJson(json);			case 'WaybillEntity':
			return WaybillEntity().fromJson(json);			case 'WaybillResult':
			return WaybillResult().fromJson(json);			case 'WaybillResultCar':
			return WaybillResultCar().fromJson(json);			case 'WaybillResultSignedWaybillPhoto':
			return WaybillResultSignedWaybillPhoto().fromJson(json);			case 'WaybillResultDriver':
			return WaybillResultDriver().fromJson(json);			case 'WaybillResultDestination':
			return WaybillResultDestination().fromJson(json);			case 'SearchResultEntity':
			return SearchResultEntity().fromJson(json);			case 'SearchResultResult':
			return SearchResultResult().fromJson(json);			case 'SearchResultResultDriverName':
			return SearchResultResultDriverName().fromJson(json);			case 'SearchResultResultDriverNameACL':
			return SearchResultResultDriverNameACL().fromJson(json);			case 'SearchResultResultDriverNameACLOwner':
			return SearchResultResultDriverNameACLOwner().fromJson(json);    }
    return null;
  }

  //empty list is returned by type
  static _getListFromType(String type) {
    switch (type) {			case 'FinishDataEntity':
			return List<FinishDataEntity>();			case 'FinishDataResult':
			return List<FinishDataResult>();			case 'FinishDataResultAllMessage':
			return List<FinishDataResultAllMessage>();			case 'FinishDataResultAllMessageDriver':
			return List<FinishDataResultAllMessageDriver>();			case 'FinishDataResultAllMessageDestination':
			return List<FinishDataResultAllMessageDestination>();			case 'WaybillEntity':
			return List<WaybillEntity>();			case 'WaybillResult':
			return List<WaybillResult>();			case 'WaybillResultCar':
			return List<WaybillResultCar>();			case 'WaybillResultSignedWaybillPhoto':
			return List<WaybillResultSignedWaybillPhoto>();			case 'WaybillResultDriver':
			return List<WaybillResultDriver>();			case 'WaybillResultDestination':
			return List<WaybillResultDestination>();			case 'SearchResultEntity':
			return List<SearchResultEntity>();			case 'SearchResultResult':
			return List<SearchResultResult>();			case 'SearchResultResultDriverName':
			return List<SearchResultResultDriverName>();			case 'SearchResultResultDriverNameACL':
			return List<SearchResultResultDriverNameACL>();			case 'SearchResultResultDriverNameACLOwner':
			return List<SearchResultResultDriverNameACLOwner>();    }
    return null;
  }

  static M fromJsonAsT<M>(json) {
    String type = M.toString();
    if (json is List && type.contains("List<")) {
      String itemType = type.substring(5, type.length - 1);
      List tempList = _getListFromType(itemType);
      json.forEach((itemJson) {
        tempList
            .add(_fromJsonSingle(type.substring(5, type.length - 1), itemJson));
      });
      return tempList as M;
    } else {
      return _fromJsonSingle(M.toString(), json) as M;
    }
  }
}