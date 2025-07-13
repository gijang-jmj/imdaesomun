import 'package:flutter/material.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';

enum CorporationType { sh, gh, ih, bmc }

extension CorporationTypeExtension on CorporationType {
  String get korean {
    switch (this) {
      case CorporationType.sh:
        return "서울주택도시공사";
      case CorporationType.gh:
        return "경기주택도시공사";
      case CorporationType.ih:
        return "인천도시공사";
      case CorporationType.bmc:
        return "부산도시공사";
    }
  }

  Color get color {
    switch (this) {
      case CorporationType.sh:
        return AppColors.sh;
      case CorporationType.gh:
        return AppColors.gh;
      case CorporationType.ih:
        return AppColors.ih;
      case CorporationType.bmc:
        return AppColors.bmc;
    }
  }
}
