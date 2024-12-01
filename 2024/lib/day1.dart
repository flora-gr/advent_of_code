import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 11;
  base.exampleAnswerSecond = 31;

  await base.calculate(1);
}

int _first(List<String> dataLines) {
  var data = _parseDataLines(dataLines);
  var list1 = data.$1..sort();
  var list2 = data.$2..sort();

  var sumDifference = 0;
  for (int i = 0; i < list1.length; i++) {
    sumDifference += (list1[i] - list2[i]).abs();
  }

  return sumDifference;
}

int _second(List<String> dataLines) {
  var data = _parseDataLines(dataLines);

  var frequency = <int, int>{};
  for (int i in data.$2) {
    if (frequency.keys.contains(i)) {
      frequency[i] = frequency[i]! + 1;
    } else {
      frequency[i] = 1;
    }
  }

  var similarity = 0;
  for (int i in data.$1) {
    similarity += i * (frequency[i] ?? 0);
  }

  return similarity;
}

(List<int>, List<int>) _parseDataLines(List<String> dataLines) {
  if (base.dataCache == null) {
    var list1 = <int>[];
    var list2 = <int>[];
    for (String line in dataLines) {
      var split = line.split('   ');
      list1.add(int.parse(split[0]));
      list2.add(int.parse(split[1]));
    }
    base.dataCache = (list1, list2);
  }
  return base.dataCache as (List<int> a, List<int> b);
}
