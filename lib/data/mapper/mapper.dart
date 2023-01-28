import 'dart:developer';

import 'package:complete_advanced_flutter/app/extensions.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:flutter/cupertino.dart';


const empty = "";
const zero = 0;

extension CustomerResponseMapper on CustomerResponse?{
  Customer toDomain(){
    return Customer(this?.id.orZero() ?? zero, this?.message?.orEmpty() ?? empty, this?.numOfNotifications?.orZero() ?? zero);
  }
}

extension ContactResponseMapper on ContactResponse?{
  Contacts toDomain(){
    return Contacts(this?.email?.orEmpty() ?? empty,this?.phone.orEmpty() ?? empty, this?.link.orEmpty() ?? empty);
  }
}


extension AuthenticationResponseMapper on AuthenticationResponse?{
  Authentication toDomain(){
    return Authentication(this?.customer?.toDomain(),this?.contacts?.toDomain());
  }
}

extension ForgetPasswordResponseMapper on ForgetPasswordResponse?{
  String toDomain(){
    return this?.support?.orEmpty() ?? empty;
  }
}


extension ServiceResponseMapper on ServiceResponse?{
  Services toDomain(){
    return Services(this?.id?.orZero() ?? zero, this?.title?.orEmpty() ?? empty, this?.image?.orEmpty() ?? empty);
  }
}

extension StoreResponseMapper on StoresResponse?{
  Stores toDomain(){
    return Stores(this?.id?.orZero() ?? zero, this?.title?.orEmpty() ?? empty, this?.image?.orEmpty() ?? empty);
  }
}

extension BannerResponseMapper on BannersResponse?{
  Banners toDomain(){
       return Banners(this?.id?.orZero() ?? zero, this?.title?.orEmpty() ?? empty, this?.image?.orEmpty() ?? empty,this?.link?.orEmpty() ?? empty);
  }
}

extension HomeResponseMapper on HomeResponse?{
  HomeObject toDomain(){
    List<Services> mappedServices = 
    (this?.data?.serviceResponse?.map((service) => service.toDomain()) ?? const Iterable.empty()).cast<Services>().toList();

    List<Stores> mappedStores = 
    (this?.data?.storesResponse?.map((stores) => stores.toDomain()) ?? const Iterable.empty()).cast<Stores>().toList();

    List<Banners> mappedBanners = 
    (this?.data?.bannersResponse?.map((banners) => banners.toDomain()) ?? const Iterable.empty()).cast<Banners>().toList();

    var data = HomeData(mappedServices, mappedStores, mappedBanners);

    return HomeObject(data);
  }
}

extension StoreDetailsResponseMapper on StoreDetailsResponse?{
  StoreDetails toDomain(){
    return StoreDetails(
      this?.id.orZero() ?? zero, 
      this?.title.orEmpty() ?? empty, 
      this?.image.orEmpty() ?? empty, 
      this?.details.orEmpty() ?? empty, 
      this?.services.orEmpty() ?? empty, 
      this?.about.orEmpty() ?? empty);
  }
}



