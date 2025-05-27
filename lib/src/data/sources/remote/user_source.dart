import 'package:dio/dio.dart';

class UserSource {
  final Dio _dio;

  const UserSource(this._dio);

  Future<void> registerFcmToken({required String token, String? userId}) async {
    await _dio.post(
      '/registerFcmToken',
      data: {'token': token, 'userId': userId},
    );
  }
}
