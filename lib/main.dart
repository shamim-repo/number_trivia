import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:number_trivia/injection_container.dart' as di;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const NumberTriviaApp() );
}

class NumberTriviaApp extends StatelessWidget {
  const NumberTriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(primaryColor: Colors.redAccent),
      home: const NumberTriviaPage(),
    );
  }
}

