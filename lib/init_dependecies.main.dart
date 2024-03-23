/*
suppose a children need to eat food but he won't need to take the food from the  
refrigerator, beacause he can create problems , his main goal to eat food not to take food,
his parent will take the food from the refrigerator for his
*/
/*


.registerLazySingleton--> create only one instance
.registerFactory---> create multiple instances

*/

import 'package:blogapp/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/core/secrets/app_secrets.dart';
import 'package:blogapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blogapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blogapp/features/auth/domain/repository/auth_repository.dart';
import 'package:blogapp/features/auth/domain/repository/usecases/current_user.dart';
import 'package:blogapp/features/auth/domain/repository/usecases/user_login.dart';
import 'package:blogapp/features/auth/domain/repository/usecases/user_logout.dart';
import 'package:blogapp/features/auth/domain/repository/usecases/user_sign_up.dart';
import 'package:blogapp/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:blogapp/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blogapp/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blogapp/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blogapp/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blogapp/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blogapp/features/blog/domain/usecases/upload_blogs.dart';
import 'package:blogapp/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// final serviceLocator = GetIt.instance;

// Future<void> initDependencies() async {
//   _initAuth();
//   _initBlog();
//   final supabase = await Supabase.initialize(
//     url: AppSecrets.supabaseUrl,
//     anonKey: AppSecrets.supabaseAnonKey,
//   );

//   serviceLocator.registerLazySingleton(() => supabase.client);
//   // when i call

//   Hive.defaultDirectory = (await getApplicationDocumentsDirectory())
//       .path; // get a path for hive directory using path provider

//   serviceLocator.registerLazySingleton(
//     () => Hive.box(name: 'blogs'),
//   );

//   serviceLocator.registerFactory(() => InternetConnection());

//   // core
//   serviceLocator.registerLazySingleton(
//     () => AppUserCubit(),
//   );

//   serviceLocator.registerFactory<ConnectionChecker>(
//     () => ConnectionCheckerImpl(
//       serviceLocator(),
//     ),
//   );
// }

// void _initAuth() {
//   //Datasource
//   serviceLocator
//     ..registerFactory<AuthRemoteDateSource>(
//         () => AuthRemoteDataSourceImpl(serviceLocator()))
//     //repository
//     ..registerFactory<AuthRepository>(
//         () => AuthRepositoryImpl(serviceLocator(), serviceLocator()))
//     //use cases
//     ..registerFactory(
//       () => UserSignUp(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => UserLogin(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => CurrentUser(
//         serviceLocator(),
//       ),
//     )

//     //bloc
//     // Bloc
//     ..registerLazySingleton(
//       () => AuthBloc(
//         userSignUp: serviceLocator(),
//         userLogin: serviceLocator(),
//         currentUser: serviceLocator(),
//         appUserCubit: serviceLocator(),
//       ),
//     );
// }

// // void _initAuth() {
// //   serviceLocator
// //       .registerFactory(() => AuthRemoteDataSourceImpl(serviceLocator()));

// //       // when i am calling AuthRemoteDataSourceImpl it will return a new instance
// // }

// void _initBlog() {
//   // Datasource
//   serviceLocator
//     ..registerFactory<BlogRemoteDataSource>(
//       () => BlogRemoteDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory<BlogLocalDataSource>(
//       () => BlogLocalDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     // Repository
//     ..registerFactory<BlogRepository>(
//       () => BlogRepositoryImpl(
//         serviceLocator(),
//         serviceLocator(),
//         serviceLocator(),
//       ),
//     )
//     // Usecases
//     ..registerFactory(
//       () => UploadBlog(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => GetAllBlogs(
//         serviceLocator(),
//       ),
//     )
//     // Bloc
//     ..registerLazySingleton(
//       () => BlogBloc(
//         uploadBlog: serviceLocator(),
//         getAllBlogs: serviceLocator(),
//       ),
//     );
// }




final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDateSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UserLogout(serviceLocator()))
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        userLogout: serviceLocator()
      ),
    );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}