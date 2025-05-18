import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz_state.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/loading.dart';
import 'package:quizapp/shared/progress_bar.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.quizId});
  final String quizId;

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider allows you to manage the state of the QuizState class in a centralized and reusable way.
    // This is cleaner than using a StatefulWidget, where the state would be tightly coupled to the widget itself.
    return ChangeNotifierProvider(
      // Create a new QuizState instance
      create: (_) => QuizState(),
      // Getting the quiz data from Firestore
      // The FutureBuilder widget is used to build the UI based on the state of a future (in this case, the quiz data).
      child: FutureBuilder<Quiz>(
        future: FirestoreService().getQuiz(quizId),
        builder: (context, snapshot) {
          var state = Provider.of<QuizState>(context);

          if (!snapshot.hasData || snapshot.hasError) {
            return Loader();
          } else {
            var quiz = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: AnimatedProgressbar(value: state.progress),
                leading: IconButton(
                  icon: const Icon(FontAwesomeIcons.xmark),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              // The PageView widget allows us to create a scrollable list of pages
              // We could define our pages manually but we are using the builder method which allows us to build the pages dynamically based on the data we fetch from Firestore
              body: PageView.builder(
                // Many applications allow swiping left and right to navigate between pages but we don't want that here
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: state.controller,
                onPageChanged:
                    (int index) =>
                        state.progress = (index / (quiz.questions.length + 1)),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return StartPage(quiz: quiz);
                  } else if (index == quiz.questions.length + 1) {
                    return CongratsPage(quiz: quiz);
                  } else {
                    return QuestionPage(question: quiz.questions[index - 1]);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key, required this.quiz});
  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    // We use provider to get the parent PageView so that we can control it from inside this widget
    var state = Provider.of<QuizState>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(quiz.title, style: Theme.of(context).textTheme.headlineMedium),
          const Divider(),
          Expanded(child: Text(quiz.description)),
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: state.nextPage,
                label: const Text("Start Quiz!"),
                icon: const Icon(Icons.poll),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  const CongratsPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congrats! You completed the ${quiz.title} quiz',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Image.asset('assets/congrats.gif'),
          const Divider(),
          ElevatedButton.icon(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            icon: const Icon(FontAwesomeIcons.check),
            label: const Text(' Mark Complete!'),
            onPressed: () {
              FirestoreService().updateUserReport(quiz);
              // We use pushNamedAndRemoveUntil to remove all the previous routes from the stack so that the user cannot go back to the quiz screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/topics',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
