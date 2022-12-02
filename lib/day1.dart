import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getMaxCalories;
  base.calculateSecond = _getTotalOfHighestThree;
  base.exampleAnswerFirst = 24000;
  base.exampleAnswerSecond = 45000;

  await base.calculate(1);
}

int _getMaxCalories(List<String> dataLines) {
  return _getListOfAddedCaloriesSorted(dataLines).first;
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
