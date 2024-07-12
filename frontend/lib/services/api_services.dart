import 'package:dio/dio.dart';
import 'package:frontend/screens/booking_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'token_storage.dart';

class ApiService {
  late final Dio _dio;
  final String _baseUrl = 'http://192.168.158.184:8001/api/';
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

  Future<Response> getUserDetails(int userId, String accessToken) async {
    try {
      final response = await _dio.get(
        'users/user/$userId/',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      return e.response ?? Response(requestOptions: RequestOptions(path: ''));
    } catch (e) {
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }

  Future<List<dynamic>> getDoctors() async {
    try {
      final response = await _dio.get('consultations/doctors/');
      return (response.data as List).map((doctor) {
        return {
          ...doctor as Map<String, dynamic>,
          'specialties': (doctor['specialties'] as List).map((s) => s['name']).toList(),
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Response> addAnimal(Map<String, dynamic> data, XFile? photo, String accessToken) async {
    try {
      FormData formData = FormData.fromMap(data);
      if (photo != null) {
        formData.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(photo.path, filename: photo.name),
        ));
      }

      final response = await _dio.post(
        'users/pets/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<List<dynamic>> getUserPets(String accessToken) async {
    try {
      final response = await _dio.get(
        'users/pets/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response.data as List<dynamic>;
    } catch (e) {
      print('Error fetching pets: $e');
      return [];
    }
  }

  Future<Response> createBooking(Booking booking, String accessToken) async {
    try {
      FormData formData = FormData.fromMap(booking.toJson());
      if (booking.paymentProof != null) {
        formData.files.add(MapEntry(
          'payment_proof',
          await MultipartFile.fromFile(booking.paymentProof!.path),
        ));
      }

      final response = await _dio.post(
        'bookings/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response;
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<List<dynamic>> getUserBookings(String accessToken) async {
    try {
      final response = await _dio.get(
        'bookings/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return response.data as List<dynamic>;
    } catch (e) {
      print('Error fetching user bookings: $e');
      return [];
    }
  }

  Response _handleError(dynamic e) {
    if (e is DioException) {
      if (e.response != null) {
        return e.response!;
      } else {
        return Response(requestOptions: RequestOptions(path: ''));
      }
    } else {
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }
}
