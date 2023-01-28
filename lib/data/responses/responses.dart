import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'responses.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: 'status')
  int? statusCode;

  @JsonKey(name: 'message')
  String? message;
}

@JsonSerializable()
class CustomerResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? message;

  @JsonKey(name: 'numOfNotifications')
  int? numOfNotifications;
  CustomerResponse(this.id, this.message, this.numOfNotifications);

  //from json
  factory CustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerResponseFromJson(json);

  //to json
  Map<String, dynamic> toJson() => _$CustomerResponseToJson(this);
}

@JsonSerializable()
class ContactResponse {
  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'link')
  String? link;
  ContactResponse(this.email, this.phone, this.link);

  //from json
  factory ContactResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactResponseFromJson(json);

  //to json
  Map<String, dynamic> toJson() => _$ContactResponseToJson(this);
}

@JsonSerializable()
class AuthenticationResponse extends BaseResponse {
  @JsonKey(name: 'customer')
  CustomerResponse? customer;

  @JsonKey(name: 'contacts')
  ContactResponse? contacts;

  AuthenticationResponse(this.customer, this.contacts);

  //from json
  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  //to json
  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}

@JsonSerializable()
class ForgetPasswordResponse extends BaseResponse {
  @JsonKey(name: 'support')
  String? support;

  ForgetPasswordResponse(this.support);

  //to json
  Map<String, dynamic> toJson() => _$ForgetPasswordResponseToJson(this);

  //fromJson
  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);
}

@JsonSerializable()
class ServiceResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'image')
  String? image;

  ServiceResponse(this.id, this.title, this.image);

  //tojson
  Map<String, dynamic> toJson() => _$ServiceResponseToJson(this);

  //from json
  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseFromJson(json);
}

@JsonSerializable()
class StoresResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'image')
  String? image;

  StoresResponse(this.id, this.title, this.image);

  //tojson
  Map<String, dynamic> toJson() => _$StoresResponseToJson(this);

  //from json
  factory StoresResponse.fromJson(Map<String, dynamic> json) =>
      _$StoresResponseFromJson(json);
}

@JsonSerializable()
class BannersResponse {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'image')
  String? image;

  @JsonKey(name: 'link')
  String? link;

  BannersResponse(this.id, this.title, this.image, this.link);

  //tojson
  Map<String, dynamic> toJson() => _$BannersResponseToJson(this);

  //from json
  factory BannersResponse.fromJson(Map<String, dynamic> json) =>
      _$BannersResponseFromJson(json);
}

@JsonSerializable()
class HomeDataResponse {
  @JsonKey(name: 'services')
  List<ServiceResponse>? serviceResponse;

  @JsonKey(name: 'stores')
  List<StoresResponse?> storesResponse;

  @JsonKey(name: 'banners')
  List<BannersResponse>? bannersResponse;

  HomeDataResponse(
      this.serviceResponse, this.storesResponse, this.bannersResponse);

  //tojson
  Map<String, dynamic> toJson() => _$HomeDataResponseToJson(this);

  //from json
  factory HomeDataResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeDataResponseFromJson(json);
}

@JsonSerializable()
class HomeResponse extends BaseResponse {
  @JsonKey(name: 'data')
  HomeDataResponse? data;
  HomeResponse(this.data);

  //tojson
  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);

  //from json
  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);
}

// @JsonSerializable()
// class StoreDetailsResponse extends BaseResponse{
//   @JsonKey(name: 'id')
//   int? id;

//   @JsonKey(name: 'title')
//   String? title;

//   @JsonKey(name: 'image')
//   String? image;

//   @JsonKey(name: 'details')
//   String? details;

//   @JsonKey(name: 'services')
//   String? services;

//   @JsonKey(name: 'about')
//   String? about;

//   StoreDetailsResponse(
//       this.id, this.title, this.image, this.details, this.services, this.about);

//       //tojson

//       Map<String,dynamic> toJson => _$StoreDetailsResponseToJson(this);

//       //from json

//       factory StoreDetailsResponse.fromJson(Map<String,dynamic> json) => _$StoreDetailsResponseFromJson(json);
// }

@JsonSerializable()
class StoreDetailsResponse extends BaseResponse{
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'image')
  String? image;
  @JsonKey(name: 'details')
  String? details;
  @JsonKey(name: 'services')
  String? services;
  @JsonKey(name: 'about')
  String? about;

  StoreDetailsResponse(this.id, this.title, this.image,this.details, this.services, this.about);

  factory StoreDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoreDetailsResponseToJson(this);
}
