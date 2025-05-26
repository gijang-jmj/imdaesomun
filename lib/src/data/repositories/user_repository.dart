import 'package:imdaesomun/src/data/sources/remote/user_source.dart';

abstract class UserRepository {
  Future<void> registerToken({required String token, String? userId});
}

class UserRepositoryImpl implements UserRepository {
  final UserSource _userSource;

  const UserRepositoryImpl({required UserSource userSource})
    : _userSource = userSource;

  @override
  Future<void> registerToken({required String token, String? userId}) async {
    await _userSource.registerToken(token: token, userId: userId);
  }
}
