import 'package:dio/dio.dart';

class UserSource {
  final Dio _dio;

  const UserSource(this._dio);

  Future<void> registerToken({required String token, String? userId}) async {
    await _dio.post('/registerToken', data: {'token': token, 'userId': userId});
  }
}
