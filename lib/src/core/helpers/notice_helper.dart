import 'package:imdaesomun/src/core/enums/notice_enum.dart';

class NoticeHelper {
  static CorporationType getCorporationType(String corporation) {
    switch (corporation) {
      case 'sh':
        return CorporationType.sh;
      case 'gh':
        return CorporationType.gh;
      default:
        return CorporationType.sh;
    }
  }
}
