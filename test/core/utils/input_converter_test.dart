

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

void main(){
  late InputConverter inputConverter;

  setUp((){
    inputConverter = InputConverter();
  });
  const tNumberString = '1';
  const tNumber = 1;
  const tNumberStringSigned = '-1';
  const tNumberStringInvalid = 'abc';

  test(
    'Should convert string to integer',() {
      //act
      final actual = inputConverter.stringToUnsignedInteger(tNumberString);
      //assert
      expect(actual, equals(const Right(tNumber)));
  });

  test(
      'Should return invalid input failure when string is not an integer',() {
    //act
    final actual = inputConverter.stringToUnsignedInteger(tNumberStringInvalid);
    //assert
    expect(actual, equals(Left(InvalidInputFailure())));
  });


  test(
      'Should return invalid input failure when string is a negative integer',() {
    //act
    final actual = inputConverter.stringToUnsignedInteger(tNumberStringSigned);
    //assert
    expect(actual, equals(Left(InvalidInputFailure())));
  });

}