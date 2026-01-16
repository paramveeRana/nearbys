

import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  DioClient(this._dio);

  Future<dynamic> postRequestWithToken(String endPoint, String? requestBody, {bool isBytes = false}) async {
    try {


      Map<String, dynamic> headers = {
        // AppConstants.accept: AppConstants.headerAccept,
        // AppConstants.contentType: AppConstants.headerContentType,
        // AppConstants.acceptLanguage: Session.getAppLanguage(),
      };
      ///Authorization Header
      // String token = Session.userAccessToken;
      // if (token.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer cataract_wuG1iRIazgZZvNPTO1m_iT2WgcybVYOT3VOpFjATMKs'});
      // }

      _dio.options.headers = headers;

      if (isBytes) {
        return await _dio.post(
          endPoint,
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.post(endPoint, data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

}