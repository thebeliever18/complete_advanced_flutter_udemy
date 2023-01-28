class SliderObjectModel{
  String title;
  String subTitle;
  String image;
  SliderObjectModel(this.title,this.subTitle,this.image);
}


class Customer{
  int id;
  String name;
  int numOfNotifications;
  Customer(this.id,this.name,this.numOfNotifications);
}

class Contacts{
  String email;
  String phone;
  String link;
  Contacts(this.email,this.phone,this.link);
}

class Authentication{
  Customer? customer;
  Contacts? contacts;
  Authentication(this.customer,this.contacts);
}

class DeviceInfo{
  String name;
  String identifier;
  String version;
  DeviceInfo(this.name,this.identifier,this.version);
}

class Services{
  int id;
  String title;
  String image;

  Services(this.id,this.title,this.image);

}

class Banners{
  int id;
  String title;
  String image;
  String link;

  Banners(this.id,this.title,this.image,this.link);
}

class Stores{
  int id;
  String title;
  String image;

  Stores(this.id,this.title,this.image);
}

class HomeData{
  List<Services> services;
  List<Stores> stores;
  List<Banners> banners;

  HomeData(this.services,this.stores,this.banners);
}

class HomeObject{
  HomeData data;
  HomeObject(this.data);
}

class StoreDetails{
  int id;
  String title;
  String image;
  String details;
  String services;
  String about;
  StoreDetails(this.id,this.title,this.image,this.details,this.services,this.about);
}
