import 'package:dio/dio.dart';
import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/data/models/notice.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
