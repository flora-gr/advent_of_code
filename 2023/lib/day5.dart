import 'dart:core';
import 'dart:math';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 35;
  base.exampleAnswerSecond = 46;

  await base.calculate(5);
}

int _first(List<String> dataLines) {
  final seeds = dataLines.first
      .split(' ')
      .sublist(1)
      .map((String seed) => int.parse(seed))
      .toList(growable: false);

  final mappings = _getMappings(dataLines);

  for (List<List<int>> mapping in mappings) {
    for (int i = 0; i < seeds.length; i++) {
      var seed = seeds[i];
      for (List<int> calc in mapping) {
        if (seed >= calc[1] && seed < calc[1] + calc[2]) {
          seed += (calc[0] - calc[1]);
          seeds[i] = seed;
          break;
        }
      }
    }
  }

  return seeds.reduce(min);
}

int _second(List<String> dataLines) {
  final seedNumbers = dataLines.first
      .split(' ')
      .sublist(1)
      .map((String seed) => int.parse(seed))
      .toList(growable: false);

  var seedRanges = <(int, int)>[];
  for (int i = 0; i < seedNumbers.length - 1; i = i + 2) {
    seedRanges.add((seedNumbers[i], seedNumbers[i] + seedNumbers[i + 1] - 1));
  }

  final mappings = _getMappings(dataLines);

  for (List<List<int>> mapping in mappings) {
    final newSeedRanges = <(int, int)>[];
    for ((int, int) range in seedRanges) {
      final rangesWithinCalc = <(int, int)>[];
      final leftOverRanges = <(int, int)>[range];
      for (List<int> calc in mapping) {
        final calcRange = (calc[1], calc[1] + calc[2] - 1);
        final calcDiff = calc[0] - calc[1];
        for ((int, int) leftOverRange in List.of(leftOverRanges)) {
          if (leftOverRange.$1 >= calcRange.$1 &&
              leftOverRange.$2 <= calcRange.$2) {
            // seedRange falls within calcRange
            leftOverRanges.remove(leftOverRange);
            rangesWithinCalc.add(
                (leftOverRange.$1 + calcDiff, leftOverRange.$2 + calcDiff));
          } else if (leftOverRange.$1 < calcRange.$1 &&
              leftOverRange.$2 > calcRange.$2) {
            // calcRange falls within seedRange
            leftOverRanges.remove(leftOverRange);
            rangesWithinCalc
                .add((calcRange.$1 + calcDiff, calcRange.$2 + calcDiff));
            leftOverRanges.add((leftOverRange.$1, calcRange.$1 - 1));
            leftOverRanges.add((calcRange.$2 + 1, leftOverRange.$2));
          } else if (leftOverRange.$1 >= calcRange.$1 &&
              leftOverRange.$1 <= calcRange.$2) {
            // seedRange start falls within calcRange
            leftOverRanges.remove(leftOverRange);
            rangesWithinCalc
                .add((leftOverRange.$1 + calcDiff, calcRange.$2 + calcDiff));
            leftOverRanges.add((calcRange.$2 + 1, leftOverRange.$2));
          } else if (leftOverRange.$2 >= calcRange.$1 &&
              leftOverRange.$2 <= calcRange.$2) {
            // seedRange end falls within calcRange
            leftOverRanges.remove(leftOverRange);
            rangesWithinCalc
                .add((calcRange.$1 + calcDiff, leftOverRange.$2 + calcDiff));
            leftOverRanges.add((leftOverRange.$1, calcRange.$1 - 1));
          }
        }
      }
      newSeedRanges.addAll([...leftOverRanges, ...rangesWithinCalc]);
    }
    seedRanges = List.of(newSeedRanges);
  }

  return seedRanges.map(((int, int) range) => range.$1.toInt()).reduce(min);
}

Iterable<List<List<int>>> _getMappings(List<String> dataLines) {
  if (base.dataCache == null) {
    final dataSeparations = <int>[];
    for (int i = 0; i < dataLines.length; i++) {
      if (dataLines[i].isEmpty) {
        dataSeparations.add(i);
      }
    }

    dataSeparations.add(dataLines.length);

    final mappings = <List<List<int>>>[];
    for (int i = 0; i < dataSeparations.length - 1; i++) {
      mappings.add(dataLines
          .sublist(dataSeparations[i] + 2, dataSeparations[i + 1])
          .map((String line) => line
              .split(' ')
              .map((String number) => int.parse(number))
              .toList(growable: false))
          .toList(growable: false));
    }

    base.dataCache = mappings;
  }
  return base.dataCache as Iterable<List<List<int>>>;
}
