

import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
// ignore: constant_identifier_names
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource{

  late final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final trivia = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(trivia != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(trivia)));
    }else{
      throw CacheException();
    }
  }
  
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async{
    if(await sharedPreferences.setString(CACHED_NUMBER_TRIVIA,
        json.encode(triviaToCache.toJson()))){
      return;
    }else {
      throw CacheException();
    }
  }

}