import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getTopCrates1;
  base.calculateSecond = _getTopCrates2;
  base.exampleAnswerFirst = 'CMZ';
  base.exampleAnswerSecond = 'MCD';

  await base.calculate(5);
}

String _getTopCrates1(List<String> dataLines) {
  void executeMove(
      Map<int, List<String>> stacks, int number, int fromIndex, int toIndex) {
    for (int k = 0; k < number; k++) {
      stacks[toIndex]!.add(stacks[fromIndex]!.last);
      stacks[fromIndex]!.removeLast();
    }
  }

  return _getTopCrates(dataLines, executeMove);
}

String _getTopCrates2(List<String> dataLines) {
  void executeMove(
      Map<int, List<String>> stacks, int number, int fromIndex, int toIndex) {
    final int subStackStart = stacks[fromIndex]!.length - number;
    stacks[toIndex]!.addAll(stacks[fromIndex]!.sublist(subStackStart));
    stacks[fromIndex] = stacks[fromIndex]!.sublist(0, subStackStart);
  }

  return _getTopCrates(dataLines, executeMove);
}

String _getTopCrates(
    List<String> dataLines,
    void Function(Map<int, List<String>> stacks, int number, int fromIndex,
            int toIndex)
        executeMove) {
  final int dataSeparation =
      dataLines.indexOf(dataLines.firstWhere((String line) => line.isEmpty));

  final List<String> initialArrangement = dataLines.sublist(0, dataSeparation);
  final Map<int, List<String>> stacks = <int, List<String>>{};
  final int numberOfStacks =
      int.parse(initialArrangement.last.trim().split(' ').last);
  for (int i = initialArrangement.length - 2; i >= 0; i--) {
    final List<String> locationsOnLevel =
        initialArrangement[i].split('').toList();
    for (int j = 0; j < numberOfStacks; j++) {
      final String location = locationsOnLevel[j * 4 + 1];
      if (location.trim().isNotEmpty) {
        (stacks[j] ??= <String>[]).add(location);
      }
    }
  }

  final List<String> operations = dataLines.sublist(dataSeparation + 1);
  for (String operation in operations) {
    final List<int?> move = operation
        .split(' ')
        .map((String element) => int.tryParse(element))
        .where((int? element) => element != null)
        .toList();
    executeMove(stacks, move[0]!, move[1]! - 1, move[2]! - 1);
  }

  return stacks.values.map((List<String> stack) => stack.last).join();
}
