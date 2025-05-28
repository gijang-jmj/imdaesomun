import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imdaesomun/src/data/models/notice.dart';

class NoticeLocalSource {
  static const String _shKey = 'sh_notices';
  static const String _ghKey = 'gh_notices';

  Future<List<Notice>?> getShNotices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_shKey);
    if (cached == null) return null;
    final List<dynamic> jsonList = jsonDecode(cached);
    return jsonList.map((e) => Notice.fromJson(e)).toList();
  }

  Future<List<Notice>?> getGhNotices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_ghKey);
    if (cached == null) return null;
    final List<dynamic> jsonList = jsonDecode(cached);
    return jsonList.map((e) => Notice.fromJson(e)).toList();
  }

  Future<void> saveShNotices(List<Notice> notices) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _shKey,
      jsonEncode(notices.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> saveGhNotices(List<Notice> notices) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _ghKey,
      jsonEncode(notices.map((e) => e.toJson()).toList()),
    );
  }

  Future<Notice?> getNoticeById(String id) async {
    final shList = await getShNotices();
    if (shList != null) {
      try {
        return shList.firstWhere((n) => n.id == id);
      } catch (_) {}
    }
    final ghList = await getGhNotices();
    if (ghList != null) {
      try {
        return ghList.firstWhere((n) => n.id == id);
      } catch (_) {}
    }
    return null;
  }
}
