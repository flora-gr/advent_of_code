import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 114;
  base.exampleAnswerSecond = 2;

  await base.calculate(9);
}

int _first(List<String> dataLines) {
  final histories = dataLines.map((String line) =>
      line.split(' ').map((String hist) => int.parse(hist)).toList());

  var sum = 0;
  for (List<int> history in histories) {
    var lastDif = history.last;
    while (!history.every((int hist) => hist == 0)) {
      var newHist = <int>[];
      for (int i = 0; i < history.length - 1; i++) {
        newHist.add(history[i + 1] - history[i]);
      }
      history = List.of(newHist);
      lastDif += history.last;
    }
    sum += lastDif;
  }

  return sum;
}

int _second(List<String> dataLines) {
  final histories = dataLines.map((String line) =>
      line.split(' ').map((String hist) => int.parse(hist)).toList());

  var sum = 0;
  for (List<int> history in histories) {
    var firsts = <int>[history.first];
    while (!history.every((int hist) => hist == 0)) {
      var newHist = <int>[];
      for (int i = 0; i < history.length - 1; i++) {
        newHist.add(history[i + 1] - history[i]);
      }
      history = List.of(newHist);
      firsts.add(history.first);
    }

    var current = 0;
    for (int i = firsts.length - 2; i >= 0; i--) {
      current = firsts[i] - current;
    }
    sum += current;
  }

  return sum;
}
