import 'package:advanced_flutter_app/data/data_source/local_data_source.dart';
import 'package:advanced_flutter_app/data/data_source/remote_data_source.dart';
import 'package:advanced_flutter_app/data/mapper/mapper.dart';
import 'package:advanced_flutter_app/data/network/error_handler.dart';
import 'package:advanced_flutter_app/data/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/data/network/requests.dart';
import 'package:advanced_flutter_app/data/network/failure.dart';
import '../../domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet , its safe to call API

      try {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternalStatus.success) {
          // success
          // return  either right
          // return data
          return Right(response.toDomainAuthentication());
        } else {
          // failure -- return business error
          // return either left
          return Left(
              Failure(ApiInternalStatus.failure, response.message ?? ResponseMessage.unKnown));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await _remoteDataSource.forgotPassword(email);

        if (response.status == ApiInternalStatus.success) {
          // success
          // return  either right
          // return data
          return Right(response.toDomainForgotPassword());
        } else {
          // failure -- return business error
          // return either left
          return Left(Failure(response.status ?? ResponseCode.unKnown,
              response.message ?? ResponseMessage.unKnown));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet , its safe to call API

      try {
        final response = await _remoteDataSource.register(registerRequest);

        if (response.status == ApiInternalStatus.success) {
          // success
          // return  either right
          // return data
          return Right(response.toDomainAuthentication());
        } else {
          // failure -- return business error
          // return either left
          return Left(
              Failure(ApiInternalStatus.failure, response.message ?? ResponseMessage.unKnown));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      // get response from cache
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomainHome());
    } catch (cacheError) {
      // cache is not existing or cache is not valid

      // its the time to get from API side
      if (await _networkInfo.isConnected) {
        // its connected to internet , its safe to call API

        try {
          final response = await _remoteDataSource.getHomeData();

          if (response.status == ApiInternalStatus.success) {
            // success
            // return  either right
            // return data
            // save home response to cache
            // save response in cache (local data source)
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomainHome());
          } else {
            // failure -- return business error
            // return either left
            return Left(
                Failure(ApiInternalStatus.failure, response.message ?? ResponseMessage.unKnown));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return internet connection error
        // return either left
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async {
    try {
      // get data from cache
      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomainStoreDetails());
    } catch (cacheError) {
      // cache is not existing or cache is not valid

      // its the time to get from API side
      if (await _networkInfo.isConnected) {
        // its connected to internet , its safe to call API

        try {
          final response = await _remoteDataSource.getStoreDetails();

          if (response.status == ApiInternalStatus.success) {
            // success
            // return  either right
            // return data
            // save home response to cache
            // save response in cache (local data source)
            _localDataSource.saveStoreDetailsToCache(response);
            return Right(response.toDomainStoreDetails());
          } else {
            // failure -- return business error
            // return either left
            return Left(
                Failure(ApiInternalStatus.failure, response.message ?? ResponseMessage.unKnown));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return internet connection error
        // return either left
        return Left(DataSource.noInternetConnection.getFailure());
      }
    }
  }
}
