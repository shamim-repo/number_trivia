
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:number_trivia/core/error/exception.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource{
  ///Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  ///Calls the http://numbersapi.com/random/trivia endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
 }

 class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
   late http.Client httpClient;

   NumberTriviaRemoteDataSourceImpl({required this.httpClient});

   @override
   Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
     Uri url = Uri.http('numbersapi.com', '/$number');
     return await _getTrivia(url);
   }

   @override
   Future<NumberTriviaModel> getRandomNumberTrivia() async{
     Uri url = Uri.http('numbersapi.com', '/random');
     return await _getTrivia(url);
   }

   Future<NumberTriviaModel> _getTrivia(Uri url) async {
     final response = await httpClient.get(
         url, headers: {'Content-Type': 'application/json'});
     if (response.statusCode == 200) {
       return NumberTriviaModel.fromJson(jsonDecode(response.body));
     } else {
       throw ServerException();
     }
   }
 }