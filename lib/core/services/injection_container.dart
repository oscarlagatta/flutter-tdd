import 'package:get_it/get_it.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

/*
* This will initialize every dependency,
* if we had more than one bloc it will create all them
* here...
* And later when we need them the (sl) find that bloc and will
* retrieve the bloc for us...
* */
Future<void> init() async {
  // sl() will find where we initialize the dependency.
  // sl.registerFactory(
  //     () => AuthenticationCubit(createUser: sl(), getUsers: sl()));
  //
  // sl.registerLazySingleton(() => CreateUser(sl()));
  //
  // sl.registerLazySingleton(() => GetUsers(sl()));


  // Using cascade operator example below...
  sl
    // application logic
    ..registerFactory(
        () => AuthenticationCubit(createUser: sl(), getUsers: sl()))

    // use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    //  Repositories
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(sl()),
    )

    // Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthRemoteDataSrcImp(sl()))

    // External Dependencies from outside world.
    ..registerLazySingleton(http.Client.new);
}
