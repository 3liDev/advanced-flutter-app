import 'package:advanced_flutter_app/app/app_prefs.dart';
import 'package:advanced_flutter_app/data/data_source/remote_data_source.dart';
import 'package:advanced_flutter_app/data/network/app_api.dart';
import 'package:advanced_flutter_app/data/network/dio_factory.dart';
import 'package:advanced_flutter_app/data/network/network_info.dart';
import 'package:advanced_flutter_app/data/repository/repository_impl.dart';
import 'package:advanced_flutter_app/domain/repository/repository.dart';
import 'package:advanced_flutter_app/domain/usecase/forgot_password_usecase.dart';
import 'package:advanced_flutter_app/domain/usecase/home_usecase.dart';
import 'package:advanced_flutter_app/domain/usecase/login_usecase.dart';
import 'package:advanced_flutter_app/domain/usecase/register_usecase.dart';
import 'package:advanced_flutter_app/domain/usecase/store_details_usecase.dart';
import 'package:advanced_flutter_app/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:advanced_flutter_app/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advanced_flutter_app/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/local_data_source.dart';
import '../presentation/register/viewmodel/register_viewmodel.dart';
import '../presentation/store_details/viewmodel/store_details_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

// Shared Preferences instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

// app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

// network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

// dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

// app service client
  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

// remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

// local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

// repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));

    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

initStoreDetailModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(instance()));
    instance.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(instance()));
  }
}
