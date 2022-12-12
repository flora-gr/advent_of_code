import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst =
      (List<String> dataLines) => _getUniqueTailPositions(dataLines, 2);
  base.calculateSecond =
      (List<String> dataLines) => _getUniqueTailPositions(dataLines, 10);
  base.exampleAnswerFirst = 13;
  base.exampleAnswerSecond = 1;

  await base.calculate(9);
}

int _getUniqueTailPositions(List<String> dataLines, int ropeLength) {
  final List<Knot> rope = List<Knot>.generate(ropeLength, (_) => Knot());
  final Set<String> tailPositions = <String>{'0,0'};

  for (String line in dataLines) {
    final List<String> move = line.split(' ');
    final int steps = int.parse(move.last);

    void moveHead(Knot head) {
      switch (move.first) {
        case 'R':
          head.X++;
          break;
        case 'L':
          head.X--;
          break;
        case 'U':
          head.Y++;
          break;
        case 'D':
          head.Y--;
          break;
      }
    }

    for (int step = 1; step <= steps; step++) {
      moveHead(rope.first);
      for (int i = 1; i < ropeLength; i++) {
        rope[i].follow(rope[i - 1], tailPositions, isLast: i == ropeLength - 1);
      }
    }
  }

  return tailPositions.length;
}

class Knot {
  int X = 0;
  int Y = 0;
}

extension KnotExtension on Knot {
  follow(
    Knot next,
    Set<String> tailPositions, {
    bool isLast = true,
  }) {
    if (!touches(next)) {
      if (next.X == X) {
        Y += (next.Y - Y) ~/ 2;
      } else if (next.Y == Y) {
        X += (next.X - X) ~/ 2;
      } else if (next.X - X == 1 || next.X - X == -1) {
        X = next.X;
        Y += (next.Y - Y) ~/ 2;
      } else if (next.Y - Y == 1 || next.Y - Y == -1) {
        Y = next.Y;
        X += (next.X - X) ~/ 2;
      } else {
        Y += (next.Y - Y) ~/ 2;
        X += (next.X - X) ~/ 2;
      }
    }
    if (isLast) {
      tailPositions.add('$X,$Y');
    }
  }

  bool touches(Knot head) {
    final int xDis = head.X - X;
    final int yDis = head.Y - Y;
    return xDis < 2 && xDis > -2 && yDis < 2 && yDis > -2;
  }
}
