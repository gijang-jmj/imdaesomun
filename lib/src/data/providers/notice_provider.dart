import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/dio_service.dart';
import 'package:imdaesomun/src/data/repositories/notice_repository.dart';
import 'package:imdaesomun/src/data/sources/remote/notice_source.dart';

final noticeProvider = Provider<NoticeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NoticeRepositoryImpl(noticeSource: NoticeSource(dio));
});
