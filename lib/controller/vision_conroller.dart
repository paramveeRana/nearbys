import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nearbys/controller/ui_state.dart';
import 'api_calling.dart';
import 'api_result.dart';
import 'contract_Scan_model.dart';
import 'dio_operation.dart';
import 'enums.dart';
import 'network_exception.dart';





final visionController = ChangeNotifierProvider((ref){

  return VisionController(
    ApiCalling(
      DioClient(Dio(

      ))
    ),
  );

});


class VisionController extends ChangeNotifier{


  ApiCalling _aiVisionTestRepository;

  VisionController(this._aiVisionTestRepository);



  Uint8List? leftEyeImage;
  Uint8List? rightEyeImage;

  String? leftEyeId;
  String? rightEyeId;

  Future<bool> captureAiVisionTestImage(
      BuildContext context,
      AiVisionTestImageTypeEnum type,
      WidgetRef ref,
      Uint8List bytes,
      ) async {
    try {
      switch (type) {
        case AiVisionTestImageTypeEnum.leftEye:
          leftEyeImage = bytes;
          break;
        case AiVisionTestImageTypeEnum.rightEye:
          rightEyeImage = bytes;
          break;
      }

      if (context.mounted) {
        final result = await cataractScan(context, bytes, type, ref);

        // If quality passed
        if (result.success?.qualityPassed == true) {
          return true;
        } else {
          _resetEye(type);
          return false;
        }
      }
    } catch (e) {
      if (context.mounted) {
        print(e);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("error: $e")));
      }
    }

    _resetEye(type);
    notifyListeners();
    return false;
  }

  UIState<CataractScanResponseModel> cataractScanState =
  UIState<CataractScanResponseModel>();
  Future<UIState<CataractScanResponseModel>> cataractScan(
      BuildContext context,
      Uint8List imageBytes,
      AiVisionTestImageTypeEnum type,
      WidgetRef ref,
      ) async {
    cataractScanState.isLoading = true;
    notifyListeners();

    final request = {
      'image': base64Encode(imageBytes),
      'client_code': 'sccore_demo',
    };

    final result = await _aiVisionTestRepository.cataractScanApi(
      jsonEncode(request),
    );

    if (result is Success<CataractScanResponseModel>) {
      final data = result.data;

      cataractScanState.success = data;

      if (data.qualityPassed == true) {
        switch (type) {
          case AiVisionTestImageTypeEnum.leftEye:
            leftEyeImage = imageBytes;
            leftEyeId = data.imageId;
            break;
          case AiVisionTestImageTypeEnum.rightEye:
            rightEyeImage = imageBytes;
            rightEyeId = data.imageId;
            break;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Quality check pass")));
      } else {
        _resetEye(type);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Quality check failed")));
      }
    }
    else if (result is Failure) {
      _resetEye(type);

      final errorMessage =
      NetworkExceptions.getErrorMessage(result.error);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }


    /*
    result.when(
      success: (data) {
        cataractScanState.success = data;

        if (cataractScanState.success?.qualityPassed == true) {
          switch (type) {
            case AiVisionTestImageTypeEnum.leftEye:
              leftEyeImage = imageBytes;
              leftEyeId = data.imageId;
              break;
            case AiVisionTestImageTypeEnum.rightEye:
              rightEyeImage = imageBytes;
              rightEyeId = data.imageId;
              break;
          }

          if (leftEyeId != null && rightEyeId != null) {
            /// report
            // aiVisionTestReportApi(context, ref);
          }
        } else {
          switch (type) {
            case AiVisionTestImageTypeEnum.leftEye:
              leftEyeImage = null;
              leftEyeId = null;
              break;
            case AiVisionTestImageTypeEnum.rightEye:
              rightEyeImage = null;
              rightEyeId = null;
              break;
          }
          notifyListeners();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("qualityPassed Failed!")));

          // showSnackBar(
          //   context: context,
          //   isSuccess: false,
          //   title: "qualityPassed Failed!",
          // );
        }
      },
      failure: (error) {
        switch (type) {
          case AiVisionTestImageTypeEnum.leftEye:
            leftEyeImage = null;
            leftEyeId = null;
            break;
          case AiVisionTestImageTypeEnum.rightEye:
            rightEyeId = null;
            rightEyeImage = null;
            break;
        }
        cataractScanState.isLoading = false;
        notifyListeners();

        String errorMessage = 'Failed to validate image quality';
        final rawMessage = NetworkExceptions.getErrorMessage(error);
        try {
          final decoded = jsonDecode(rawMessage);
          errorMessage = decoded['detail'] ?? errorMessage;
        } catch (e) {
          errorMessage = rawMessage;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));

        // showSnackBar(context: context, isSuccess: false, title: errorMessage);/
      },
    );
*/
    cataractScanState.isLoading = false;
    notifyListeners();
    return cataractScanState;
  }
  void _resetEye(AiVisionTestImageTypeEnum type) {
    if (type == AiVisionTestImageTypeEnum.leftEye) {
      leftEyeImage = null;
      leftEyeId = null;
    } else {
      rightEyeImage = null;
      rightEyeId = null;
    }
  }


}