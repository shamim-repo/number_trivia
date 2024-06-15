import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

import 'network_info_test.mocks.dart';



@GenerateMocks([DataConnectionChecker])
void main(){
  final MockDataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
  late NetworkInfoImpl networkInfo;


  setUp((){
    networkInfo = NetworkInfoImpl(dataConnectionChecker: mockDataConnectionChecker);
  });

  group('is connected',(){
    setUp((){
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    });

    test(
      'Should forward the call to DataConnectionChecker.hasConnection()',() async{
        //act
        final result = await networkInfo.isConnected;
        //assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, true);
    });
  });

  group('not connected',(){
    setUp((){
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => false);
    });

    test(
        'Should forward the call to DataConnectionChecker.hasConnection()',() async{
      //act
      final result = await networkInfo.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, false);
    });
  });

}