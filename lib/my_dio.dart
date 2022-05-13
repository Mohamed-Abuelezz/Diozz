import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

myDio({
  String? url,
  required String methodType,
  required dynamic dioBody,
  required Map<String, dynamic> dioHeaders,
  required String appLanguage,
}) async {
  var response;
  bool isSocketException = false;

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    try {
      if (methodType == 'GET') {
        response = await Dio()
            .get(
          url!,
          queryParameters: dioBody,
          options: Options(
              headers: dioHeaders == {} ? null : dioHeaders,
              validateStatus: (int? status) => status! >= 200 && status <= 500),
        )
            .catchError((onError) {
          isSocketException = true;
        });
      } else if (methodType == 'POST') {
        response = await Dio()
            .post(url!,
                data: dioBody,
                options: Options(
                    headers: dioHeaders == {} ? null : dioHeaders,
                    validateStatus: (int? status) =>
                        status! >= 200 && status <= 500))
            .catchError((onError) {
          isSocketException = true;
          print(onError);
        });
      } else if (methodType == 'PUT') {
        response = await Dio()
            .put(url!,
                data: dioBody,
                options: Options(
                    headers: dioHeaders == {} ? null : dioHeaders,
                    validateStatus: (int? status) =>
                        status! >= 200 && status <= 500))
            .catchError((onError) {
          isSocketException = true;
          //   print('Response is >>> ' + response.data.toString());
        });
      } else if (methodType == 'DELETE') {
        response = await Dio()
            .delete(url!,
                data: dioBody,
                options: Options(
                    headers: dioHeaders == {} ? null : dioHeaders,
                    validateStatus: (int? status) =>
                        status! >= 200 && status <= 500))
            .catchError((onError) {
          isSocketException = true;
          //   print('Response is >>> ' + response.data.toString());
        });
      }
      print('Response is >>> ' + response.toString());

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return responsMap(
            status: response.data['status'],
            message: response.data['message'],
            data: response.data['data']);
      } else if (response.statusCode >= 500) {
        return responsMap(status: 0, message: serverErrorError(appLanguage));
      } else if (isSocketException) {
        return responsMap(status: 0, message: weakInternetError(appLanguage));
      } else if (response.statusCode == 401 || response.statusCode == 302) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();

        //    Get.offAll(SelectLangScreen(pref:prefs ,));
        return responsMap(
            status: false, message: response.data['message'], data: null);
      } else if (response.statusCode >= 400 && response.statusCode <= 499) {
        return responsMap(
            status: false, message: response.data['message'], data: null);
      } else {
        return responsMap(
            status: 0, message: globalError(appLanguage), data: null);
      }
    } catch (e) {
      print('global Dio Error' + e.toString());
      return responsMap(
          status: 0, message: globalError(appLanguage), data: null);
    }
  } else {
    print('no network ');

    return responsMap(
        status: 0, message: noInternetsError(appLanguage), data: null);
  }
}

String missingParameterError(String appLanguage) {
  return 'يوجد حقل ناقص ومطلوب برجاء مراجعه الداله مره اخري';
}

String globalError(String appLanguage) {
  return appLanguage == 'ar'
      ? '! حدث خطأ يرجي التأكد من الانترنت اولا او مراجعه اداره التطبيق'
      : 'An error occurred, please check the internet first or review the application administration !';
}

String noInternetsError(String appLanguage) {
  return appLanguage == 'ar'
      ? 'برجاء الإتصال بالإنترنت !'
      : 'Please Connect to Internet !';
}

String weakInternetError(String appLanguage) {
  return appLanguage == 'ar'
      ? 'إشارة الإنترنت ضعيفة !'
      : 'Internet signal weak !';
}

String serverErrorError(String appLanguage) {
  return appLanguage == 'ar'
      ? 'يوجد مشكلة فى السيرفر برجاء مراجعة إدارة التطبيق'
      : 'There is a problem with the server, please check the application management';
}

Map<dynamic, dynamic> responsMap(
    {dynamic? status, String? message, dynamic data}) {
  return {"status": status, "message": message.toString(), "data": data};
}
