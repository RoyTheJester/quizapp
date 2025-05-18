import 'package:flutter/widgets.dart';
import 'package:quizapp/services/models.dart';

// This allows us to tell the listeners to rerender when the state changes
class QuizState with ChangeNotifier {
  // The underscore indicates that these variables are private
  double _progress = 0;
  Option? _selected;

  // We set this PageController up in the quiz_state.dart file so that multiple widgets can use it
  final PageController controller = PageController();

  double get progress => _progress;
  Option? get selected => _selected;

  // Notify listeners is in these so when progress changes so that the UI can be rerendered
  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  set selected(Option? newValue) {
    _selected = newValue;
    notifyListeners();
  }

  void nextPage() async {
    await controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
