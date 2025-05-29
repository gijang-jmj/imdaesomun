import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imdaesomun/src/core/constants/router_path_constant.dart';

/// 다이얼로그 라우트로 이동하는 헬퍼 함수
void showCustomDialog(BuildContext context, Widget dialog) {
  context.push(RouterPathConstant.dialog.path, extra: {'dialog': dialog});
}
