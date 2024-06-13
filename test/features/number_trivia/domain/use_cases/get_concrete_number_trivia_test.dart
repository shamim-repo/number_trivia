import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/use_casses/use_case.dart';

import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';


@GenerateMocks([NumberTriviaRepository])
void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository = MockNumberTriviaRepository();
  late GetConcreteNumberTrivia useCase;

  setUp(() {
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'Test text', number: 1);

  test(
    'Should get trivia for the number from repository',
    () async{
      //arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      final result = await useCase(Params(number: tNumber));
      //assert
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      expect(result, Right(tNumberTrivia));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    }
  );
}
