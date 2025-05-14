import 'package:flutter/material.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/bottom_nav.dart';
import 'package:quizapp/shared/error.dart';
import 'package:quizapp/shared/loading.dart';
import 'package:quizapp/topics/drawer.dart';
import 'package:quizapp/topics/topic_item.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We can use the FutureBuilder widget to fetch the topics from the API and display them in a list view based on the topics we get from the API.
    // We type this so that we can get good intellisense and type checking.
    return FutureBuilder<List<Topic>>(
      future: FirestoreService().getTopics(),
      // These are the 4 states that the topic can be in when fetching data from the API.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var topics = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text("Topics"),
            ),

            drawer: TopicDrawer(topics: topics),
            // Using count we put 2 items in a row and they rest follow in the next row infinitely
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        } else {
          return const Text("No topics found in Firestore. Check database.");
        }
      },
    );
  }
}
