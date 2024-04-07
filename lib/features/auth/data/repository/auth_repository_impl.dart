import 'package:blog_app_cleanarch/core/error/exeption.dart';
import 'package:blog_app_cleanarch/core/error/failures.dart';
import 'package:blog_app_cleanarch/core/common/entities/user.dart';
import 'package:blog_app_cleanarch/core/network/connection_checker.dart';
import 'package:blog_app_cleanarch/features/auth/data/modal/user_modal.dart';
import 'package:blog_app_cleanarch/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.authRemoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = authRemoteDataSource.currentUserSection;

        if (session == null) {
          return left(Failure('User Not Logged in'));
        }

        return right(UserModal(
          id: session.user.id,
          name: "",
          email: session.user.email ?? "",
        ));
      }
      final user = await authRemoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(Failure('User Not Logged in'));
      }

      return right(user);
    } on ServerExeption catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No Internet Connection'));
      }
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExeption catch (e) {
      return left(Failure(e.message));
    }
  }
}
