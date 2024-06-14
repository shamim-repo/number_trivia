import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';


@GenerateMocks([NetworkInfo, NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource])
void main(){
  final  networkInfo = MockNetworkInfo();
  final  remoteDataSource = MockNumberTriviaRemoteDataSource();
  final  localDataSource = MockNumberTriviaLocalDataSource();
  late  NumberTriviaRepositoryImpl repository ;

  const tNumber = 1;
  const tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: tNumber);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  setUp((){
      repository =NumberTriviaRepositoryImpl(
          networkInfo: networkInfo,
          localDataSource: localDataSource,
          remoteDataSource: remoteDataSource);
  });

   group('getConcreteNumberTrivia', () {
     setUp(() {
       when(networkInfo.isConnected).thenAnswer((_) async => true);
       when(remoteDataSource.getConcreteNumberTrivia(tNumber))
           .thenAnswer((_) async => tNumberTriviaModel);
     });
     test(
         'Should check if device is online', () async {
       await repository.getConcreteNumberTrivia(tNumber);
       //assert
       verify(networkInfo.isConnected);
     });

     group('when device online', () {
       setUp(() {
         when(networkInfo.isConnected).thenAnswer((_) async => true);
       });

       group('when remote data successful', () {
         setUp(() {
           when(remoteDataSource.getConcreteNumberTrivia(tNumber))
               .thenAnswer((_) async => tNumberTriviaModel);
         });

         test(
             'Should return Number trivia when remote data source successful', () async {
           //arrange
           //act
           final result = await repository.getConcreteNumberTrivia(tNumber);
           //assert
           verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
           expect(result, equals(const Right(tNumberTrivia)));
         }
         );

         test(
             'Should cache trivia after remote dat source is successful', () async {
           //arrange
           //act
           await repository.getConcreteNumberTrivia(tNumber);
           //assert
           verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
         });
       });//when remote data successful

       group('when remote data unsuccessful', () {
         setUp(() {

           when(remoteDataSource.getConcreteNumberTrivia(tNumber))
               .thenThrow(ServerException());
         });

         test(
             'Should return server failure when remote data source is unsuccessful', () async {
           //arrange
           //act
           final result = await repository.getConcreteNumberTrivia(tNumber);
           //assert
           verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
           verifyNoMoreInteractions(localDataSource);
           expect(result,  equals(Left(ServerFailure())));
         });
       }); //when remote data unsuccessful
     }); //when device is online

     group('when device offline', () {
       setUp(() {
         when(networkInfo.isConnected).thenAnswer((_) async => false);
       });

       group('when local data successful', () {
         setUp(() {
           when(localDataSource.getLastNumberTrivia())
               .thenAnswer((_) async => tNumberTriviaModel);
         });
         test(
             'Should return number trivia from cached data', () async {
           //arrange
           //act
           final result = await repository.getConcreteNumberTrivia(tNumber);
           //assert
           verifyNoMoreInteractions(remoteDataSource);
           verify(localDataSource.getLastNumberTrivia());
           expect(result, equals(const Right(tNumberTrivia)));
         });
       });//when remote data successful

       group('when local data unsuccessful', () {
         setUp(() {

           when(localDataSource.getLastNumberTrivia())
               .thenThrow(CacheException());
         });

         test(
             'Should return cache failure when cache data source is unsuccessful', () async {
           //arrange
           //act
           final result = await repository.getConcreteNumberTrivia(tNumber);
           //assert
           verify(localDataSource.getLastNumberTrivia());
           verifyNoMoreInteractions(remoteDataSource);
           expect(result,  equals(Left(CacheFailure())));
         });
       }); //when local data unsuccessful
     }); //when device is offline
   });//group: getConcreteNumberTrivia

   group('getRandomNumberTrivia', () {
     setUp(() {
       when(networkInfo.isConnected).thenAnswer((_) async => true);
       when(remoteDataSource.getRandomNumberTrivia())
           .thenAnswer((_) async => tNumberTriviaModel);
     });
     test(
         'Should check if device is online', () async {
       await repository.getRandomNumberTrivia();
       //assert
       verify(networkInfo.isConnected);
     });

     group('when device online', () {
       setUp(() {
         when(networkInfo.isConnected).thenAnswer((_) async => true);
       });

       group('when remote data successful', () {
         setUp(() {
           when(remoteDataSource.getRandomNumberTrivia())
               .thenAnswer((_) async => tNumberTriviaModel);
         });

         test(
             'Should return Number trivia when remote data source successful', () async {
           //arrange
           //act
           final result = await repository.getRandomNumberTrivia();
           //assert
           verify(remoteDataSource.getRandomNumberTrivia());
           expect(result, equals(const Right(tNumberTrivia)));
         }
         );

         test(
             'Should cache trivia after remote dat source is successful', () async {
           //arrange
           //act
           await repository.getRandomNumberTrivia();
           //assert
           verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
         });
       });//when remote data successful

       group('when remote data unsuccessful', () {
         setUp(() {
           when(remoteDataSource.getRandomNumberTrivia())
               .thenThrow(ServerException());
         });

         test(
             'Should return server failure when remote data source is unsuccessful', () async {
           //arrange
           //act
           final result = await repository.getRandomNumberTrivia();
           //assert
           verify(remoteDataSource.getRandomNumberTrivia());
           verifyNoMoreInteractions(localDataSource);
           expect(result,  equals(Left(ServerFailure())));
         });
       }); //when remote data unsuccessful
     }); //when device is online

     group('when device offline', () {
       setUp(() {
         when(networkInfo.isConnected).thenAnswer((_) async => false);
       });

       group('when local data successful', () {
         setUp(() {
           when(localDataSource.getLastNumberTrivia())
               .thenAnswer((_) async => tNumberTriviaModel);
         });
         test(
             'Should return number trivia from cached data', () async {
           //arrange
           //act
           final result = await repository.getRandomNumberTrivia();
           //assert
           verifyNoMoreInteractions(remoteDataSource);
           verify(localDataSource.getLastNumberTrivia());
           expect(result, equals(const Right(tNumberTrivia)));
         });
       });//when remote data successful

       group('when local data unsuccessful', () {
         setUp(() {

           when(localDataSource.getLastNumberTrivia())
               .thenThrow(CacheException());
         });

         test(
             'Should return cache failure when cache data source is unsuccessful', () async {
           //arrange
           //act
           final result = await repository.getRandomNumberTrivia();
           //assert
           verify(localDataSource.getLastNumberTrivia());
           verifyNoMoreInteractions(remoteDataSource);
           expect(result,  equals(Left(CacheFailure())));
         });
       }); //when local data unsuccessful
     }); //when device is offline
   });//group: getRandomTrivia

}