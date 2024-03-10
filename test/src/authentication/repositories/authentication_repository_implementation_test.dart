import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  // for each test we want to create

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException =
      APIException(message: 'Unknown Error Occurred', statusCode: 500);

  // TDD test driven development
  // 1.- We test we are calling the dependency, Call the remote data source.

  // 2.- Check if the method returns the proper data.
  // 2.1.- Make sure that it return the proper data if there is no exception.
  // //  check if when the remote data source throws an exception we
  // //  returns a Failure or if it doesn't we return the actual expected data.

  group('createUser', () {
    const createdAt = 'something.createdAt';
    const name = 'something.name';
    const avatar = 'something.avatar';

    test(
        'should call [RemoteDataSource.createUser] and completes '
        'successful when the call to the remote source is successful',
        () async {
      // check that remote source's createUser gets called and with the
      // correct data

      // arrange
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer(
        // when we want to return `void` we use Future.value()
        (_) async => Future.value(),
      );

      // act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // assert
      expect(result, equals(const Right(null)));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [ServerFailure] when the call to the remote '
        'source is unsuccessful', () async {
      // arrange
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenThrow(tException);

      // act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // assert
      expect(
        result,
        equals(
          Left(
              APIFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUsers', () {
    test(
        'should call the [RemoteDataSource.getUsers] and return [List<User>]'
        ' when call to remote source is successful', () async {
      // arrange
      when(
        () => remoteDataSource.getUsers(),
      ).thenAnswer((_) async => []);

      final result = await repoImpl.getUsers();

      expect(result, isA<Right<dynamic, List<User>>>());

      verify(() => remoteDataSource.getUsers()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [APIFailure] when the call to the remote '
            'source is unsuccessful', () async {
      // arrange
      when(
            () => remoteDataSource.getUsers(),
      ).thenThrow(tException);

      // act
      final result = await repoImpl.getUsers();


      // assert
      expect(
        result,
        equals(
          Left(
            APIFailure.fromException(tException),
          ),
        ),
      );

      verify(() => remoteDataSource.getUsers()).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
