import 'dart:io';

Future<void> calculate(int day) async {
  final List<String> example =
      await File('./input/day$day/example').readAsLines();
  final List<String> input = await File('./input/day$day/input').readAsLines();

  dataCache = null;
  final Stopwatch stopwatch = Stopwatch()..start();
  final Object firstExampleSolution = calculateFirst(example);
  stopwatch.stop();
  final int firstExampleTime = stopwatch.elapsedMilliseconds;
  stopwatch
    ..reset()
    ..start();
  final Object secondExampleSolution = calculateSecond(example);
  stopwatch.stop();
  final int secondExampleTime = stopwatch.elapsedMilliseconds;

  dataCache = null;
  stopwatch
    ..reset()
    ..start();
  final Object firstSolution = calculateFirst(input);
  stopwatch.stop();
  final int firstSolutionTime = stopwatch.elapsedMilliseconds;
  stopwatch
    ..reset()
    ..start();
  final Object secondSolution = calculateSecond(input);
  stopwatch.stop();
  final int secondSolutionTime = stopwatch.elapsedMilliseconds;

  print('Solutions day $day:\n'
      'First part example: $firstExampleSolution, '
      'which is ${_isCorrect(firstExampleSolution, exampleAnswerFirst) ? 'correct' : 'incorrect'} (${firstExampleTime}ms)\n'
      'First part solution: $firstSolution (${firstSolutionTime}ms)\n'
      'Second part example: $secondExampleSolution, '
      'which is ${_isCorrect(secondExampleSolution, exampleAnswerSecond) ? 'correct' : 'incorrect'} (${secondExampleTime}ms)\n'
      'Second part solution: $secondSolution (${secondSolutionTime}ms)\n');
}

late Object Function(List<String> dataLines) calculateFirst;
late Object Function(List<String> dataLines) calculateSecond;
late Object exampleAnswerFirst;
late Object exampleAnswerSecond;

Object? dataCache;

bool _isCorrect(Object exampleSolution, Object exampleAnswer) {
  if (exampleSolution is List && exampleAnswer is List) {
    return exampleSolution.length == exampleAnswer.length &&
        exampleAnswer.every((dynamic element) =>
            exampleSolution[exampleAnswer.indexOf(element)] == element);
  } else {
    return exampleSolution == exampleAnswer;
  }
}
