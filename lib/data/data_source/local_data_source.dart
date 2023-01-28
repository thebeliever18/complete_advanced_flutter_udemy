import 'package:complete_advanced_flutter/data/network/error_handler.dart';
import 'package:complete_advanced_flutter/data/responses/responses.dart';

const String cacheHomeKey = 'cacheHomeKey';
const cacheHomeInterval = 60 * 1000; //1 min in millisecond
const String cacheStoreDetailsKey = 'cacheStoreDetailsKey';
const cacheStoreDetailsInterval = 60 * 1000; //30s in millisecond
abstract class LocalDataSource{
  Future<HomeResponse> getHome();
  Future<void> saveHomeToCache(HomeResponse homeResponse);

  void clearCache();
  void removeFromCache(String key);

  Future<StoreDetailsResponse> getStoreDetails();
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse);
}

class LocalDataSourceImplementer implements LocalDataSource{


  //run time cache
  Map<String,CachedItem> cacheMap = Map();


  @override
  Future<HomeResponse> getHome() async{
    CachedItem? cachedItem = cacheMap[cacheHomeKey];

    if(cachedItem != null && cachedItem.isValid(cacheHomeInterval)){
      //return response from cache
      return cachedItem.data;
    }else{
      //return error cache is not valid
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }
  
  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async{
    cacheMap[cacheHomeKey] = CachedItem(homeResponse);
  }
  
  @override
  void clearCache() {
    cacheMap.clear();
  }
  
  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }
  
  @override
  Future<StoreDetailsResponse> getStoreDetails() async{
    CachedItem? cachedItem = cacheMap[cacheStoreDetailsKey];
    if(cachedItem != null && cachedItem.isValid(cacheStoreDetailsInterval)){
      return cachedItem.data;
    }else{
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }
  
  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse) async{
    cacheMap[cacheStoreDetailsKey] = CachedItem(storeDetailsResponse);
  }

}

class CachedItem{
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem{
  bool isValid(int expirationTime){
    //expirationTime is 60sec
    int currentTimeInMillis =  DateTime.now().millisecondsSinceEpoch; //time now is 1:00:00pm
    bool isCachedValid = currentTimeInMillis - expirationTime < cacheTime; //cache time was 12:59:30pm
    //false if current time > 1:00:30
    //true if current time < 1:00:30
    return isCachedValid;
  }
}