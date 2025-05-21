import 'package:dio/dio.dart';
import 'package:imdaesomun/src/data/models/notice.dart';

class NoticeSource {
  final Dio _dio;

  const NoticeSource(this._dio);

  Future<List<Notice>> getShNotices() async {
    final response = await _dio.get('/getShNotices');

    final results = response.data as List<dynamic>;

    return results.map((notice) => Notice.fromJson(notice)).toList();
  }

  Future<List<Notice>> getGhNotices() async {
    final response = await _dio.get('/getGhNotices');

    final results = response.data as List<dynamic>;

    return results.map((notice) => Notice.fromJson(notice)).toList();
  }

  Future<Notice> getNoticeById(String id) async {
    final response = await _dio.get('/getNoticeById?id=$id');

    final results = response.data as Map<String, dynamic>;

    return Notice.fromJson(results);
  }
}
