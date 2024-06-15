

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/use_casses/use_case.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';


@GenerateMocks([GetRandomNumberTrivia,GetConcreteNumberTrivia,InputConverter])
void main(){
  final MockGetRandomNumberTrivia getRandomNumberTrivia = MockGetRandomNumberTrivia();
  final MockGetConcreteNumberTrivia getConcreteNumberTrivia= MockGetConcreteNumberTrivia();
  final MockInputConverter inputConverter = MockInputConverter();
  late NumberTriviaBloc bloc;

  setUp(() {
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter);
  });

  test(
      'initial state should be empty ',() {
    //assert
    expect(bloc.state, equals(EmptyState()));
  });

  group('GetConcreteNumberTrivia', (){
    const numberString = '1';
    final convertedNumber = int.parse(numberString);
    const numberTrivia =  NumberTrivia(text: 'Test text', number: 1);


    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should call [InputConverter] and convert input string to integer',
        setUp: (){
          when(inputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(convertedNumber));
          when(getConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(numberTrivia));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const GetConcreteNumberTriviaEvent(numberString: numberString)),
        verify: (_) {
          verify(inputConverter.stringToUnsignedInteger(numberString));
        },

    );


    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should return [Error] when input is invalid',
        setUp: (){
          when(inputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const GetConcreteNumberTriviaEvent(numberString: numberString)),
        expect: () => [const ErrorState(message: INVALID_INPUT_FAILURE_MASSEGE)]
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should call GetConcreteTrivia and emit [LoadingState(),LoadedState()]',
        setUp: (){
          when(inputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(convertedNumber));
          when(getConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(numberTrivia));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const GetConcreteNumberTriviaEvent(numberString: numberString)),
        verify: (_) {
          verify(getConcreteNumberTrivia(Params(number: convertedNumber)));
        },
        expect: () => [LoadingState(),const LoadedState(numberTrivia: numberTrivia)]
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should Return [ErrorSate(SERVER_FAILURE_MASSEGE)] when GetConcrete Failed',
        setUp: (){
          when(inputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(convertedNumber));
          when(getConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const GetConcreteNumberTriviaEvent(numberString: numberString)),
        expect: () => [LoadingState(),const ErrorState(message: SERVER_FAILURE_MASSEGE)]
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should Return [ErrorSate(CACHE_FAILURE_MASSEGE)] when GetConcrete Failed',
        setUp: (){
          when(inputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(convertedNumber));
          when(getConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const GetConcreteNumberTriviaEvent(numberString: numberString)),
        expect: () => [LoadingState(),const ErrorState(message: CACHE_FAILURE_MASSEGE)]
    );
  });//GetConcreteNumberTrivia

  group('GetRandomNumberTrivia', (){
    const numberTrivia =  NumberTrivia(text: 'Test text', number: 1);

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should call GetRandomTrivia and emit [LoadingState(),LoadedState()]',
        setUp: (){
          when(getRandomNumberTrivia(any))
              .thenAnswer((_) async => const Right(numberTrivia));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(GetRandomNumberTriviaEvent()),
        verify: (_) {
          verify(getRandomNumberTrivia(NoParams()));
        },
        expect: () => [LoadingState(),const LoadedState(numberTrivia: numberTrivia)]
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should Return [ErrorSate(SERVER_FAILURE_MASSEGE)] when GetRandomTrivia Failed',
        setUp: (){
          when(getRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(GetRandomNumberTriviaEvent()),
        expect: () => [LoadingState(),const ErrorState(message: SERVER_FAILURE_MASSEGE)]
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
        'Should Return [ErrorSate(CACHE_FAILURE_MASSEGE)] when GetRandomTrivia Failed',
        setUp: (){
          when(getRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(GetRandomNumberTriviaEvent()),
        expect: () => [LoadingState(),const ErrorState(message: CACHE_FAILURE_MASSEGE)]
    );
  });//GetRandomNumberTrivia


}