import 'package:dio/dio.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:imdaesomun/src/data/models/notice_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeSource {
  final Dio _dio;

  const NoticeSource(this._dio);

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

  Future<List<Notice>> getIhNotices() async {
    final response = await _dio.get('/getIhNotices');
    final results = response.data as List<dynamic>;
    final notices = results.map((notice) => Notice.fromJson(notice)).toList();

    // 정확한 순서 정렬을 위해 no 필드를 기준으로 내림차순 정렬
    notices.sort((a, b) => b.no.compareTo(a.no));

    return notices;
  }

  Future<List<Notice>> getBmcNotices() async {
    final response = await _dio.get('/getBmcNotices');
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

  Future<bool> isLatestBmcNotices() async {
    final response = await _dio.get('/getLatestScrapeTs');
    final results = response.data as Map<String, dynamic>;
    final ts = results[CorporationType.bmc.name];

    String? serverTs;

    if (ts == null) return false;

    if (ts is Map && ts.containsKey('_seconds')) {
      serverTs = ts['_seconds'].toString();
    } else if (ts is String) {
      serverTs = ts;
    }

    if (serverTs == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final latestScrapeTsKey = "latest_bmc_scrape_ts";
    final localTs = prefs.getString(latestScrapeTsKey);

    if (serverTs != localTs) {
      await prefs.setString(latestScrapeTsKey, serverTs);
      return false;
    }

    return true;
  }

  Future<bool> isLatestIhNotices() async {
    final response = await _dio.get('/getLatestScrapeTs');
    final results = response.data as Map<String, dynamic>;
    final ts = results[CorporationType.ih.name];

    String? serverTs;

    if (ts == null) return false;

    if (ts is Map && ts.containsKey('_seconds')) {
      serverTs = ts['_seconds'].toString();
    } else if (ts is String) {
      serverTs = ts;
    }

    if (serverTs == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final latestScrapeTsKey = "latest_ih_scrape_ts";
    final localTs = prefs.getString(latestScrapeTsKey);

    if (serverTs != localTs) {
      await prefs.setString(latestScrapeTsKey, serverTs);
      return false;
    }

    return true;
  }

  Future<void> saveNotice({
    required String noticeId,
    required String userId,
  }) async {
    await _dio.post(
      '/saveNotice',
      data: {'noticeId': noticeId, 'userId': userId},
    );
  }

  Future<void> deleteNotice({
    required String noticeId,
    required String userId,
  }) async {
    await _dio.post(
      '/deleteNotice',
      data: {'noticeId': noticeId, 'userId': userId},
    );
  }

  Future<bool> getNoticeSaved({
    required String noticeId,
    required String userId,
  }) async {
    final response = await _dio.get(
      '/getNoticeSaved',
      queryParameters: {'noticeId': noticeId, 'userId': userId},
    );

    return response.data['saved'] as bool;
  }

  Future<NoticePagination> getSavedNotices({
    required String userId,
    required int offset,
    int? limit,
    String? corporation,
  }) async {
    final response = await _dio.get(
      '/getSavedNotices',
      queryParameters: {
        'userId': userId,
        'offset': offset,
        'limit': limit,
        'corporation': corporation,
      },
    );
    final results = response.data as Map<String, dynamic>;

    return NoticePagination.fromJson(results);
  }
}
