import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/use_casses/use_case.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

import '../../domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MASSEGE= 'Server Failure';
const String CACHE_FAILURE_MASSEGE= 'Cache Failure';
const String INVALID_INPUT_FAILURE_MASSEGE =
    'Invalid Input- The number must be zero or an integer';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) :super(EmptyState()) {
    on<GetConcreteNumberTriviaEvent>((event, emit) async {
      final convertedNumber = inputConverter.stringToUnsignedInteger(
          event.numberString);
      convertedNumber.fold(
              (failure) {
            emit(const ErrorState(message: INVALID_INPUT_FAILURE_MASSEGE));
          },
              (number) async {
            emit(LoadingState());
            final result = await getConcreteNumberTrivia(
                Params(number: number));
            result.fold(
                    (failure) {
                  emit(ErrorState(message: _mapFailureToMessage(failure)));
                },
                    (trivia) {
                  emit(LoadedState(numberTrivia: trivia));
                }
            );
          }
      );
    });
    on<GetRandomNumberTriviaEvent>((event, emit) async {
      emit(LoadingState());
      final result = await getRandomNumberTrivia(NoParams());
      result.fold(
              (failure) {
            emit(ErrorState(message: _mapFailureToMessage(failure)));
          },
              (trivia) {
            emit(LoadedState(numberTrivia: trivia));
          }
      );
    });
  }

  String _mapFailureToMessage(Failure failure){
    switch(failure){
      case ServerFailure _: return SERVER_FAILURE_MASSEGE;
      case CacheFailure _: return CACHE_FAILURE_MASSEGE;
      default : return 'Unexpected Error';
    }
  }
}
