class Question {
  String title;
  String topic;
  List<String> answers;
  int correctAnswerIndex;

  Question({
    required this.title,
    required this.topic,
    required this.answers,
    required this.correctAnswerIndex,
  });
}
