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

class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(question.text),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                question.options.map((opt) {
                  return Container(
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.black26,
                    child: InkWell(
                      onTap: () {
                        state.selected = opt;
                        _bottomSheet(context, opt, state);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              state.selected == opt
                                  ? FontAwesomeIcons.circleCheck
                                  : FontAwesomeIcons.circle,
                              size: 30,
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Text(
                                  opt.value,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  /// Bottom sheet shown when Question is answered
  _bottomSheet(BuildContext context, Option opt, QuizState state) {
    bool correct = opt.correct;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(correct ? 'Good Job!' : 'Wrong'),
              Text(
                opt.detail,
                style: const TextStyle(fontSize: 18, color: Colors.white54),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: correct ? Colors.green : Colors.red,
                ),
                child: Text(
                  correct ? 'Onward!' : 'Try Again',
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (correct) {
                    state.nextPage();
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
