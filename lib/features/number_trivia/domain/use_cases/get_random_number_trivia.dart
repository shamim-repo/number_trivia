import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/use_casses/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failures.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) =>
      repository.getRandomNumberTrivia();
  }
