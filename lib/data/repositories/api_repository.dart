import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_architecture/constants/enums.dart';
import 'package:flutter_architecture/data/repositories/preferences.dart';
import 'package:flutter_architecture/utils/logger.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

abstract class ApiRepository {
  static final String prodUri = '';
  static final String testUri = '';
  static final String protocol = "https";
  static final Dio dio = Dio();
  String hostAndprotocol;
  final _prefs = Preferences();

  static final Map headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  request({
    @required String url,
    @required MethodType methodType,
    @required Map<String, dynamic> body,
    bool secured = true,
  }) async {
    Logger.d("Excecuting request to $url");
    String hostAndProtocol = await _getProcotol();

    final requestHeaders = {
      ...headers,
      if (secured) 'Authorization': 'Bearer ${_prefs.token}'
    };

    try {
      String method = _getMethodString(methodType);
      final response = await dio.request(hostAndProtocol + url,
          data: json.encode(body),
          options: Options(method: method, headers: requestHeaders));

      _responseManagement(response);
    } catch (e) {
      throw _errorManagement(e);
    }
  }

  getRequest({
    @required String url,
    bool secured = true,
  }) async {
    Logger.d("Excecuting GET request to $url");
    String hostAndProtocol = await _getProcotol();

    final requestHeaders = {
      ...headers,
      if (secured) 'Authorization': 'Bearer ${_prefs.token}'
    };

    try {
      final response = await dio.get(hostAndProtocol + url,
          options: Options(headers: requestHeaders));

      _responseManagement(response);
    } catch (e) {
      throw _errorManagement(e);
    }
  }

  _getProcotol() async {
    if (hostAndprotocol != null) return hostAndprotocol;
    if (kDebugMode) {
      Logger.d("App in testing mode, using api host: $protocol://$testUri");
      hostAndprotocol = "$protocol://$testUri";
    } else {
      Logger.d("App in live mode, using api host: $protocol://$prodUri");
      hostAndprotocol = "$protocol://$prodUri";
    }
    return hostAndprotocol;
  }

  dynamic _responseManagement(Response<dynamic> response) {
    Logger.d('Response with status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  dynamic _errorManagement(e) {
    Logger.e('Api Error: ${e.toString()}');
    return 'Api error';
  }

  String _getMethodString(MethodType method) {
    switch (method) {
      case MethodType.post:
        return 'post';
        break;
      case MethodType.delete:
        return 'delete';
        break;
      case MethodType.put:
        return 'put';
        break;
      default:
        return 'post';
    }
  }
}
