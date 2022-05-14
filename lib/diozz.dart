// ignore_for_file: use_build_context_synchronously

library diozz;

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:diozz/src/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:palestine_console/palestine_console.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import 'l10n/generated/diozz_localizations.dart';
export 'src/enums.dart';

/// A Calculator.
class Diozz {
  // static String appLanguage = 'en';

  // static String globalError = (appLanguage == 'ar'
  //     ? '! حدث خطأ يرجي التأكد من الانترنت اولا او مراجعه اداره التطبيق'
  //     : 'An error occurred, please check the internet first or review the application administration !');
  // static String noInternetsError = (appLanguage == 'ar'
  //     ? 'برجاء الإتصال بالإنترنت !'
  //     : 'Please Connect to Internet !');
  // static String weakInternetError = (appLanguage == 'ar'
  //     ? 'إشارة الإنترنت ضعيفة !'
  //     : 'Internet signal weak !');
  // static String serverErrorError = (appLanguage == 'ar'
  //     ? 'يوجد مشكلة فى السيرفر برجاء مراجعة إدارة التطبيق'
  //     : 'There is a problem with the server, please check the application management');

  static late Dio dio;

  /// This function  to init dio
  static void init(
    String baseUrl, {
    int? connectTimeout,
    int? receiveTimeout,
  }) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      validateStatus: (int? status) => status! >= 200 && status <= 500,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    ));
  }

  /// This function to send data
  /// Return map {status : true or false , message: message from server , data: data if exist}
  static Future<Map> sendDiozz({
    required String url,
    required MethodType methodType,
    dynamic dioBody,
    Map<String, dynamic>? dioHeaders,
    required BuildContext context,
  }) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();

    late Response response;
    bool isSocketException = false;

    // var connectivityResult = ConnectivityResult.mobile;
    if (isConnected) {
      try {
        if (methodType.name == 'GET') {
          response = await dio
              .get(
            url,
            queryParameters: dioBody,
            options: Options(
              headers: dioHeaders,
            ),
          )
              .catchError((onError) {
            isSocketException = true;
            Print.red(onError.toString());
          });
        } else if (methodType.name == 'POST') {
          response = await dio
              .post(url,
                  data: FormData.fromMap(dioBody),
                  options: Options(
                    headers: dioHeaders,
                  ))
              .catchError((onError) {
            isSocketException = true;
            Print.red(onError.toString());
          });
        } else if (methodType.name == 'PUT') {
          response = await dio
              .put(url,
                  data: FormData.fromMap(dioBody),
                  options: Options(
                    headers: dioHeaders,
                  ))
              .catchError((onError) {
            isSocketException = true;
            Print.red(onError.toString());
          });
        } else if (methodType.name == 'DELETE') {
          response = await dio
              .delete(url,
                  data: FormData.fromMap(dioBody),
                  options: Options(
                    headers: dioHeaders,
                  ))
              .catchError((onError) {
            isSocketException = true;
            Print.red(onError.toString());
          });
        }
        Print.green('Response Diozz is >>> $response');

        if (response.statusCode! >= 200 && response.statusCode! <= 299) {
          return responsMap(
              status: response.data['status'],
              message: response.data['message'],
              data: response.data['data']);
        } else if (response.statusCode! >= 500) {
          Print.red(response.statusCode.toString());

          return responsMap(
              status: false,
              message: AppLocalizations.of(context)!.server_error);
        } else if (isSocketException) {
          return responsMap(
              status: false,
              message: AppLocalizations.of(context)!.weak_internet_error);
        } else if (response.statusCode == 401 || response.statusCode == 302) {
          Print.red(response.statusCode.toString());

          return responsMap(
              status: false, message: response.data['message'], data: null);
        } else if (response.statusCode! >= 400 && response.statusCode! <= 499) {
          Print.red(response.statusCode.toString());

          return responsMap(
              status: false, message: response.data['message'], data: null);
        } else {
          return responsMap(
              status: false,
              message: AppLocalizations.of(context)!.global_error,
              data: null);
        }
      } catch (e) {
        log(e.toString());
        return responsMap(
            status: false,
            message: AppLocalizations.of(context)!.global_error,
            data: null);
      }
    } else {
      Print.red('noInternetsError');

      return responsMap(
          status: false,
          message: AppLocalizations.of(context)!.no_internet_error,
          data: null);
    }
  }

  static Map responsMap({dynamic status, String? message, dynamic data}) {
    //   print('from inside responsMap');
    return {"status": status, "message": message.toString(), "data": data};
  }
}
