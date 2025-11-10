// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:api_helper/api_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

/// {@template api_client_error}
/// Error throw when accessing api failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class ApiClientError implements Exception {
  /// {@macro api_client_error}
  ApiClientError(this.cause, this.stackTrace);

  /// Error cause.
  final dynamic cause;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  String toString() {
    return cause.toString();
  }
}

/// Definition of a post call used by this client.
typedef PostCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a patch call used by this client.
typedef PatchCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a put call used by this client.
typedef PutCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a get call used by this client.
typedef GetCall = Future<http.Response> Function(
  Uri, {
  Map<String, String>? headers,
});

/// Definition of a delete call used by this client.
typedef DeleteCall = Future<http.Response> Function(
  Uri, {
  Map<String, String>? headers,
  Object? body,
});

/// {@template api_client}
/// Client to access the api
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    Map<String, String>? headers,
    Function(dynamic, StackTrace?)? onError,
    PostCall postCall = http.post,
    PutCall putCall = http.put,
    PatchCall patchCall = http.patch,
    GetCall getCall = http.get,
    DeleteCall deleteCall = http.delete,
  })  : _post = postCall,
        _put = putCall,
        _patch = patchCall,
        _get = getCall,
        _delete = deleteCall,
        _headers = headers ?? {},
        _onError = onError;

  final PostCall _post;
  final PostCall _put;
  final PatchCall _patch;
  final GetCall _get;
  final DeleteCall _delete;

  final Map<String, String>? _headers;
  final Function(dynamic, StackTrace?)? _onError;

  http.Response handleErrorResponse(
    http.Response response,
    ApiHelperErrorEnum defaultError,
  ) {
    try {
      final responseBody = jsonDecode(response.body);
      final customMessage = responseBody["message"] ?? defaultError.errorDescription;

      return http.Response(
        customMessage,
        defaultError.errorId,
      );
    } catch (e) {
      return http.Response(
        jsonEncode(defaultError.errorDescription),
        defaultError.errorId,
      );
    }
  }

  /// Sends a POST request to the specified [path] with the given [body].
  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
    Map<String, String>? modifiedHeaders,
    bool isJson = true,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.noConnnection.errorDescription),
        ApiHelperErrorEnum.noConnnection.errorId,
      );
    }

    final uri =
        Uri.parse('https://catalogo-production-1339.up.railway.app/$path').replace(queryParameters: queryParameters);
    final response = await _post(
      uri,
      body: body,
      headers: modifiedHeaders ?? _headers!
        ..addContentTypeJson(),
    ).onError((error, stackTrace) {
      if (_onError != null) {
        _onError(error, stackTrace);
      }

      return http.Response(
        jsonEncode(ApiHelperErrorEnum.unexpectedError.errorDescription),
        ApiHelperErrorEnum.unexpectedError.errorId,
      );
    });

    if (isJson) {
      try {
        jsonDecode(response.body);
      } catch (e, s) {
        if (_onError != null) {
          _onError(e, s);
        }
        return http.Response(
          jsonEncode(ApiHelperErrorEnum.decodeError.errorDescription),
          ApiHelperErrorEnum.decodeError.errorId,
        );
      }
    }

    if (response.statusCode == 401) {
      return handleErrorResponse(
        response,
        ApiHelperErrorEnum.unauthorizedError,
      );
    }

    return response;
  }

  /// Sends a PATCH request to the specified [path] with the given [body].
  Future<http.Response> patch(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
    Map<String, String>? modifiedHeaders,
    bool isJson = true,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.noConnnection.errorDescription),
        ApiHelperErrorEnum.noConnnection.errorId,
      );
    }

    final uri =
        Uri.parse('https://catalogo-production-1339.up.railway.app/$path').replace(queryParameters: queryParameters);
    final response = await _patch(
      uri,
      body: body,
      headers: modifiedHeaders ?? _headers!
        ..addContentTypeJson(),
    ).onError((error, stackTrace) {
      if (_onError != null) {
        _onError(error, stackTrace);
      }
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.unexpectedError.errorDescription),
        ApiHelperErrorEnum.unexpectedError.errorId,
      );
    });

    if (isJson) {
      try {
        jsonDecode(response.body);
      } catch (e, s) {
        if (_onError != null) {
          _onError(e, s);
        }
        return http.Response(
          jsonEncode(ApiHelperErrorEnum.decodeError.errorDescription),
          ApiHelperErrorEnum.decodeError.errorId,
        );
      }
    }

    if (response.statusCode == 401) {
      return handleErrorResponse(
        response,
        ApiHelperErrorEnum.unauthorizedError,
      );
    }

    return response;
  }

  /// Sends a PUT request to the specified [path] with the given [body].
  Future<http.Response> put(
    String path, {
    Object? body,
    Map<String, String>? modifiedHeaders,
    bool isJson = true,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.noConnnection.errorDescription),
        ApiHelperErrorEnum.noConnnection.errorId,
      );
    }

    final uri = Uri.parse('https://catalogo-production-1339.up.railway.app/$path');
    final response = await _put(
      uri,
      body: body,
      headers: modifiedHeaders ?? _headers!
        ..addContentTypeJson(),
    ).onError((error, stackTrace) {
      if (_onError != null) {
        _onError(error, stackTrace);
      }
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.unexpectedError.errorDescription),
        ApiHelperErrorEnum.unexpectedError.errorId,
      );
    });

    if (isJson) {
      try {
        jsonDecode(response.body);
      } catch (e, s) {
        if (_onError != null) {
          _onError(e, s);
        }
        return http.Response(
          jsonEncode(ApiHelperErrorEnum.decodeError.errorDescription),
          ApiHelperErrorEnum.decodeError.errorId,
        );
      }
    }

    if (response.statusCode == 401) {
      return handleErrorResponse(
        response,
        ApiHelperErrorEnum.unauthorizedError,
      );
    }

    return response;
  }

  /// Sends a GET request to the specified [url].
  Future<http.Response> baseGet(
    String url, {
    Map<String, String>? queryParameters,
    Map<String, String>? modifiedHeaders,
    bool isJson = true,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.noConnnection.errorDescription),
        ApiHelperErrorEnum.noConnnection.errorId,
      );
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final response = await _get(
      uri,
      headers: modifiedHeaders ?? _headers ?? {},
    ).onError((error, stackTrace) {
      if (_onError != null) {
        _onError(error, stackTrace);
      }
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.decodeError.errorDescription),
        ApiHelperErrorEnum.unexpectedError.errorId,
      );
    });

    if (isJson) {
      try {
        jsonDecode(response.body);
      } catch (e, s) {
        if (_onError != null) {
          _onError(e, s);
        }
        return http.Response(
          jsonEncode(ApiHelperErrorEnum.decodeError.errorDescription),
          ApiHelperErrorEnum.decodeError.errorId,
        );
      }
    }

    if (response.statusCode == 401) {
      return handleErrorResponse(
        response,
        ApiHelperErrorEnum.unauthorizedError,
      );
    }

    return response;
  }

  /// Sends a GET request to the specified [path].
  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? modifiedHeaders,
    bool isJson = true,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.noConnnection.errorDescription),
        ApiHelperErrorEnum.noConnnection.errorId,
      );
    }

    final uri =
        Uri.parse('https://catalogo-production-1339.up.railway.app/$path').replace(queryParameters: queryParameters);

    // Debug logging
    print('Making GET request to: $uri');
    if (modifiedHeaders != null) {
      print('Headers: $modifiedHeaders');
    } else {
      print('Headers: $_headers');
    }

    final response = await _get(
      uri,
      headers: modifiedHeaders ?? _headers ?? {},
    ).onError((error, stackTrace) {
      if (_onError != null) {
        _onError(error, stackTrace);
      }

      // Debug logging for errors
      print('HTTP GET Error: $error');
      print('StackTrace: $stackTrace');

      return http.Response(
        jsonEncode(ApiHelperErrorEnum.unexpectedError.errorDescription),
        ApiHelperErrorEnum.unexpectedError.errorId,
      );
    });

    // Debug logging for response
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (isJson) {
      try {
        jsonDecode(response.body);
      } catch (e, s) {
        if (_onError != null) {
          _onError(e, s);
        }
        return http.Response(
          jsonEncode(ApiHelperErrorEnum.decodeError.errorDescription),
          ApiHelperErrorEnum.decodeError.errorId,
        );
      }
    }

    if (response.statusCode == 401) {
      return handleErrorResponse(
        response,
        ApiHelperErrorEnum.unauthorizedError,
      );
    }

    return response;
  }

  /// Sends a DELETE request to the specified public [path].
  Future<http.Response> delete(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? modifiedHeaders,
    Object? body,
    bool isJson = true,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.noConnnection.errorDescription),
        ApiHelperErrorEnum.noConnnection.errorId,
      );
    }

    final uri =
        Uri.parse('https://catalogo-production-1339.up.railway.app/$path').replace(queryParameters: queryParameters);
    final response = await _delete(
      uri,
      body: body,
      headers: modifiedHeaders ?? _headers ?? {},
    ).onError((error, stackTrace) {
      if (_onError != null) {
        _onError(error, stackTrace);
      }
      return http.Response(
        jsonEncode(ApiHelperErrorEnum.unexpectedError.errorDescription),
        ApiHelperErrorEnum.unexpectedError.errorId,
      );
    });

    if (isJson) {
      try {
        jsonDecode(response.body);
      } catch (e, s) {
        if (_onError != null) {
          _onError(e, s);
        }
        return http.Response(
          jsonEncode(ApiHelperErrorEnum.decodeError.errorDescription),
          ApiHelperErrorEnum.decodeError.errorId,
        );
      }
    }

    if (response.statusCode == 401) {
      return handleErrorResponse(
        response,
        ApiHelperErrorEnum.unauthorizedError,
      );
    }

    return response;
  }
}

extension on Map<String, String> {
  void addContentTypeJson() {
    addAll({
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    });
  }
}
