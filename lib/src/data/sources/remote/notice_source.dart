import 'package:dio/dio.dart';
import 'package:imdaesomun/src/data/models/notice.dart';

class NoticeSource {
  final Dio _dio;

  const NoticeSource(this._dio);

  Future<List<Notice>> getShNotices() async {
    final response = await _dio.get(
      '/getShNotices',
      options: Options(
        headers: {
          'x-imdaesomun-api-key':
              'U2FsdGVkX18Szkzvd4HgPj5wrSzD4WhlLbEOjc5Poww=',
        },
      ),
    );

    final results = response.data as List<dynamic>;

    return results.map((notice) => Notice.fromJson(notice)).toList();
  }
}
