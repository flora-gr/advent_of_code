import 'dart:io';
import 'dart:core';

Future<void> calculate() async {
  final List<String> example = await File('./input/day2/example').readAsLines();
  final List<String> input = await File('./input/day2/input').readAsLines();

  print('\nSolutions day 2:');
  _calculateFirst(example, input);
  _calculateSecond(example, input);
}

void _calculateFirst(List<String> example, List<String> input) {
  print('Example score from play: ${_getTotalScore1(example)} - should be 15');
  print('Input score from play: ${_getTotalScore1(input)}');
}

int _getTotalScore1(List<String> dataLines) {
  lineScoreCalculation(List<String> elements) {
    final Play myPlay = elements.last.toPlay();
    return myPlay.toOutcome(elements.first.toPlay()).toScore() +
        myPlay.toScore();
  }

  return _getTotalScore(dataLines, lineScoreCalculation);
}

void _calculateSecond(List<String> example, List<String> input) {
  print(
      'Example score from strategy: ${_getTotalScore2(example)} - should be 12');
  print('Input score from strategy: ${_getTotalScore2(input)}');
}

int _getTotalScore2(List<String> dataLines) {
  lineScoreCalculation(List<String> elements) {
    final Outcome requiredOutcome = elements.last.toOutcome();
    final Play requiredPlay =
        _getRequiredPlay(elements.first.toPlay(), requiredOutcome);
    return requiredOutcome.toScore() + requiredPlay.toScore();
  }

  return _getTotalScore(dataLines, lineScoreCalculation);
}

Play _getRequiredPlay(Play other, Outcome outcome) {
  if (outcome == Outcome.win) {
    return Play.values.singleWhere((Play play) => other.losesFrom(play));
  } else if (outcome == Outcome.lose) {
    return Play.values.singleWhere((Play play) => play.losesFrom(other));
  } else {
    return other;
  }
}

_getTotalScore(List<String> dataLines,
    int Function(List<String> elements) lineScoreCalculation) {
  int totalScore = 0;
  for (String line in dataLines) {
    final List<String> elements = line.split(' ');
    totalScore += lineScoreCalculation(elements);
  }
  return totalScore;
}

enum Play {
  rock,
  paper,
  scissors,
  unknown,
}

enum Outcome {
  win,
  lose,
  draw,
}

extension Stringxtension on String {
  Play toPlay() {
    switch (this) {
      case 'A':
      case 'X':
        return Play.rock;
      case 'B':
      case 'Y':
        return Play.paper;
      case 'C':
      case 'Z':
        return Play.scissors;
      default:
        return Play.unknown;
    }
  }

  Outcome toOutcome() {
    switch (this) {
      case 'X':
        return Outcome.lose;
      case 'Z':
        return Outcome.win;
      case 'Y':
      default:
        return Outcome.draw;
    }
  }
}

extension PlayExtension on Play {
  int toScore() {
    switch (this) {
      case Play.rock:
        return 1;
      case Play.paper:
        return 2;
      case Play.scissors:
      default:
        return 3;
    }
  }

  Outcome toOutcome(Play other) {
    if (losesFrom(other)) {
      return Outcome.lose;
    } else if (other.losesFrom(this)) {
      return Outcome.win;
    } else {
      return Outcome.draw;
    }
  }

  bool losesFrom(Play other) {
    return this == Play.rock && other == Play.paper ||
        this == Play.paper && other == Play.scissors ||
        this == Play.scissors && other == Play.rock;
  }
}

extension OutcomeValueExtension on Outcome {
  int toScore() {
    switch (this) {
      case Outcome.win:
        return 6;
      case Outcome.lose:
        return 0;
      case Outcome.draw:
      default:
        return 3;
    }
  }
}
