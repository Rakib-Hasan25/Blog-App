import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    // here we use class from core (and we can do it ) but can't import anything from datasource and presentation
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();
  Future<Either<Failure, String>> logout();
}
