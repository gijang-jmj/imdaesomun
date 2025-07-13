import 'package:imdaesomun/src/core/enums/notice_enum.dart';
import 'package:intl/intl.dart';

class NoticeHelper {
  static CorporationType getCorporationType(String corporation) {
    switch (corporation) {
      case 'sh':
        return CorporationType.sh;
      case 'gh':
        return CorporationType.gh;
      case 'ih':
        return CorporationType.ih;
      case 'bmc':
        return CorporationType.bmc;
      default:
        return CorporationType.sh;
    }
  }

  static bool isNewNotice(int regDate) {
    return DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.fromMillisecondsSinceEpoch(regDate)) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
