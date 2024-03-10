import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'authentication_repository.mock.dart';

void main() {
  late GetUsers useCase;
  late AuthenticationRepository repository;

  // run before all tests. Runs once
  // setUpAll(() => null);

  setUp(() {
    repository = MockAuthRepo();
    useCase = GetUsers(repository);
  });

  const tResponse = [User.empty()];

  test('should call the [AuthRepo.getUsers] and return [List<User>]', () async {
    // Arrange
    // STUB
    when(
      () => repository.getUsers(),
    ).thenAnswer(
      (_) async => const Right(tResponse),
    );

    // Act
    final result = await useCase();

    // Assert
    // what data we expect
    expect(
      result,
      equals(
        const Right<dynamic, List<User>>(tResponse),
      ),
    );
    // make sure that when createdUser was called
    verify(
      () => repository.getUsers(),
    ).called(1);

    verifyNoMoreInteractions(repository);
  });
}
