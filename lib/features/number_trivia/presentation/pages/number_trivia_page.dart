import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_controller.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
          backgroundColor: Colors.redAccent,
        ),
        body: SingleChildScrollView(child: buildBody(context))
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
          child: Column(
            children: <Widget>[
              //top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  switch(state) {
                    case EmptyState():
                      return const MessageDisplay(message: 'Start Searching!');
                    case ErrorState():
                      return MessageDisplay(message: state.message);
                    case LoadingState():
                      return const LoadingWidget();
                    case LoadedState():
                      return TriviaDisplay(numberTrivia: state.numberTrivia);
                  }
                },
              ),
              const SizedBox(height: 30,),
              //bottom half
              const TriviaControl(),

            ],
          ),
        ),
      ),
    );
  }
}
