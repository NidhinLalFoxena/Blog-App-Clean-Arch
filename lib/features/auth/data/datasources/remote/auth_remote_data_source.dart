import 'package:blog_app_cleanarch/core/error/exeption.dart';
import 'package:blog_app_cleanarch/features/auth/data/modal/user_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSection;
  Future<UserModal> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModal> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModal?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSection => supabaseClient.auth.currentSession;

  @override
  Future<UserModal> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const ServerExeption('User is null');
      }
      return UserModal.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<UserModal> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(email: email, password: password, data: {
        'name': name,
      });
      if (response.user == null) {
        throw const ServerExeption('User is null');
      }
      return UserModal.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<UserModal?> getCurrentUserData() async {
    try {
      if (currentUserSection != null) {
        final userDta = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSection!.user.id,
            );

        return UserModal.fromJson(userDta.first).copyWith(
          email: currentUserSection!.user.email,
        );
      }

      return null;
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }
}
