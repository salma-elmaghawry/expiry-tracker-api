import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import 'failures.dart';

class ErrorMapper {
  static Failure map(dynamic error) {
    if (error is DioException) {
      return _mapDioException(error);
    }

    if (error is TimeoutException) {
      return NetworkFailure(message: 'errors.network_error'.tr());
    }

    if (error is FormatException || error is TypeError) {
      return ServerFailure(message: 'errors.server_error'.tr());
    }

    return UnexpectedFailure(message: 'errors.unexpected_error'.tr());
  }

  static Failure _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(message: 'errors.network_error'.tr());
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response);
      default:
        return UnexpectedFailure(message: 'errors.unexpected_error'.tr());
    }
  }

  static Failure _mapStatusCode(Response<dynamic>? response) {
    switch (response?.statusCode) {
      case 400:
        return ValidationFailure(
          message: 'errors.validation_error'.tr(),
          fieldErrors: _fieldErrors(response?.data),
        );
      case 404:
        return NotFoundFailure(message: 'errors.not_found'.tr());
      case 409:
        return ConflictFailure(message: 'errors.conflict'.tr());
      default:
        return ServerFailure(message: 'errors.server_error'.tr());
    }
  }

  static Map<String, List<String>> _fieldErrors(dynamic data) {
    if (data is! Map || data['errors'] is! Map) return const {};

    return (data['errors'] as Map).map(
      (field, messages) => MapEntry(field.toString(), [
        for (final message in messages as List) message.toString(),
      ]),
    );
  }
}
