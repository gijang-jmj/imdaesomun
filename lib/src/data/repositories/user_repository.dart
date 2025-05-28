import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdaesomun/src/core/services/dio_service.dart';
import 'package:imdaesomun/src/data/sources/remote/user_source.dart';

abstract class UserRepository {
  Future<void> registerFcmToken({required String token, String? userId});
}

class UserRepositoryImpl implements UserRepository {
  final UserSource _userSource;

  const UserRepositoryImpl({required UserSource userSource})
    : _userSource = userSource;

  @override
  Future<void> registerFcmToken({required String token, String? userId}) async {
    await _userSource.registerFcmToken(token: token, userId: userId);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepositoryImpl(userSource: UserSource(dio));
});
