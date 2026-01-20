import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nearbys/controller/squint_scan_model.dart';


import 'api_result.dart';
import 'app_constant.dart';
import 'contract_scan_model.dart';
import 'dio_operation.dart';
import 'network_exception.dart';

class ApiCalling {
  final DioClient apiClient;
  ApiCalling(this.apiClient);

  Future<ApiResult<CataractScanResponseModel>> cataractScanApi(String requestBody) async {
    try {
      final response = await apiClient.postRequestWithToken(
        AppConstant.cataractQualityScanApi,
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
        AppConstant.squintQualityScanApi,
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
