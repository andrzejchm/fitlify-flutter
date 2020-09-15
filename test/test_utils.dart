import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> expectEitherFuture<L, R>(Future<Either<L, R>> actual, dynamic matcher) async => expectEither(await actual, matcher);

void expectEither<L, R>(Either<L, R> actual, dynamic matcher) => expect(actual.fold((l) => l, (r) => r), matcher);
