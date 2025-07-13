import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:imdaesomun/src/core/services/log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeOrderService {
  static const String _orderKey = 'notice_order';
  static const List<CorporationType> defaultOrder = [
    CorporationType.sh,
    CorporationType.gh,
    CorporationType.ih,
    CorporationType.bmc,
  ];

  static Future<List<CorporationType>> getNoticeOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderString = prefs.getStringList(_orderKey);

      if (orderString == null) {
        return defaultOrder;
      }

      final userOrder =
          orderString.map((e) => CorporationType.values.byName(e)).toList();

      final missingCorps =
          defaultOrder.where((corp) => !userOrder.contains(corp)).toList();

      if (missingCorps.isNotEmpty) {
        return [...userOrder, ...missingCorps];
      }

      return userOrder;
    } catch (e) {
      LogService.log(
        '[NoticeOrderService]\n\nError getting notice order',
        error: e.toString(),
      );

      return defaultOrder;
    }
  }

  static Future<void> setNoticeOrder(List<CorporationType> order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderString = order.map((e) => e.name).toList();
      await prefs.setStringList(_orderKey, orderString);
    } catch (e) {
      LogService.log(
        '[NoticeOrderService]\n\nError setting notice order',
        error: e.toString(),
      );
    }
  }
}
