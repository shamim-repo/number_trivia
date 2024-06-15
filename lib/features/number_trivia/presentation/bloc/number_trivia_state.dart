part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

final class EmptyState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}
final class ErrorState extends NumberTriviaState {
  final String message;
  const ErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
final class LoadingState extends NumberTriviaState{
  @override
  List<Object> get props => [];
}

final class LoadedState extends  NumberTriviaState{
  final NumberTrivia numberTrivia;
  const LoadedState({required this.numberTrivia});

  @override
  List<Object> get props => [numberTrivia];
}