import 'dart:io';
import 'dart:core';

Future<void> calculate() async {
  final List<String> example = await File('./input/day1/example').readAsLines();
  final List<String> input = await File('./input/day1/input').readAsLines();

  print('Solutions day 1:');
  _calculateFirst(example, input);
  _calculateSecond(example, input);
}

void _calculateFirst(List<String> example, List<String> input) {
  print(
      'Example highest calories: ${_getMaxCalories(example)} - should be 24000');
  print('Input highest calories: ${_getMaxCalories(input)}');
}

int _getMaxCalories(List<String> dataLines) {
  return _getListOfAddedCaloriesSorted(dataLines).first;
}

void _calculateSecond(List<String> example, List<String> input) {
  print(
      'Example highest three calories total: ${_getTotalOfHighestThree(example)} - should be 45000');
  print(
      'Input highest three calories total: ${_getTotalOfHighestThree(input)}');
}

int _getTotalOfHighestThree(List<String> dataLines) {
  return _getListOfAddedCaloriesSorted(dataLines)
      .take(3)
      .reduce((a, b) => a + b);
}

List<int> _getListOfAddedCaloriesSorted(List<String> dataLines) {
  final List<int> listOfAddedCalories = <int>[];
  int addedCalories = 0;

  for (int i = 0; i < dataLines.length; i++) {
    final calories = int.tryParse(dataLines[i]);
    if (calories != null) {
      addedCalories += calories;
      if (i == dataLines.length - 1) {
        listOfAddedCalories.add(addedCalories);
      }
    } else {
      listOfAddedCalories.add(addedCalories);
      addedCalories = 0;
    }
  }

  listOfAddedCalories.sort((b, a) => a.compareTo(b));
  return listOfAddedCalories;
}
