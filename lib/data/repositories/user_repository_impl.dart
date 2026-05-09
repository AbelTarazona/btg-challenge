import 'package:btgproject/core/utils/mock_delay.dart';
import 'package:btgproject/data/datasources/user_local_datasource.dart';
import 'package:btgproject/domain/entities/user.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _dataSource;

  UserRepositoryImpl({required UserLocalDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<User> getUser() async {
    return withMockDelay(
      () async {
        final model = await _dataSource.getUser();
        return model.toEntity();
      },
      delay: const Duration(milliseconds: 800),
    );
  }
}
