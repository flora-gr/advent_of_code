import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 4361;
  base.exampleAnswerSecond = 467835;

  await base.calculate(3);
}

int _first(List<String> dataLines) {
  final coordinates = _parseCoordinates(dataLines);

  List<int> partNumbers = [];
  for (int y in coordinates.keys) {
    final row = coordinates[y]!;
    var currentNumber = '';
    var currentIsPart = false;
    for (int x in row.keys) {
      bool isInt = int.tryParse(row[x]!) != null;
      if (isInt) {
        currentNumber += row[x]!;
        currentIsPart = currentIsPart || _hasAdjacentSymbol(y, x, coordinates);
      }
      if (!isInt || x == row.length - 1) {
        if (currentNumber.isNotEmpty && currentIsPart) {
          partNumbers.add(int.parse(currentNumber));
        }
        currentNumber = '';
        currentIsPart = false;
      }
    }
  }

  return partNumbers.reduce((a, b) => a + b);
}

int _second(List<String> dataLines) {
  final coordinates = _parseCoordinates(dataLines);

  List<GearAdjacent> partNumbersWithGearSymbols = [];
  for (int y in coordinates.keys) {
    final row = coordinates[y]!;
    var currentNumber = '';
    final gearSymbols = <(int, int)>{};
    for (int x in row.keys) {
      bool isInt = int.tryParse(row[x]!) != null;
      if (isInt) {
        currentNumber += row[x]!;
        gearSymbols.addAll(_getGearSymbols(y, x, coordinates));
      }
      if (!isInt || x == row.length - 1) {
        if (currentNumber.isNotEmpty && gearSymbols.isNotEmpty) {
          partNumbersWithGearSymbols
              .add(GearAdjacent(int.parse(currentNumber), Set.of(gearSymbols)));
        }
        currentNumber = '';
        gearSymbols.clear();
      }
    }
  }

  final sharedGearNumbers = <(int, int), List<GearAdjacent>>{};
  for (GearAdjacent number in partNumbersWithGearSymbols) {
    for ((int, int) gearSymbol in number.gearSymbols) {
      if (sharedGearNumbers.keys.contains(gearSymbol)) {
        sharedGearNumbers[gearSymbol]!.add(number);
      } else {
        sharedGearNumbers[gearSymbol] = [number];
      }
    }
  }

  return (sharedGearNumbers..removeWhere((_, numbers) => numbers.length != 2))
      .values
      .map((List numbers) => numbers.first.number * numbers.last.number)
      .reduce((a, b) => a + b);
}

Map<int, Map<int, String>> _parseCoordinates(List<String> dataLines) {
  if (base.dataCache == null) {
    final coordinates = <int, Map<int, String>>{};
    for (int i = 0; i < dataLines.length; i++) {
      coordinates[i] = <int, String>{};
      final values = dataLines[i].split('');
      for (int j = 0; j < values.length; j++) {
        coordinates[i]![j] = values[j];
      }
    }
    base.dataCache = coordinates;
  }
  return base.dataCache as Map<int, Map<int, String>>;
}

bool _hasAdjacentSymbol(y, x, Map<int, Map<int, String>> coordinates) {
  List<String?> values = [
    coordinates[y - 1]?[x],
    coordinates[y + 1]?[x],
    coordinates[y]?[x - 1],
    coordinates[y]?[x + 1],
    coordinates[y - 1]?[x - 1],
    coordinates[y - 1]?[x + 1],
    coordinates[y + 1]?[x - 1],
    coordinates[y + 1]?[x + 1],
  ];
  return values.any((String? value) =>
          value != null && value != '.' && int.tryParse(value) == null) ==
      true;
}

Iterable<(int y, int x)> _getGearSymbols(
    y, x, Map<int, Map<int, String>> coordinates) {
  List<(String?, int, int)> values = [
    (coordinates[y - 1]?[x], y - 1, x),
    (coordinates[y + 1]?[x], y + 1, x),
    (coordinates[y]?[x - 1], y, x - 1),
    (coordinates[y]?[x + 1], y, x + 1),
    (coordinates[y - 1]?[x - 1], y - 1, x - 1),
    (coordinates[y - 1]?[x + 1], y - 1, x + 1),
    (coordinates[y + 1]?[x - 1], y + 1, x - 1),
    (coordinates[y + 1]?[x + 1], y + 1, x + 1),
  ];
  return values
      .where(((String?, int, int) value) => value.$1 == '*')
      .map(((String?, int, int) value) => (value.$2, value.$3));
}

class GearAdjacent {
  const GearAdjacent(
    this.number,
    this.gearSymbols,
  );

  final int number;
  final Set<(int, int)> gearSymbols;
}
