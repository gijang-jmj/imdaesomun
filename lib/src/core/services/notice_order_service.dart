import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeOrderService {
  static const String _orderKey = 'notice_order';

  static Future<List<CorporationType>> getNoticeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final orderString = prefs.getStringList(_orderKey);

    if (orderString == null) {
      return [CorporationType.sh, CorporationType.gh];
    }

    return orderString.map((e) => CorporationType.values.byName(e)).toList();
  }

  static Future<void> setNoticeOrder(List<CorporationType> order) async {
    final prefs = await SharedPreferences.getInstance();
    final orderString = order.map((e) => e.name).toList();
    await prefs.setStringList(_orderKey, orderString);
  }
}
