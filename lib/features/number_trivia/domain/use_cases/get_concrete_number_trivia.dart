
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/use_casses/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failures.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {

  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) =>
      repository.getConcreteNumberTrivia(params.number);

}

class Params extends Equatable{
  final int number;
  const Params({required this.number});
  @override
  List<Object?> get props => [number];
}
