import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  DioClient(this._dio);

  Future<Response> postRequestWithToken(String endPoint, String requestBody,
      {bool isBytes = false}) async {
    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer cataract_wuG1iRIazgZZvNPTO1m_iT2WgcybVYOT3VOpFjATMKs',
    };

    _dio.options.headers = headers;

    return await _dio.post(
      endPoint,
      data: requestBody,
      options: Options(headers: headers),
    );
  }
}
