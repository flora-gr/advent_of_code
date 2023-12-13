import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 405;
  base.exampleAnswerSecond = 400;

  await base.calculate(13);
}

int _first(List<String> dataLines) {
  return _getMirrorSum(dataLines);
}

int _second(List<String> dataLines) {
  return _getMirrorSum(dataLines, checkSmudge: true);
}

int _getMirrorSum(
  List<String> dataLines, {
  bool checkSmudge = false,
}) {
  final patterns = <List<String>>[];
  var startIndex = 0;
  for (int i = 0; i <= dataLines.length; i++) {
    if (i == dataLines.length || dataLines[i].isEmpty) {
      patterns.add(dataLines.sublist(startIndex, i));
      startIndex = i + 1;
    }
  }

  var sum = 0;
  for (List<String> pattern in patterns) {
    int? horizontal = _getHorizontalMirror(pattern, checkSmudge: checkSmudge);
    if (horizontal != null) {
      sum += horizontal * 100;
    } else {
      final vertical = _getVerticalMirror(pattern, checkSmudge: checkSmudge)!;
      sum += vertical;
    }
  }

  return sum;
}

int? _getHorizontalMirror(List<String> pattern, {bool checkSmudge = false}) {
  int? horizontal;
  for (int i = 1; (i < pattern.length && horizontal == null); i++) {
    final linesFrom = <int>[];
    for (int j = 0; ((i - j - 1) >= 0 && i + j < pattern.length); j++) {
      linesFrom.add(j);
    }

    if (checkSmudge) {
      final nonMatching =
          linesFrom.where((int j) => pattern[i + j] != pattern[i - j - 1]);
      if (nonMatching.length == 1 &&
          _almostMatch(pattern[i + nonMatching.single],
              pattern[i - nonMatching.single - 1])) {
        horizontal = i;
      }
    } else {
      if (linesFrom.every((int j) => pattern[i + j] == pattern[i - j - 1])) {
        horizontal = i;
      }
    }
  }
  return horizontal;
}

int? _getVerticalMirror(List<String> pattern, {bool checkSmudge = false}) {
  final splitPattern = pattern.map((String row) => row.split('')).toList();
  final transposition = <List<String>>[];
  for (int row = 0; row < splitPattern.length; row++) {
    for (int col = 0; col < splitPattern[0].length; col++) {
      if (transposition.length < col + 1) {
        transposition.add([]);
      }
      transposition[col].add(splitPattern[row][col]);
    }
  }
  final transposedPattern =
      transposition.map((List<String> row) => row.join()).toList();

  return _getHorizontalMirror(transposedPattern, checkSmudge: checkSmudge);
}

bool _almostMatch(String first, String second) {
  final s1 = first.split('');
  final s2 = second.split('');
  var nonMatch = 0;
  for (int i = 0; i < s1.length; i++) {
    if (s1[i] != s2[i]) {
      nonMatch++;
    }
  }
  return nonMatch == 1;
}
