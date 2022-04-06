import 'dart:convert';
import 'dart:io';
import 'package:users_crud_test/network/service.dart';
import 'package:http/http.dart' as http;

class Response {
  Map<String, dynamic> value = {};
  int? code;

  Response(String value, int code){
    this.code = code;
    if(code == 200) this.value = jsonDecode(value);
  }
  Response.fromNew() : value = {}, code = 0;
}

class Network {
  static const String serverUrl = "https://reqres.in/api/";
  // static String servicesUrl = "$serverUrl/api/";

  static Future<bool> internetVerification() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;

    }
  }

  static Future<Response> get(Service service, { Map<String, dynamic>? body }) async {
    final url = serverUrl + _convertServiceEnumToString(service);
    return await getExecution(url);
  }


  static Future<Response> postWithUrl(url, { Map<String, dynamic>? body }) async => await getExecution(url);

  static Future<Response> getExecution(String url, { Map<String, dynamic>? body }) async {
    if(!await Network.internetVerification()) return Response.fromNew();


    var request = http.get(Uri.parse(url));

    var response = await request
        .timeout(const Duration(seconds: 5))
        .catchError((_) => print("Error : $_"));

    return Response(response.body, response.statusCode);
  }

  // static Future<Response> getExecution(String url, { Map<String, dynamic>? body }) async {
  //   if(!await Network.internetVerification()) return Response.fromNew();

  //   var request = http.get(Uri.parse(url));

  //   var response = await request
  //       .timeout(const Duration(seconds: 5))
  //       .catchError((_) => print("Error : $_"));

  //   return Response(response.body, response.statusCode);
  // }

  static String _convertServiceEnumToString(Service service) => service.toString().replaceFirst("Service.", "");
}
