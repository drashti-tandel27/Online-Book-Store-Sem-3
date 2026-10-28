import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../utils/constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'Session expired. Please login again.'])
      : super(statusCode: 401);
}

class ValidationException extends ApiException {
  ValidationException(super.message, {super.errors})
      : super(statusCode: 422);

  String get firstError {
    if (errors != null && errors!.isNotEmpty) {
      final firstVal = errors!.values.first;
      if (firstVal is List && firstVal.isNotEmpty) {
        return firstVal.first.toString();
      }
      return firstVal.toString();
    }
    return message;
  }
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'No Internet connection. Please check your network.'])
      : super(statusCode: 0);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Internal server error. Please try again later.'])
      : super(statusCode: 500);
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  String? _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<String?> getAuthToken() async {
    if (_authToken != null) return _authToken;
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(AppConstants.keyAuthToken);
    return _authToken;
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyAuthToken);
  }

  Map<String, String> _buildHeaders({String? token, Map<String, String>? additionalHeaders}) {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final authToken = token ?? _authToken;
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    String cleanEndpoint = endpoint;
    if (!cleanEndpoint.startsWith('/')) {
      cleanEndpoint = '/$cleanEndpoint';
    }

    final fullUrl = '${ApiConfig.baseUrl}$cleanEndpoint';
    final uri = Uri.parse(fullUrl);

    if (queryParams != null && queryParams.isNotEmpty) {
      final stringParams = <String, String>{};
      queryParams.forEach((key, value) {
        if (value != null) {
          stringParams[key] = value.toString();
        }
      });
      return uri.replace(queryParameters: stringParams);
    }

    return uri;
  }

  // GET Request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    await getAuthToken();
    final uri = _buildUri(endpoint, queryParams);

    try {
      if (kDebugMode) print('API GET: $uri');
      final response = await _client
          .get(uri, headers: _buildHeaders())
          .timeout(ApiConfig.connectTimeout);
      return _handleResponse(response);
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out. Please check your network connection.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  // POST Request
  Future<dynamic> post(String endpoint, {dynamic body, Map<String, dynamic>? queryParams}) async {
    await getAuthToken();
    final uri = _buildUri(endpoint, queryParams);

    try {
      if (kDebugMode) print('API POST: $uri, Body: ${jsonEncode(body)}');
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectTimeout);
      return _handleResponse(response);
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  // PUT Request
  Future<dynamic> put(String endpoint, {dynamic body}) async {
    await getAuthToken();
    final uri = _buildUri(endpoint);

    try {
      if (kDebugMode) print('API PUT: $uri, Body: ${jsonEncode(body)}');
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectTimeout);
      return _handleResponse(response);
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  // DELETE Request
  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    await getAuthToken();
    final uri = _buildUri(endpoint);

    try {
      if (kDebugMode) print('API DELETE: $uri');
      final response = await _client
          .delete(
            uri,
            headers: _buildHeaders(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectTimeout);
      return _handleResponse(response);
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException('Request timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (kDebugMode) {
      print('API Response Status [${response.statusCode}]: ${response.body}');
    }

    dynamic responseBody;
    try {
      if (response.body.isNotEmpty) {
        responseBody = jsonDecode(response.body);
      }
    } catch (_) {
      responseBody = {'message': response.body};
    }

    final int status = response.statusCode;

    if (status >= 200 && status < 300) {
      return responseBody;
    }

    String message = 'Something went wrong. Please try again.';
    Map<String, dynamic>? validationErrors;

    if (responseBody is Map<String, dynamic>) {
      if (responseBody['message'] != null) {
        message = responseBody['message'].toString();
      } else if (responseBody['error'] != null) {
        message = responseBody['error'].toString();
      }

      if (responseBody['errors'] != null && responseBody['errors'] is Map<String, dynamic>) {
        validationErrors = responseBody['errors'] as Map<String, dynamic>;
      }
    }

    switch (status) {
      case 401:
        clearAuthToken();
        throw UnauthorizedException(message);
      case 403:
        throw ApiException('Access forbidden. You do not have permission.', statusCode: 403);
      case 404:
        throw ApiException(message.isNotEmpty ? message : 'Resource not found.', statusCode: 404);
      case 422:
        throw ValidationException(message, errors: validationErrors);
      case 500:
      case 502:
      case 503:
        throw ServerException(message);
      default:
        throw ApiException(message, statusCode: status, errors: validationErrors);
    }
  }
}
