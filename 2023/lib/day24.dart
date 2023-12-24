import 'dart:core';
import 'dart:math';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 2;
  base.exampleAnswerSecond = 0;

  await base.calculate(24);
}

int _first(List<String> dataLines) {
  final hails = <Hail>[];
  for (String line in dataLines) {
    final numbers = line.split(' @ ');
    final coord =
        numbers[0].split(', ').map((String num) => int.parse(num)).toList();
    final veloc =
        numbers[1].split(', ').map((String num) => int.parse(num)).toList();
    hails.add(Hail(coord[0], coord[1], coord[2], veloc[0], veloc[1], veloc[2]));
  }

  final lowLim = dataLines.length > 5 ? 200000000000000 : 7;
  final highLim = dataLines.length > 5 ? 400000000000000 : 25;

  var crossing = 0;
  for (Hail first in hails) {
    final firstA = first.vy / first.vx;
    final firstB = first.y - (first.x * firstA);
    for (Hail second in hails.where((Hail other) => other != first)) {
      final secondA = second.vy / second.vx;
      final secondB = second.y - (second.x * secondA);
      if (firstA != secondA) {
        final intersectX = (secondB - firstB) / (firstA - secondA);
        if (intersectX >= lowLim &&
            intersectX <= highLim &&
            _isInFuture(first, intersectX) &&
            _isInFuture(second, intersectX)) {
          final intersectY = intersectX * firstA + firstB;
          if (intersectY >= lowLim && intersectY <= highLim) {
            crossing++;
          }
        }
      }
    }
  }

  return crossing ~/ 2;
}

bool _isInFuture(Hail hail, double intersectX) {
  return (intersectX - hail.x) / hail.vx > 0;
}

int _second(List<String> dataLines) {
  return 0;
}

class Hail {
  const Hail(
    this.x,
    this.y,
    this.z,
    this.vx,
    this.vy,
    this.vz,
  );

  final int x;
  final int y;
  final int z;
  final int vx;
  final int vy;
  final int vz;
}
