import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nearbys/framework/extension/ui_state.dart';
import 'package:nearbys/framework/repository/ai_vision_test/model/squint_scan_model.dart';
import 'package:nearbys/ui/utils/app_enums.dart';
import '../repository/ai_vision_test/repository/ai_vision_test_api_repository.dart';
import '../provider/network/api_result.dart';
import '../repository/ai_vision_test/model/cataract_scan_model.dart';
import '../provider/network/dio_operation.dart';
import '../provider/network/network_exception.dart';



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

  /// squint scan api
  Uint8List? squintEyeImage;
  String? squintEyeId;


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

  /// squit api
  Future<bool> captureAiSquintTestImage(
      BuildContext context,
      WidgetRef ref,
      Uint8List bytes,
      ) async {
    try {
      squintEyeImage = bytes;

      if (context.mounted) {
        final result = await squintScan(context, bytes, ref);

        if (result.success?.qualityPassed == true) {
          return true;
        } else {
          squintEyeImage = null;
          squintEyeId = null;
          return false;
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("error: $e")));
      }
    }

    squintEyeImage = null;
    squintEyeId = null;
    notifyListeners();
    return false;
  }


  UIState<CataractScanResponseModel> cataractScanState =
  UIState<CataractScanResponseModel>();

  UIState<SquintScanResponseModel> squintScanState = UIState<SquintScanResponseModel>();

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
      final failure = result as Failure;
      final errorMessage =
      NetworkExceptions.getErrorMessage(failure.error);



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


  /// squint api
  Future<UIState<SquintScanResponseModel>> squintScan(
      BuildContext context,
      Uint8List imageBytes,
      WidgetRef ref,
      ) async {
    squintScanState.isLoading = true;
    notifyListeners();

    final request = {
      'image': base64Encode(imageBytes),
      'client_code': 'sccore_demo',
    };

    final result = await _aiVisionTestRepository.squintScanApi(
      jsonEncode(request),
    );


    if (result is Success<SquintScanResponseModel>) {
      final data = result.data;
      squintScanState.success = data;

      if (data.qualityPassed == true) {
        squintEyeImage = imageBytes;
        squintEyeId = data.imageId;


        debugPrint("===== SQUINT API FULL RESULT =====");
        debugPrint(jsonEncode(data.toJson()));
        debugPrint("================================");


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Squint quality check passed")),
        );
      } else {
        squintEyeImage = null;
        squintEyeId = null;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Squint quality check failed")),
        );
      }
    }
    else if (result is Failure) {
      squintEyeImage = null;
      squintEyeId = null;
      final failure = result as Failure;
      final errorMessage =
      NetworkExceptions.getErrorMessage(failure.error);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }

    squintScanState.isLoading = false;
    notifyListeners();
    return squintScanState;
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