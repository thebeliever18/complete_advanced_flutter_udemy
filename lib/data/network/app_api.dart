import 'dart:convert';

import 'package:complete_advanced_flutter/app/constant.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient{
  factory AppServiceClient(Dio dio,{String baseUrl}) = _AppServiceClient;

  @POST("/customer/login")
  Future<AuthenticationResponse> login(
    @Field('email') String email,
    @Field('password') String password,
    @Field('imei') String imei,
    @Field('deviceType') String deviceType
  );

  @POST("/customer/forgetPassword")
  Future<ForgetPasswordResponse> forgotPassword(@Field('email') String email);

  @POST('/customer/register')
  Future<AuthenticationResponse> register(
    @Field('country_mobile_code') String countryMobileCode,
    @Field('user_name') String userName,
    @Field('email') String email,
    @Field('password') String password,
    @Field('mobile_number') String mobileNumber,
    @Field('profile_picture') String profilePicture,
  );

  @GET("/home")
  Future<HomeResponse> getHome();

  @GET("/storeDetails/1")
  Future<StoreDetailsResponse> getStoreDetails();

}