import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/app/extension.dart';
import '../../app/constants.dart';
import '../response/responses.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomainCustomer() {
    return Customer(
        this?.id.orEmpty() ?? Constants.empty,
        this?.name.orEmpty() ?? Constants.empty,
        this?.numOfNotification.orZero() ?? Constants.zero);
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomainContacts() {
    return Contacts(
        this?.phone.orEmpty() ?? Constants.empty,
        this?.email.orEmpty() ?? Constants.empty,
        this?.link.orEmpty() ?? Constants.empty);
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomainAuthentication() {
    return Authentication(
        this?.customer.toDomainCustomer(), this?.contacts.toDomainContacts());
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  String toDomainForgotPassword() {
    return this?.support?.orEmpty() ?? Constants.empty;
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomainService() {
    return Service(
        this?.id.orZero() ?? Constants.zero,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension BannersResponseMapper on BannersResponse? {
  BannerAd toDomainBanner() {
    return BannerAd(
        this?.id.orZero() ?? Constants.zero,
        this?.link.orEmpty() ?? Constants.empty,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension StoreResponseMapper on StoreResponse? {
  Store toDomainStore() {
    return Store(
        this?.id.orZero() ?? Constants.zero,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty);
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomainHome() {
    List<Service> services = (this
                ?.data
                ?.services
                ?.map((serviceResponse) => serviceResponse.toDomainService()) ??
            const Iterable.empty())
        .cast<Service>()
        .toList();
    List<BannerAd> banners = (this
                ?.data
                ?.banners
                ?.map((bannerResponse) => bannerResponse.toDomainBanner()) ??
            const Iterable.empty())
        .cast<BannerAd>()
        .toList();
    List<Store> stores = (this
                ?.data
                ?.stores
                ?.map((storeResponse) => storeResponse.toDomainStore()) ??
            const Iterable.empty())
        .cast<Store>()
        .toList();

    var data = HomeData(services, banners, stores);
    return HomeObject(data);
  }
}

extension StoreDetailsResponseMapper on StoreDetailsResponse? {
  StoreDetails toDomainStoreDetails() {
    return StoreDetails(
        this?.id.orZero() ?? Constants.zero,
        this?.title.orEmpty() ?? Constants.empty,
        this?.image.orEmpty() ?? Constants.empty,
        this?.details.orEmpty() ?? Constants.empty,
        this?.services.orEmpty() ?? Constants.empty,
        this?.about.orEmpty() ?? Constants.empty);
  }
}
