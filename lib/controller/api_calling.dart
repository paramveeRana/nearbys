import 'package:dio/dio.dart';


import 'api_result.dart';
import 'app_constant.dart';
import 'contract_Scan_model.dart';
import 'dio_operation.dart';
import 'network_exception.dart';

class ApiCalling {

  final DioClient apiClient;
  ApiCalling(this.apiClient);


  @override
  Future<dynamic> cataractScanApi(String requestBody) async {
    try {

      Response? response = await apiClient.postRequestWithToken( AppConstant.cataractQualityScanApi,
        requestBody,
      );
      CataractScanResponseModel responseModel =
      cataractScanResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  Future<dynamic> squintScanApi(String requestBody) async {
    try {
      Response? response = await apiClient.postRequestWithToken(
        AppConstant.squintQualityScanApi,
        requestBody,
      );

      CataractScanResponseModel responseModel =
      cataractScanResponseModelFromJson(response.toString());

      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}