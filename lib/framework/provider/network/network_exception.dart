import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sccore_sync/ui/utils/app_constants.dart';

part 'network_exception.freezed.dart';


@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest() = UnauthorizedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound(String reason, Response? response) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  const factory NetworkExceptions.badCertificate() = BadCertificate;

  const factory NetworkExceptions.connectionError() = ConnectionError;

  static NetworkExceptions handleResponse(int? statusCode, DioException error, Response? response) {
    //print("....error status code...$statusCode");
    errorStatusCode = statusCode!;
    switch (statusCode) {
      case 400:
      // print('testing here for status coe 400');
      // globalReference?.read(navigationStackController).pushAndRemoveAll(
      //     const NavigationStackItem.signUpOrSignInChooser());
        return NetworkExceptions.notFound(error.message ?? unknown, response);
      case 401:
        return NetworkExceptions.notFound(error.message ?? unknown, response);
      case 403:
        return const NetworkExceptions.unauthorizedRequest();
      case 404:
        return NetworkExceptions.notFound(error.message ?? unknown, response);
      case 409:
        return const NetworkExceptions.conflict();
      case 408:
        return const NetworkExceptions.requestTimeout();
      case 500:
      // globalReference?.read(navigationStackController).pushAndRemoveAll(
      //     const NavigationStackItem.signUpOrSignInChooser());
        return const NetworkExceptions.internalServerError();
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      case 504:
        return const NetworkExceptions.serviceUnavailable();
      default:
        var responseCode = statusCode;
        return NetworkExceptions.defaultError('$receivedInvalidStatusCode $responseCode');
    }
  }

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        late NetworkExceptions networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              if (error.error.runtimeType.toString() == socketException) {
                networkExceptions = const NetworkExceptions.noInternetConnection();
              } else {
                networkExceptions = const NetworkExceptions.sendTimeout();
              }
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              networkExceptions = NetworkExceptions.handleResponse(error.response!.statusCode, error, error.response);
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions = const NetworkExceptions.badCertificate();
              break;
            case DioExceptionType.connectionError:
              networkExceptions = const NetworkExceptions.connectionError();
              break;
          }
        } else if (error.runtimeType.toString() == socketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else if (error.runtimeType.toString() == formatException) {
          networkExceptions = const NetworkExceptions.formatException();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains(isNotaSubtypeOf)) {
        if (kDebugMode) {
          // showLog(error.toString());
        }
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = '';
    networkExceptions.when(
      notImplemented: () {
        errorMessage = notImplemented;
      },
      requestCancelled: () {
        errorMessage = requestCancelled;
      },
      internalServerError: () {
        errorMessage = internalServerError;
      },
      notFound: (String reason, Response? response) {
        errorMessage = response?.toString() ?? reason;
      },
      serviceUnavailable: () {
        errorMessage = serviceUnavailable;
      },
      methodNotAllowed: () {
        errorMessage = methodAllowed;
      },
      badRequest: () {
        errorMessage = badRequest;
      },
      unauthorizedRequest: () {
        errorMessage = unauthorizedRequest;
      },
      unexpectedError: () {
        errorMessage = unexpectedErrorOccurred;
      },
      requestTimeout: () {
        errorMessage = connectionRequestTimeout;
      },
      noInternetConnection: () {
        errorMessage = noInternetConnection;
      },
      conflict: () {
        errorMessage = errorDueToaConflict;
      },
      sendTimeout: () {
        errorMessage = sendTimeoutInConnectionWithAPIServer;
      },
      unableToProcess: () {
        errorMessage = unableToProcessTheData;
      },
      defaultError: (String error) {
        errorMessage = error;
      },
      formatException: () {
        errorMessage = formatExceptionSomethingWentWrongWithData;
      },
      notAcceptable: () {
        errorMessage = notAcceptable;
      },
      badCertificate: () {
        errorMessage = badeCertificate;
      },
      connectionError: () {
        errorMessage = connectionError;
      },
    );
    return errorMessage;
  }

  static int errorStatusCode = 0;
}
