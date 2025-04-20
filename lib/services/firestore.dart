import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/services/models.dart';

// We use rxdart to create a stream of quizzes and topics provides utility methods to transform and combine streams easily. This is very helpful when working with Firebase Firestore

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reads all documents from the topics collection
  Future<List<Topic>> getTopics() async {
    // Reference the 'topics' collection in Firestore
    var ref = _db.collection('topics');

    // Fetch all documents from the 'topics' collection
    var snapshot = await ref.get();

    // Map each document's data to a Topic object and return the list of Topic objects
    return snapshot.docs.map((doc) => Topic.fromJson(doc.data())).toList();
  }

  // Retrieves a single quiz document
  Future<Quiz> getQuiz(String quizId) async {
    // Reference the 'quizzes' collection in Firestore
    var ref = _db.collection('quizzes').doc(quizId);

    // Fetch the document with the specified quizId
    var snapshot = await ref.get();

    // Return a Quiz object created from the document's data
    // If the document does not exist, return an empty Quiz object
    return Quiz.fromJson(snapshot.data() ?? {});
  }
}
