import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getNumberOfPairs1;
  base.calculateSecond = _getNumberOfPairs2;
  base.exampleAnswerFirst = 2;
  base.exampleAnswerSecond = 4;

  await base.calculate(4);
}

int _getNumberOfPairs1(List<String> dataLines) {
  bool countPair(List<int> firstAssignment, List<int> secondAssignment) =>
      firstAssignment.fallsWithin(secondAssignment) ||
      secondAssignment.fallsWithin(firstAssignment);
  return _getNumberOfPairs(dataLines, countPair);
}

int _getNumberOfPairs2(List<String> dataLines) {
  bool countPair(List<int> firstAssignment, List<int> secondAssignment) =>
      firstAssignment.any((int section) => secondAssignment.contains(section));
  return _getNumberOfPairs(dataLines, countPair);
}

int _getNumberOfPairs(
    List<String> dataLines,
    bool Function(List<int> firstAssignment, List<int> secondAssignment)
        countPair) {
  return dataLines.where((String line) {
    List<int> firstAssignment = _getSections(line.split(',').first);
    List<int> secondAssignment = _getSections(line.split(',').last);
    return countPair(firstAssignment, secondAssignment);
  }).length;
}

List<int> _getSections(String assignment) {
  final Iterable<int> range =
      assignment.split('-').map((String section) => int.parse(section));
  return List<int>.generate(
      range.last + 1 - range.first, (int index) => range.first + index);
}

extension ListExtension on List<int> {
  bool fallsWithin(List<int> other) =>
      every((int section) => other.contains(section));
}
