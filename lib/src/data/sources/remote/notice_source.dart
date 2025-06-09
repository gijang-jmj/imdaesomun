import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/models/notice_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeException implements Exception {
  final String code;
  final String message;

  NoticeException({required this.code, required this.message});
}

class NoticeSource {
  final Dio _dio;
  final User? _user;

  const NoticeSource(this._dio, this._user);

  Future<List<Notice>> getShNotices() async {
    final response = await _dio.get('/getShNotices');
    final results = response.data as List<dynamic>;
    final notices = results.map((notice) => Notice.fromJson(notice)).toList();

    // 정확한 순서 정렬을 위해 no 필드를 기준으로 내림차순 정렬
    notices.sort((a, b) => b.no.compareTo(a.no));
    return notices;
  }

  Future<List<Notice>> getGhNotices() async {
    final response = await _dio.get('/getGhNotices');
    final results = response.data as List<dynamic>;
    final notices = results.map((notice) => Notice.fromJson(notice)).toList();

    // 정확한 순서 정렬을 위해 no 필드를 기준으로 내림차순 정렬
    notices.sort((a, b) => b.no.compareTo(a.no));

    return notices;
  }

  Future<Notice> getNoticeById(String id) async {
    final response = await _dio.get('/getNoticeById?noticeId=$id');
    final results = response.data as Map<String, dynamic>;

    return Notice.fromJson(results);
  }

  Future<bool> isLatestShNotices() async {
    final response = await _dio.get('/getLatestScrapeTs');
    final results = response.data as Map<String, dynamic>;
    final ts = results[CorporationType.sh.name];

    String? serverTs;

    if (ts == null) return false;

    if (ts is Map && ts.containsKey('_seconds')) {
      serverTs = ts['_seconds'].toString();
    } else if (ts is String) {
      serverTs = ts;
    }

    if (serverTs == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final latestScrapeTsKey = "latest_sh_scrape_ts";
    final localTs = prefs.getString(latestScrapeTsKey);

    if (serverTs != localTs) {
      await prefs.setString(latestScrapeTsKey, serverTs);
      return false;
    }

    return true;
  }

  Future<bool> isLatestGhNotices() async {
    final response = await _dio.get('/getLatestScrapeTs');
    final results = response.data as Map<String, dynamic>;
    final ts = results[CorporationType.gh.name];

    String? serverTs;

    if (ts == null) return false;

    if (ts is Map && ts.containsKey('_seconds')) {
      serverTs = ts['_seconds'].toString();
    } else if (ts is String) {
      serverTs = ts;
    }

    if (serverTs == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final latestScrapeTsKey = "latest_gh_scrape_ts";
    final localTs = prefs.getString(latestScrapeTsKey);

    if (serverTs != localTs) {
      await prefs.setString(latestScrapeTsKey, serverTs);
      return false;
    }

    return true;
  }

  Future<void> saveNotice(String id) async {
    if (_user == null) {
      throw NoticeException(
        code: 'user-not-authenticated',
        message: 'User not authenticated',
      );
    }

    await _dio.post('/saveNotice', data: {'noticeId': id, 'userId': _user.uid});
  }

  Future<void> deleteNotice(String id) async {
    if (_user == null) {
      throw NoticeException(
        code: 'user-not-authenticated',
        message: 'User not authenticated',
      );
    }

    await _dio.post(
      '/deleteNotice',
      data: {'noticeId': id, 'userId': _user.uid},
    );
  }

  Future<bool> getNoticeSaved(String id) async {
    if (_user == null) {
      throw NoticeException(
        code: 'user-not-authenticated',
        message: 'User not authenticated',
      );
    }

    final response = await _dio.get(
      '/getNoticeSaved',
      queryParameters: {'noticeId': id, 'userId': _user.uid},
    );

    return response.data['saved'] as bool;
  }

  Future<NoticePagination> getSavedNotices({
    required int offset,
    int? limit,
    String? corporation,
  }) async {
    if (_user == null) {
      throw NoticeException(
        code: 'user-not-authenticated',
        message: 'User not authenticated',
      );
    }

    final response = await _dio.get(
      '/getSavedNotices',
      queryParameters: {
        'userId': _user.uid,
        'offset': offset,
        'limit': limit,
        'corporation': corporation,
      },
    );
    final results = response.data as Map<String, dynamic>;

    return NoticePagination.fromJson(results);
  }
}
