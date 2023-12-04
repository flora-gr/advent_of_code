import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 13;
  base.exampleAnswerSecond = 30;

  await base.calculate(4);
}

int _first(List<String> dataLines) {
  var total = 0;
  for (String line in dataLines) {
    var data = line.split(':').last.split('|');
    var winningNumbers = _getNumbers(data.first);
    var scratchedNumbers = _getNumbers(data.last);
    var points = 0;
    for (String number in winningNumbers) {
      if (scratchedNumbers.contains(number)) {
        if (points == 0) {
          points = 1;
        } else {
          points *= 2;
        }
      }
    }
    total += points;
  }
  return total;
}

int _second(List<String> dataLines) {
  var cardAmounts = List.generate(dataLines.length, (i) => 1, growable: false);
  for (int i = 0; i < dataLines.length; i++) {
    var data = dataLines[i].split(':').last.split('|');
    var winningNumbers = _getNumbers(data.first);
    var scratchedNumbers = _getNumbers(data.last);
    var numberOfMatches = scratchedNumbers
        .where((String number) => winningNumbers.contains(number))
        .length;
    for (int j = 1; j <= numberOfMatches; j++) {
      cardAmounts[i + j] += 1 * cardAmounts[i];
    }
  }
  return cardAmounts.reduce((a, b) => a + b);
}

Iterable<String> _getNumbers(String part) {
  return part.split(' ').where((String number) => number.isNotEmpty);
}
