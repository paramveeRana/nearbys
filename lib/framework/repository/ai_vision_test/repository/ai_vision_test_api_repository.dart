import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nearbys/framework/repository/ai_vision_test/model/squint_scan_model.dart';
import 'package:nearbys/ui/utils/app_constants.dart';


import '../../../provider/network/api_result.dart';
import '../model/cataract_scan_model.dart';
import '../../../provider/network/dio_operation.dart';
import '../../../provider/network/network_exception.dart';

class ApiCalling {
  final DioClient apiClient;
  ApiCalling(this.apiClient);

  Future<ApiResult<CataractScanResponseModel>> cataractScanApi(String requestBody) async {
    try {
      final response = await apiClient.postRequestWithToken(
        AppConstants.cataractQualityScanApi,
        requestBody,
      );

      final responseModel = CataractScanResponseModel.fromJson(response.data);

      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  Future<ApiResult<SquintScanResponseModel>> squintScanApi(String requestBody) async {
    try {
      final response = await apiClient.postRequestWithToken(
        AppConstants.squintQualityScanApi,
        requestBody,
      );

      debugPrint("RAW SQUINT RESPONSE: ${response.data}");

      final responseModel = SquintScanResponseModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      return ApiResult.success(data: responseModel);
    } catch (err) {
      print("error $err");
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
