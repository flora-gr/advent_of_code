import 'dart:core';
import 'base/base.dart' as base;
import 'dart:io';

Future<void> calculate() async {
  base.calculateFirst = _getMinimumNumberOfSteps1;
  base.calculateSecond = _getMinimumNumberOfSteps2;
  base.exampleAnswerFirst = 31;
  base.exampleAnswerSecond = 29;

  alphabeth = await File('./lib/base/alphabet').readAsLines();

  await base.calculate(12);
}

late List<String> alphabeth;

int _getMinimumNumberOfSteps1(List<String> dataLines) {
  final List<Square> map = _getAreaMap(dataLines);
  final Square start = map.singleWhere((Square square) => square.char == 'S');
  return _getMinimumNumberOfSteps(map, <Square>{start});
}

int _getMinimumNumberOfSteps2(List<String> dataLines) {
  final List<Square> map = _getAreaMap(dataLines);
  final Iterable<Square> firstSteps =
      map.where((Square square) => square.char == 'b');
  final Set<Square> startingPositions = map
      .where((Square square) =>
          (square.char == 'S' || square.char == 'a') &&
          firstSteps.any((Square firstStep) => firstStep.isNextTo(square)))
      .toSet();
  return _getMinimumNumberOfSteps(map, startingPositions);
}

List<Square> _getAreaMap(List<String> dataLines) {
  if (base.dataCache == null) {
    final List<Square> map = <Square>[];
    for (int i = 0; i < dataLines.length; i++) {
      final List<String> split = dataLines[i].split('');
      for (int j = 0; j < split.length; j++) {
        map.add(Square(char: split[j], X: j, Y: i));
      }
    }
    base.dataCache = map;
  }
  return base.dataCache as List<Square>;
}

int _getMinimumNumberOfSteps(
  List<Square> map,
  Set<Square> startingQueue,
) {
  final Square end = map.singleWhere((Square square) => square.char == 'E');

  final Set<Square> checked = <Square>{};
  Set<Square> currentQueue = startingQueue;
  final Set<Square> nextQueue = <Square>{};

  int steps = 0;
  while (!nextQueue.contains(end)) {
    for (Square square in currentQueue) {
      Set<Square> nextSteps =
          square.getnextSteps(map, checked, currentQueue).toSet();
      nextQueue.addAll(nextSteps);
    }
    checked.addAll(currentQueue);
    currentQueue = Set<Square>.from(nextQueue);
    if (!nextQueue.contains(end)) {
      nextQueue.clear();
    }
    steps++;
  }
  return steps;
}

class Square {
  Square({
    required this.char,
    required this.X,
    required this.Y,
  });

  final String char;
  final int X;
  final int Y;

  @override
  bool operator ==(Object other) =>
      other is Square &&
      other.runtimeType == runtimeType &&
      other.X == X &&
      other.Y == Y;

  @override
  int get hashCode => '$X,$Y'.hashCode;
}

extension SquareExtension on Square {
  Iterable<Square> getnextSteps(
    List<Square> map,
    Set<Square> checked,
    Set<Square> currentQueue,
  ) {
    return map.where((Square square) =>
        !checked.contains(square) &&
        !currentQueue.contains(square) &&
        square.isNextTo(this) &&
        isMaxOneElevationTo(square));
  }

  bool isMaxOneElevationTo(Square square) =>
      char == 'S' && (square.char == 'a' || square.char == 'b') ||
      (char == 'z' || char == 'y') && square.char == 'E' ||
      alphabeth.indexOf(square.char) - alphabeth.indexOf(char) <= 1;

  bool isNextTo(Square square) =>
      square.X == X && (square.Y - Y == 1 || square.Y - Y == -1) ||
      square.Y == Y && (square.X - X == 1 || square.X - X == -1);
}
