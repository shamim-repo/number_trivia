
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
   final tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

   test(
     'Should be a subclass of NumberTrivia entity',
     () {
       //assert
       expect(tNumberTriviaModel, isA<NumberTrivia>());
     }
   );
   
   group('fromJson', (){
     test(
       'Should return a valid model when the JSON number is an integer',
       () {
         //arrange
          final Map<String, dynamic> json = jsonDecode(fixture('trivia.json'));
         //act
         final result = tNumberTriviaModel.fromJson(json);
         //assert
         expect(result, tNumberTriviaModel);
       }
     );

     test(
         'Should return a valid model when the JSON number is a double',
             () {
           //arrange
           final Map<String, dynamic> json = jsonDecode(fixture('trivia_double.json'));
           //act
           final result = tNumberTriviaModel.fromJson(json);
           //assert
           expect(result, tNumberTriviaModel);
         }
     );
   });
   
   group('toJson', (){
     test(
       'Should return a json map with proper data',
       () {
         //arrange
         final expectedJsonMap = {
           'text' : 'Test text',
           'number': 1,
         };
         //act
          final result = tNumberTriviaModel.toJson();
         //assert
         expect(result, expectedJsonMap);
       }
     );

   });


}