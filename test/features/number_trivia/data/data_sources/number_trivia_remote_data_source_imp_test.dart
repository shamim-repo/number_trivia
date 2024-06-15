import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_imp_test.mocks.dart';

@GenerateMocks([http.Client])
void main(){
  final httpClient = MockClient();
  late NumberTriviaRemoteDataSourceImpl  dataSourceImpl;

  setUp((){
    dataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(httpClient: httpClient);
  });

  const tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
  final Uri concreteUrl = Uri.http('numbersapi.com','/$tNumber');
  final Uri randomUrl = Uri.http('numbersapi.com','/random');

  group('getConcreteNumberTrivia', (){
    group('successful', (){
      setUp((){
        when(httpClient.get(any,headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      });

      test(
          '''Should call GET request on a URL with number endpoint with application/json 
          header return number trivia model if response code 200''',() async{
        //act
        final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(httpClient.get(
            concreteUrl,
            headers: {'Content-Type': 'application/json'}
        ));
        expect(result, tNumberTriviaModel);
      });
    });//successful

    group('unsuccessful', (){
      setUp((){
        when(httpClient.get(any,headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Something wrong!', 404));
      });

      test(
          '''Should throws server exception if response code 404 or other''',() async{
        //act
        final call = dataSourceImpl.getConcreteNumberTrivia;
        //assert
        expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      });
    });//unsuccessful
  });//getConcreteNumberTrivia

  group('getRandomNumberTrivia', (){
    group('successful', (){
      setUp((){
        when(httpClient.get(any,headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      });

      test(
          '''Should call GET request on a URL with random endpoint with application/json 
          header return number trivia model if response code 200''',() async{
        //act
        final result = await dataSourceImpl.getRandomNumberTrivia();
        //assert
        verify(httpClient.get(
            randomUrl,
            headers: {'Content-Type': 'application/json'}
        ));
        expect(result, tNumberTriviaModel);
      });
    });//successful

    group('unsuccessful', (){
      setUp((){
        when(httpClient.get(any,headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('Something wrong!', 404));
      });

      test(
          '''Should throws server exception if response code 404 or other''',() async{
        //act
        final call = dataSourceImpl.getRandomNumberTrivia;
        //assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      });
    });//unsuccessful
  });//getRandomNumberTrivia
}