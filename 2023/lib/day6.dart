import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 288;
  base.exampleAnswerSecond = 71503;

  await base.calculate(6);
}

int _first(List<String> dataLines) {
  final times = _getIntList(dataLines.first);
  final dists = _getIntList(dataLines.last);

  var winningOptions = <int>[];
  for (int i = 0; i < times.length; i++) {
    winningOptions.add(_getWinningOptionsLength(times[i], dists[i]));
  }

  return winningOptions.reduce((int a, int b) => a * b);
}

int _second(List<String> dataLines) {
  final time = _getInt(dataLines.first);
  final dist = _getInt(dataLines.last);

  return _getWinningOptionsLength(time, dist);
}

List<int> _getIntList(String dataLine) => dataLine
    .split(' ')
    .where((String s) => s.isNotEmpty)
    .toList()
    .sublist(1)
    .map((String s) => int.parse(s))
    .toList();

int _getInt(String dataLine) =>
    int.parse(dataLine.replaceAll(' ', '').split(':').last);

int _getWinningOptionsLength(int time, int dist) {
  var distanceOptions = <int>[];
  for (int j = 0; j <= time; j++) {
    distanceOptions.add((time - j) * j);
  }
  return distanceOptions.where((int option) => option > dist).length;
}
