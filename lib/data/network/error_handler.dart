import 'package:advanced_flutter_app/data/network/failure.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      // default error
      failure = DataSource.unKnown.getFailure();
    }
  }
}

Failure _handleError(DioError dioError) {
  switch (dioError.type) {
    case DioErrorType.connectTimeout:
      return DataSource.connectTimeout.getFailure();
    case DioErrorType.sendTimeout:
      return DataSource.sendTimeout.getFailure();
    case DioErrorType.receiveTimeout:
      return DataSource.recieveTimeout.getFailure();
    case DioErrorType.response:
      if (dioError.response != null &&
          dioError.response?.statusCode != null &&
          dioError.response?.statusMessage != null) {
        return Failure(
            dioError.response!.statusCode!, dioError.response!.statusMessage!);
      } else {
        return DataSource.unKnown.getFailure();
      }

    case DioErrorType.cancel:
      return DataSource.cancel.getFailure();
    case DioErrorType.other:
      return DataSource.unKnown.getFailure();
  }
}

enum DataSource {
  success,
  noContent,
  badRequest,
  unauthorised,
  forbidden,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  recieveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  unKnown
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(ResponseCode.success, ResponseMessage.success);
      case DataSource.noContent:
        return Failure(ResponseCode.noContent, ResponseMessage.noContent);
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequest);
      case DataSource.unauthorised:
        return Failure(ResponseCode.unauthorised, ResponseMessage.unauthorised);
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden);
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound);
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            ResponseMessage.internalServerError);
      case DataSource.connectTimeout:
        return Failure(
            ResponseCode.connectTimeout, ResponseMessage.connectTimeout);
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case DataSource.recieveTimeout:
        return Failure(
            ResponseCode.recieveTimeout, ResponseMessage.recieveTimeout);
      case DataSource.sendTimeout:
        return Failure(ResponseCode.sendTimeout, ResponseMessage.sendTimeout);
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            ResponseMessage.noInternetConnection);
      case DataSource.unKnown:
        return Failure(ResponseCode.unKnown, ResponseMessage.unKnown);
    }
  }
}

class ResponseCode {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // failure, API rejected request
  static const int unauthorised = 401; // failure, use is not authorised
  static const int forbidden = 403; //  failure, API rejected request
  static const int notFound = 404; //  failure, not found
  static const int internalServerError = 500; // failure, crash in server side

  // local status code
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int recieveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int unKnown = -7;
}

class ResponseMessage {
  static String success = AppStrings.success.tr(); // success with data
  static String noContent =
      AppStrings.success.tr(); // success with no data (no content)
  static String badRequest =
      AppStrings.badRequest.tr(); // failure, API rejected request
  static String unauthorised =
      AppStrings.unauthorised.tr(); // failure, use is not authorised
  static String forbidden =
      AppStrings.forbidden.tr(); //  failure, API rejected request
  static String notFound = AppStrings.notFound.tr(); // failure, not found
  static String internalServerError =
      AppStrings.internalServerError.tr(); // failure, crash in server side

  // local status code
  static String connectTimeout = AppStrings.connectTimeout.tr();
  static String cancel = AppStrings.cancel.tr();
  static String recieveTimeout = AppStrings.connectTimeout.tr();
  static String sendTimeout = AppStrings.connectTimeout.tr();
  static String cacheError = AppStrings.cacheError.tr();
  static String noInternetConnection = AppStrings.noInternetConnection.tr();
  static String unKnown = AppStrings.unKnown.tr();
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}
