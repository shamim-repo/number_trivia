

import 'package:number_trivia/core/error/exception.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource{
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Cached the recent [NumberTriviaModel] which was gotten from
  /// the api.
  ///
  /// Throws [CacheException] .
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);

}