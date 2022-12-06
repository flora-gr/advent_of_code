import 'dart:io';

Future<void> calculate(int day) async {
  final List<String> example =
      await File('./input/day$day/example').readAsLines();
  final List<String> input = await File('./input/day$day/input').readAsLines();

  final Object firstExampleSolution = calculateFirst(example);
  final Object secondExampleSolution = calculateSecond(example);

  print('Solutions day $day:\n'
      'First part example: $firstExampleSolution, '
      'which is ${_isCorrect(firstExampleSolution, exampleAnswerFirst) ? 'correct' : 'incorrect'}\n'
      'First part solution: ${calculateFirst(input)}\n'
      'Second part example: $secondExampleSolution, '
      'which is ${_isCorrect(secondExampleSolution, exampleAnswerSecond) ? 'correct' : 'incorrect'}\n'
      'Second part solution: ${calculateSecond(input)}\n');
}

late Object Function(List<String> dataLines) calculateFirst;
late Object Function(List<String> dataLines) calculateSecond;
late Object exampleAnswerFirst;
late Object exampleAnswerSecond;

bool _isCorrect(Object exampleSolution, Object exampleAnswer) {
  if (exampleSolution is List && exampleAnswer is List) {
    return exampleSolution.length == exampleAnswer.length &&
        exampleAnswer.every((dynamic element) =>
            exampleSolution[exampleAnswer.indexOf(element)] == element);
  } else {
    return exampleSolution == exampleAnswer;
  }
}
