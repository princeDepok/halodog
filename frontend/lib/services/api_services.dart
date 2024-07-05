// api_services.dart

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'token_storage.dart';

class ApiService {
  late final Dio _dio;
  final String _baseUrl = 'http://10.10.168.154:8000/api/';
  final TokenStorage tokenStorage = TokenStorage();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
    ));
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  Future<Response> registerUser(Map<String, dynamic> data) async {
    try {
      return await _dio.post('users/register/', data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> loginUser(Map<String, dynamic> data) async {
    try {
      return await _dio.post('users/login/', data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<bool> registerAndLoginUser(
      Map<String, dynamic> registrationData) async {
    try {
      final registerResponse = await registerUser(registrationData);
      if (registerResponse.statusCode == 200 ||
          registerResponse.statusCode == 201) {
        final loginData = {
          'username': registrationData['email'],
          'password': registrationData['password'],
        };
        final loginResponse = await loginUser(loginData);
        if (loginResponse.statusCode == 200) {
          final tokens = loginResponse.data;
          await tokenStorage.saveTokens(tokens['access'], tokens['refresh']);
          return true;
        } else {
          print('Login failed after registration: ${loginResponse.data}');
          return false;
        }
      } else {
        print('Registration failed: ${registerResponse.data}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<Response> getUserDetails(int userId, String accessToken) async {
    try {
      print(
          'Requesting user details for userId: $userId with token: $accessToken');
      final response = await _dio.get(
        'users/user/$userId/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print('Response received: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('Error occurred: ${e.response?.data ?? e.message}');
      if (e.response?.statusCode == 500) {
        // Additional logging for server errors
        print('Server error: ${e.response?.data}');
      }
      return e.response ?? Response(requestOptions: RequestOptions(path: ''));
    } catch (e) {
      print('Unexpected error: $e');
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }

  Future<List<dynamic>> getDoctors() async {
    try {
      final response = await _dio.get('consultations/doctors/');
      return response.data;
    } catch (e) {
      print('Error fetching doctors: $e');
      return [];
    }
  }

  Response _handleError(dynamic e) {
    if (e is DioException) {
      print('DioError: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        return e.response!;
      } else {
        return Response(requestOptions: RequestOptions(path: ''));
      }
    } else {
      print('Unexpected error: $e');
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }
}
