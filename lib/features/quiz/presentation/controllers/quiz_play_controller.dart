import 'dart:async';
import 'package:get/get.dart';
import '../../domain/models/quiz_model.dart';
import 'quiz_controller.dart';
import '../../../../routes/app_pages.dart';

class QuizPlayController extends GetxController {
  final QuizController quizController = Get.find<QuizController>();

  static const int questionTimeoutSeconds = 30;

  final RxInt currentIndex = 0.obs;
  final RxBool showFeedback = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxInt score = 0.obs;
  final RxList<String> currentOptions = <String>[].obs;

  // Timer states
  final RxInt remainingSeconds = questionTimeoutSeconds.obs;
  final RxInt totalSecondsElapsed = 0.obs;
  Timer? _questionTimer;
  Timer? _totalDurationTimer;
  Timer? _autoAdvanceTimer;
  bool _isPaused = false;

  List<QuestionModel> get questions => quizController.questionList ?? [];
  QuestionModel get currentQuestion => questions[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    if (questions.isNotEmpty) {
      _loadOptionsForCurrentQuestion();
      _startTimers();
    }
  }

  @override
  void onClose() {
    _cancelAllTimers();
    super.onClose();
  }

  String normalize(String s) =>
      s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

  void _startTimers() {
    _startQuestionTimer();
    _startTotalDurationTimer();
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    remainingSeconds.value = questionTimeoutSeconds;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (remainingSeconds.value > 1) {
        remainingSeconds.value--;
      } else {
        remainingSeconds.value = 0;
        _questionTimer?.cancel();
        _handleTimeout();
      }
    });
  }

  void _startTotalDurationTimer() {
    _totalDurationTimer?.cancel();
    _totalDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !showFeedback.value) {
        totalSecondsElapsed.value++;
      }
    });
  }

  void pauseTimers() {
    _isPaused = true;
  }

  void resumeTimers() {
    _isPaused = false;
  }

  void _cancelAllTimers() {
    _questionTimer?.cancel();
    _questionTimer = null;
    _totalDurationTimer?.cancel();
    _totalDurationTimer = null;
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
  }

  // Load shuffled options for current question
  void _loadOptionsForCurrentQuestion() {
    final q = currentQuestion;
    if (q.type == "boolean") {
      currentOptions.value = ["True", "False"];
    } else {
      final list = [...q.incorrectAnswers, q.correctAnswer];
      list.shuffle();
      currentOptions.value = list;
    }
  }

  // Submit answer
  void submitAnswer(String answer) {
    if (showFeedback.value) return;

    _questionTimer?.cancel();
    selectedAnswer.value = answer;
    showFeedback.value = true;

    if (normalize(answer) == normalize(currentQuestion.correctAnswer)) {
      score.value++;
    }
  }

  // Handle timeout (auto-mark incorrect and auto-advance)
  void _handleTimeout() {
    if (showFeedback.value) return;

    selectedAnswer.value = ""; // Unanswered
    showFeedback.value = true;

    // Auto-advance after 2 seconds as specified in instructions
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(const Duration(seconds: 2), () {
      if (showFeedback.value) {
        next();
      }
    });
  }

  // Move to next question or complete quiz
  void next() {
    _autoAdvanceTimer?.cancel();
    _questionTimer?.cancel();

    if (!showFeedback.value) return;

    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      selectedAnswer.value = "";
      showFeedback.value = false;
      _loadOptionsForCurrentQuestion();
      _startQuestionTimer();
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _cancelAllTimers();
    Get.offNamed(AppPages.resultsPage, arguments: {
      "score": score.value,
      "total": questions.length,
      "totalTime": totalSecondsElapsed.value,
    });
  }

  double get progressPercentage {
    if (questions.isEmpty) return 0.0;
    return (currentIndex.value + 1) / questions.length;
  }

  String get progressText => "${currentIndex.value + 1}/${questions.length}";
}
