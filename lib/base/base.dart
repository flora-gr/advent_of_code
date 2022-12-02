import 'dart:io';

Future<void> calculate(int day) async {
  final List<String> example =
      await File('./input/day$day/example').readAsLines();
  final List<String> input = await File('./input/day$day/input').readAsLines();

  final int firstExample = calculateFirst(example);
  final int secondExample = calculateSecond(example);

  print('\nSolutions day $day:\n'
      'First part example: $firstExample, which is ${firstExample == exampleAnswerFirst ? 'correct' : 'incorrect'}\n'
      'First part input: ${calculateFirst(input)}\n'
      'Second part example: $secondExample, which is ${secondExample == exampleAnswerSecond ? 'correct' : 'incorrect'}\n'
      'Second part input: ${calculateSecond(input)}');
}

late int Function(List<String> dataLines) calculateFirst;
late int Function(List<String> dataLines) calculateSecond;
late int exampleAnswerFirst;
late int exampleAnswerSecond;
