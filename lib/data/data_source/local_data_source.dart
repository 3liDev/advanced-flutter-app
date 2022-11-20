import 'package:advanced_flutter_app/data/network/error_handler.dart';

import '../response/responses.dart';

const cacheHomeKey = "CACHE_HOME_KEY";
const cacheHomeInterval = 60000; // 1 minute cache in millis
const cacheStoreDetailsKey = "CACHE_STORE_DETAILS_KEY";
const cacheStoreDetailsInterval = 60000; // 1 minute cache in millis

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();

  Future<void> saveHomeToCache(HomeResponse homeResponse);

  void clearCache();
  void removeFromCache(String key);

  Future<StoreDetailsResponse> getStoreDetails();

  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response);
}

class LocalDataSourceImpl implements LocalDataSource {
  // run time cache
  Map<String, CachedItem> cacheMap = <String, CachedItem>{};

  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cachedItem = cacheMap[cacheHomeKey];

    if (cachedItem != null && cachedItem.isValid(cacheHomeInterval)) {
      // return the response from cache
      return cachedItem.data;
    } else {
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
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
  Future<StoreDetailsResponse> getStoreDetails() async {
    CachedItem? cachedItem = cacheMap[cacheStoreDetailsKey];

    if (cachedItem != null && cachedItem.isValid(cacheStoreDetailsInterval)) {
      // return the response from cache
      return cachedItem.data;
    } else {
      // return an error that cache is not there or its not valid
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response) async {
    cacheMap[cacheStoreDetailsKey] = CachedItem(response);
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTimeInMillis) {
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;

    bool isValid = currentTimeInMillis - cacheTime <= expirationTimeInMillis;

    return isValid;
  }
}
