import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getEmptyGroundTiles;
  base.calculateSecond = _getNumberOfRounds;
  base.exampleAnswerFirst = 110;
  base.exampleAnswerSecond = 20;

  await base.calculate(23);
}

late Direction firstDirection;

const List<Direction> directions = <Direction>[
  Direction.north,
  Direction.south,
  Direction.west,
  Direction.east,
];

int _getEmptyGroundTiles(List<String> dataLines) {
  final Map<int, List<Position>> elves = _getElves(dataLines);
  firstDirection = directions.first;

  for (int i = 1; i <= 10; i++) {
    _moveElves(elves);
  }

  final List<int> xValues = <int>[];
  for (List<Position> elvesOnY in elves.values) {
    xValues
      ..addAll(elvesOnY.map((Position elve) => elve.X))
      ..sort();
  }
  final List<int> yValues = elves.keys.toList()..sort();

  return (xValues.last - xValues.first + 1) *
          (yValues.last - yValues.first + 1) -
      xValues.length;
}

int _getNumberOfRounds(List<String> dataLines) {
  final Map<int, List<Position>> elves = _getElves(dataLines);
  firstDirection = directions.first;

  int round = 1;
  while (elves.values.any((List<Position> elvesOnY) =>
      elvesOnY.any((Position elve) => !elve.isFree(elves)))) {
    _moveElves(elves);
    round++;
  }

  return round;
}

void _moveElves(Map<int, List<Position>> elves) {
  Map<Position, Position> elvesWithProposedPosition = <Position, Position>{};
  for (List<Position> elvesOnY in elves.values) {
    for (Position elve in elvesOnY) {
      if (!elve.isFree(elves)) {
        Position? proposedPosition = _getProposedPosition(elve, elves);
        if (proposedPosition != null) {
          elvesWithProposedPosition[elve] = proposedPosition;
        }
      }
    }
  }

  for (Position elve in elvesWithProposedPosition.keys) {
    final Position proposed = elvesWithProposedPosition[elve]!;
    if (elvesWithProposedPosition.values
            .where((Position prop) => prop == proposed)
            .length ==
        1) {
      elves[elve.Y]!.remove(elve);
      if (elves[proposed.Y] == null) {
        elves[proposed.Y] = <Position>[];
      }
      elves[proposed.Y]!.add(elvesWithProposedPosition[elve]!);
    }
  }

  firstDirection = directions[(directions.indexOf(firstDirection) + 1) % 4];
}

Position? _getProposedPosition(Position elve, Map<int, List<Position>> elves) {
  for (int i = 0; i < directions.length; i++) {
    Direction directionToLook =
        directions[(directions.indexOf(firstDirection) + i) % 4];
    List<Position> positionsForDirection =
        elve.getPositionsForDirection(directionToLook);
    if (elve.canMove(positionsForDirection, elves)) {
      return positionsForDirection[1];
    }
  }
  return null;
}

Map<int, List<Position>> _getElves(List<String> dataLines) {
  final Map<int, List<Position>> elves = <int, List<Position>>{};
  for (int i = 0; i < dataLines.length; i++) {
    final List<String> split = dataLines[i].split('');
    for (int j = 0; j < split.length; j++) {
      if (split[j] == '#') {
        if (elves[i] == null) {
          elves[i] = <Position>[];
        }
        elves[i]!.add(Position(X: j, Y: i));
      }
    }
  }
  return elves;
}

enum Direction {
  north,
  south,
  east,
  west,
}

class Position {
  Position({
    required this.X,
    required this.Y,
  });

  int X;
  int Y;

  @override
  bool operator ==(Object other) =>
      other is Position &&
      other.runtimeType == runtimeType &&
      other.X == X &&
      other.Y == Y;

  @override
  int get hashCode => '$X,$Y'.hashCode;
}

extension PositionExtension on Position {
  List<Position> getPositionsForDirection(Direction direction) {
    switch (direction) {
      case Direction.north:
        return north();
      case Direction.south:
        return south();
      case Direction.east:
        return east();
      case Direction.west:
        return west();
    }
  }

  List<Position> east() {
    return <Position>[
      Position(X: X + 1, Y: Y - 1),
      Position(X: X + 1, Y: Y),
      Position(X: X + 1, Y: Y + 1),
    ];
  }

  List<Position> west() {
    return <Position>[
      Position(X: X - 1, Y: Y - 1),
      Position(X: X - 1, Y: Y),
      Position(X: X - 1, Y: Y + 1),
    ];
  }

  List<Position> north() {
    return <Position>[
      Position(X: X - 1, Y: Y - 1),
      Position(X: X, Y: Y - 1),
      Position(X: X + 1, Y: Y - 1),
    ];
  }

  List<Position> south() {
    return <Position>[
      Position(X: X - 1, Y: Y + 1),
      Position(X: X, Y: Y + 1),
      Position(X: X + 1, Y: Y + 1),
    ];
  }

  bool canMove(List<Position> positions, Map<int, List<Position>> elves) {
    return positions
        .every((Position pos) => elves[pos.Y]?.contains(pos) != true);
  }

  bool isFree(Map<int, List<Position>> elves) {
    final Set<Position> spaceAround = <Position>{
      ...east(),
      ...west(),
      ...north(),
      ...south(),
    };
    return !spaceAround
        .any((Position pos) => elves[pos.Y]?.contains(pos) == true);
  }
}

// void _visualizeExample(Map<int, List<Position>> elves) {
//   print('Direction: $firstDirection');
//   List<int> ys = List<int>.generate(12, (int i) => i - 2);
//   List<int> xs = List<int>.generate(14, (int i) => i - 3);
//   for (int y in ys) {
//     String toPrint = '';
//     for (int x in xs) {
//       if (elves[y]?.contains(Position(X: x, Y: y)) == true) {
//         toPrint += '#';
//       } else {
//         toPrint += '.';
//       }
//     }
//     print(toPrint);
//   }
//   print('\n');
// }
