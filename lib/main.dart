import 'package:flutter/material.dart';
import 'package:number_trivia/injection_container.dart' as di;
void main() async{
  await di.init();
  runApp( const MaterialApp(
    home: Placeholder(),
  ));
}
