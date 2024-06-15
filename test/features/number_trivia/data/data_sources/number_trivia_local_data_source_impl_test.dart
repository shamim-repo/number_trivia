import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main(){
  final MockSharedPreferences sharedPreferences = MockSharedPreferences();
  late NumberTriviaLocalDataSourceImpl localDataSource;


  setUp((){
    localDataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: sharedPreferences);
  });

  group('getLastNumberTrivia', (){
    final tNumberTriviaModel=  NumberTriviaModel.fromJson(
        jsonDecode(fixture('trivia_cache.json')));

    group('successful', () {
      setUp(() {
        when(sharedPreferences.getString(any)).thenReturn(
            fixture('trivia_cache.json'));
      });
      test(
          'Should return number trivia model when there is one on the cached', () async {
        //act
        final result = await localDataSource.getLastNumberTrivia();
        //assert
        verify(sharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      });
    });
    group('failed', () {
      setUp(() {
        when(sharedPreferences.getString(any)).thenReturn(null);
      });
      test(
          'Should throw cache exception when there is no cached', () async {
        //act
        final call = localDataSource.getLastNumberTrivia;
        //assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      });
    });
  });

  group('cacheNumberTrivia', (){
    const tNumberTriviaModel=  NumberTriviaModel(text: 'Test text', number: 1);

    group('successful', () {
      setUp(() {
        when(sharedPreferences.setString(any,any))
            .thenAnswer((_) async=> Future.value(true));
      });
      test(
          'Should check sharedPreferences.setString() is called', () async {
        //act
        localDataSource.cacheNumberTrivia(tNumberTriviaModel);
        //assert
        verify(sharedPreferences.setString(CACHED_NUMBER_TRIVIA,
            jsonEncode(tNumberTriviaModel.toJson())));
      });
    });
    group('failed', () {
      setUp(() {
        when(sharedPreferences.setString(any,any))
          .thenAnswer((_) async=> Future.value(false));
      });
      test(
          'Should throw cache exception when setString failed', () async {
        //act
        final call = localDataSource.cacheNumberTrivia;
        //assert
        expect(() => call(tNumberTriviaModel), throwsA(const TypeMatcher<CacheException>()));
      });
    });
  });

}