part of 'init_dependency.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supbase = await Supabase.initialize(
    anonKey: AppSecrets.supabaseKey,
    url: AppSecrets.supabaseUrl,
  );

  //hive

  Hive.defaultDirectory = (await getApplicationCacheDirectory()).path;

  serviceLocator.registerLazySingleton(() => supbase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  // core

  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectioncheckerImpl(serviceLocator()));
}

void _initAuth() {
  // auth remote data source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )

    // auth repository
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
        ))

    // auth usecases

    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurentUser(serviceLocator()))

    // auth bloc
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}

void _initBlog() {
  // blog remote data source

  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
        () => BlogRemoteDataSourceImpl(serviceLocator()))

    // blog local data source

    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocator()))

    // blog repository

    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ))

    // blog usecases

    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))

    // blog bloc
    ..registerLazySingleton(() => BlogBloc(
          uploadBlog: serviceLocator(),
          getAllBlogs: serviceLocator(),
        ));
}
