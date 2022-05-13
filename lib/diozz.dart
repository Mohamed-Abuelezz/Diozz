library diozz;

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

/// A Calculator.
class Diozz {
 static String appLanguage = 'en';

  static String globalError = (appLanguage == 'ar'
      ? '! حدث خطأ يرجي التأكد من الانترنت اولا او مراجعه اداره التطبيق'
      : 'An error occurred, please check the internet first or review the application administration !');
  static String noInternetsError =    ( appLanguage == 'ar'
        ? 'برجاء الإتصال بالإنترنت !'
        : 'Please Connect to Internet !');
  static String weakInternetError =     (appLanguage == 'ar'
        ? 'إشارة الإنترنت ضعيفة !'
        : 'Internet signal weak !');
  static String serverErrorError =     (appLanguage == 'ar'
        ? 'يوجد مشكلة فى السيرفر برجاء مراجعة إدارة التطبيق'
        : 'There is a problem with the server, please check the application management');



  static Future<dynamic> sendDiozz({
   required String? url,
    required String methodType,
    required dynamic dioBody,
     Map<String, dynamic>? dioHeaders,
  }) async {
    var response;
    bool isSocketException = false;

  //  var connectivityResult = await (Connectivity().checkConnectivity());
    var connectivityResult =  ConnectivityResult.mobile;
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        if (methodType == 'GET' || methodType == 'get') {
          response = await Dio()
              .get(
            url!,
            queryParameters: dioBody,
            options: Options(
                headers: dioHeaders ,
                validateStatus: (int? status) =>
                    status! >= 200 && status <= 500),
          )
              .catchError((onError) {
            isSocketException = true;
          });
        } else if (methodType == 'POST' || methodType == 'post') {
          response = await Dio()
              .post(url!,
                  data: FormData.fromMap(dioBody),
                  options: Options(
                headers: dioHeaders ,
                      validateStatus: (int? status) =>
                          status! >= 200 && status <= 500))
              .catchError((onError) {
            isSocketException = true;
            print(onError);
          });
        } else if (methodType == 'PUT' || methodType == 'put') {
          response = await Dio()
              .put(url!,
                  data: FormData.fromMap(dioBody),
                  options: Options(
                headers: dioHeaders ,
                      validateStatus: (int? status) =>
                          status! >= 200 && status <= 500))
              .catchError((onError) {
            isSocketException = true;
            //   print('Response is >>> ' + response.data.toString());
          });
        } else if (methodType == 'DELETE' || methodType == 'delete') {
          response = await Dio()
              .delete(url!,
                  data: FormData.fromMap(dioBody),
                  options: Options(
                headers: dioHeaders ,
                      validateStatus: (int? status) =>
                          status! >= 200 && status <= 500))
              .catchError((onError) {
            isSocketException = true;
            //   print('Response is >>> ' + response.data.toString());
          });
        }
        print('Response Diozz is >>> ' + response.toString());

        if (response.statusCode >= 200 && response.statusCode <= 299) {

          return responsMap(
              status: response.data['status'],
              message: response.data['message'],
              data: response.data['data']);

        } else if (response.statusCode >= 500) {
          return responsMap(status: false, message: serverErrorError);
        } else if (isSocketException) {
          return responsMap(status: false, message: weakInternetError);
        } else if (response.statusCode == 401 || response.statusCode == 302) {
          return responsMap(
              status: false, message: response.data['message'], data: null);
        } else if (response.statusCode >= 400 && response.statusCode <= 499) {
          return responsMap(
              status: false, message: response.data['message'], data: null);
        } else {
                return responsMap(
          status: false, message: globalError, data: null);

        }
      } catch (e) {
                        return responsMap(
          status: false, message: globalError, data: null);

      }
    } else {
      return responsMap(
          status: false, message: noInternetsError, data: null);
    }
  }








  static Map<dynamic, dynamic> responsMap(
      {dynamic? status, String? message, dynamic data}) {
    return {"status": status, "message": message.toString(), "data": data};
  }
}
