import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class ApiKeyInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add API key to headers before the request
    final apiKey = await _storage.read(key: 'imdaesomun_api_key');
    if (apiKey != null) {
      options.headers['x-imdaesomun-api-key'] = apiKey;
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      try {
        // Fetch new API key from FirebaseRemoteConfig
        final remoteConfig = FirebaseRemoteConfig.instance;
        await remoteConfig.fetchAndActivate();
        final newApiKey = remoteConfig.getString('imdaesomun_api_key');

        // Save the new API key to secure storage
        await _storage.write(key: 'imdaesomun_api_key', value: newApiKey);

        // Retry the failed request with the new API key
        final retryRequest = err.requestOptions;
        retryRequest.headers['x-imdaesomun-api-key'] = newApiKey;

        final response = await Dio().fetch(retryRequest);
        return handler.resolve(response);
      } catch (e) {
        // Handle errors during API key refresh
        return handler.reject(err);
      }
    }
    super.onError(err, handler);
  }
}
