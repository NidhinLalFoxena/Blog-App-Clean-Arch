import 'package:blog_app_cleanarch/core/error/failures.dart';
import 'package:blog_app_cleanarch/core/usecase/usecase.dart';
import 'package:blog_app_cleanarch/core/common/entities/user.dart';
import 'package:blog_app_cleanarch/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
