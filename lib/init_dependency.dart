import 'package:blog_app_cleanarch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_cleanarch/core/network/connection_checker.dart';
import 'package:blog_app_cleanarch/core/secrets/app_secrets.dart';
import 'package:blog_app_cleanarch/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:blog_app_cleanarch/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app_cleanarch/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_cleanarch/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_cleanarch/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app_cleanarch/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:blog_app_cleanarch/features/blog/data/datasources/local/local_data_source.dart';
import 'package:blog_app_cleanarch/features/blog/data/datasources/remote/blog_remote_datasource.dart';
import 'package:blog_app_cleanarch/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_app_cleanarch/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app_cleanarch/features/blog/domain/usecases/get_blogs.dart';
import 'package:blog_app_cleanarch/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app_cleanarch/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/user_sigin_up.dart';

part 'init_dependencies.main.dart';
