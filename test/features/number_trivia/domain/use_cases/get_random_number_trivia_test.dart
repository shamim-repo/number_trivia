

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/use_casses/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main(){
  MockNumberTriviaRepository mockNumberTriviaRepository = MockNumberTriviaRepository();
  late GetRandomNumberTrivia useCase;

  setUp((){
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: "Test text", number: tNumber);

  test(
    'Should get a random number trivia from repository',
    () async{
      //arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
      .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final  result= await useCase(NoParams());
      //assert
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      expect(result, const Right(tNumberTrivia));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    }
  );

}
