import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorised,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  recieveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  unknown
}

class ResponseCode {
  //API status code
  static const int success = 200; //success with data
  static const int noContent = 201; //success with no content
  static const int badRequest = 400; //failure, api rejected request
  static const int forbidden = 403; //failure, api rejected request
  static const int unauthorised = 401; //failure user is not authorised
  static const int notFound = 404; //failure url is not correct and not found
  static const int internalServerError =
      500; //failure, crash happened in the server side

  //local status code
  static const int unknown = -1;
  static const int connectTimeout = -2;
  static const int cancel = -3;
  static const int recieveTimeout = -4;
  static const int sendTimeout = -5;
  static const int cacheError = -6;
  static const int noInternetConnection = -7;
}

class ResponseMessage {
  // API status codes
  // API response codes
  static const String success = AppStrings.success; // success with data
  static const String noContent =
      AppStrings.noContent; // success with no content
  static const String badRequest =
      AppStrings.badRequestError; // failure, api rejected our request
  static const String forbidden =
      AppStrings.forbiddenError; // failure,  api rejected our request
  static const String unauthorised =
      AppStrings.unauthorizedError; // failure, user is not authorised
  static const String notFound = AppStrings
      .notFoundError; // failure, API url is not correct and not found in api side.
  static const String internalServerError =
      AppStrings.internalServerError; // failure, a crash happened in API side.

  // local responses codes
  static const String unknown =
      AppStrings.defaultError; // unknown error happened
  static const String connectTimeout =
      AppStrings.timeoutError; // issue in connectivity
  static const String cancel =
      AppStrings.defaultError; // API request was cancelled
  static const String recieveTimeout =
      AppStrings.timeoutError; //  issue in connectivity
  static const String sendTimeout =
      AppStrings.timeoutError; //  issue in connectivity
  static const String cacheError = AppStrings
      .defaultError; //  issue in getting data from local data source (cache)
  static const String noInternetConnection =
      AppStrings.noInternetError; // issue in connectivity
}

// class ResponseMessage {
//   //API status code
//   static const String success = "Success"; //success with data
//   static const String noContent =
//       "Success with no content"; //success with no content
//   static const String badRequest =
//       "Bad request, try again later"; //failure, api rejected request
//   static const String forbidden =
//       "Forbidden request, try again later"; //failure, api rejected request
//   static const String unauthorised =
//       "User is unauthorised, try again later"; //failure user is not authorised
//   static const String notFound =
//       "Url not found, try again later"; //failure url is not correct and not found
//   static const String internalServerError =
//       "Something went wrong try again later"; //failure, crash happened in the server side

//   //local status code
//   static const String unknown = "Something went wrong, try again later";
//   static const String connectTimeout = "Timeout error, try again later";
//   static const String cancel = "Request was cancelled, try again later";
//   static const String recieveTimeout = "Timeout error, try again later";
//   static const String sendTimeout = "Timeout error, try again later";
//   static const String cacheError = "Cache error, try again later";
//   static const String noInternetConnection =
//       "Please check your internet connection";
// }

class ApiInternalStatus{
  static const int success = 0;
  static const int failure = 1;
}

class ErrorHandler implements Exception {
  late Failure failure;
  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      //dio error so its error from response api
      failure = _handleError(error);
    } else {
      //default error / unknown error
      failure = DataSource.unknown.getFailure();
    }
  }

  Failure _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return DataSource.connectTimeout.getFailure();
      case DioErrorType.sendTimeout:
        return DataSource.sendTimeout.getFailure();

      case DioErrorType.receiveTimeout:
        return DataSource.recieveTimeout.getFailure();

      case DioErrorType.response:
        switch (error.response?.statusCode) {
          case ResponseCode.badRequest:
            return DataSource.badRequest.getFailure();
          case ResponseCode.forbidden:
            return DataSource.forbidden.getFailure();
          case ResponseCode.unauthorised:
            return DataSource.unauthorised.getFailure();
          case ResponseCode.notFound:
            return DataSource.notFound.getFailure();
          case ResponseCode.internalServerError:
            return DataSource.internalServerError.getFailure();
          default:
            return DataSource.unknown.getFailure();
        }
      case DioErrorType.cancel:
        return DataSource.cancel.getFailure();

      case DioErrorType.other:
        return DataSource.unknown.getFailure();
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequest.tr());
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden.tr());
      case DataSource.unauthorised:
        return Failure(ResponseCode.unauthorised, ResponseMessage.unauthorised.tr());
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound.tr());
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            ResponseMessage.internalServerError.tr());
      case DataSource.connectTimeout:
        return Failure(
            ResponseCode.connectTimeout, ResponseMessage.connectTimeout.tr());
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel.tr());
      case DataSource.recieveTimeout:
        return Failure(
            ResponseCode.recieveTimeout, ResponseMessage.recieveTimeout.tr());
      case DataSource.sendTimeout:
        return Failure(ResponseCode.sendTimeout, ResponseMessage.sendTimeout.tr());
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError.tr());
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            ResponseMessage.noInternetConnection.tr());
      case DataSource.unknown:
        return Failure(ResponseCode.unknown, ResponseMessage.unknown.tr());
      default:
        return Failure(ResponseCode.unknown, ResponseMessage.unknown.tr());
    }
  }
}
