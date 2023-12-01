import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _passOnce;
  base.calculateSecond = _passThrice;
  base.exampleAnswerFirst = 18;
  base.exampleAnswerSecond = 54;

  await base.calculate(24);
}

const String rock = '#';
const String free = '.';

late Map<int, List<Position>> map;
late Map<int, List<Blizzard>> blizzards;

int _passOnce(List<String> dataLines) {
  _fillMapAndBlizards(dataLines);

  final Position start = map[0]![1];
  final Position end = map[map.length - 1]![map[map.length - 1]!.length - 2];

  return _passThroughBlizzards(start, end);
}

int _passThrice(List<String> dataLines) {
  _fillMapAndBlizards(dataLines);

  final Position start = map[0]![1];
  final Position end = map[map.length - 1]![map[map.length - 1]!.length - 2];

  int minutes = _passThroughBlizzards(start, end);
  minutes += _passThroughBlizzards(end, start);
  minutes += _passThroughBlizzards(start, end);

  return minutes;
}

int _passThroughBlizzards(Position begin, Position goal) {
  int minutes = 0;
  Set<Position> queue = <Position>{...begin.getAdjacentFree()};
  final Set<Position> nextQueue = <Position>{};
  while (!queue.contains(goal)) {
    _shiftBlizzards();
    for (Position pos in queue) {
      nextQueue.addAll(pos.getAdjacentFree());
    }
    queue = Set<Position>.from(nextQueue);
    nextQueue.clear();
    minutes++;
  }
  return minutes;
}

void _fillMapAndBlizards(List<String> dataLines) {
  map = <int, List<Position>>{};
  blizzards = <int, List<Blizzard>>{};
  for (int i = 0; i < dataLines.length; i++) {
    map[i] = <Position>[];
    blizzards[i] = <Blizzard>[];
    final List<String> split = dataLines[i].split('');
    for (int j = 0; j < split.length; j++) {
      final String element = split[j];
      if (element == rock) {
        map[i]!.add(Position(X: j, Y: i, isRock: true));
      } else {
        if (element != free) {
          blizzards[i]!.add(Blizzard(
            direction: element,
            position: Position(X: j, Y: i),
          ));
        }
        map[i]!.add(Position(X: j, Y: i));
      }
    }
  }
}

void _shiftBlizzards() {
  final Map<int, List<Blizzard>> newBlizzards = <int, List<Blizzard>>{
    for (int row in map.keys) row: <Blizzard>[]
  };
  for (int row in blizzards.keys) {
    for (Blizzard blizzard in blizzards[row]!) {
      Position currentPos = blizzard.position;
      Position? nextPos;
      if (blizzard.direction == '>') {
        nextPos = map[row]![currentPos.X + 1];
        if (nextPos.isRock) {
          nextPos = map[row]![1];
        }
      } else if (blizzard.direction == '<') {
        nextPos = map[row]![currentPos.X - 1];
        if (nextPos.isRock) {
          nextPos = map[row]![map[row]!.length - 2];
        }
      } else if (blizzard.direction == '^') {
        nextPos = map[row - 1]![currentPos.X];
        if (nextPos.isRock) {
          nextPos = map[map.length - 2]![currentPos.X];
        }
      } else if (blizzard.direction == 'v') {
        nextPos = map[row + 1]![currentPos.X];
        if (nextPos.isRock) {
          nextPos = map[1]![currentPos.X];
        }
      }
      blizzard.position = nextPos!;
      newBlizzards[blizzard.position.Y]!.add(blizzard);
    }
  }
  blizzards = newBlizzards;
}

class Blizzard {
  Blizzard({
    required this.direction,
    required this.position,
  });

  final String direction;
  Position position;
}

class Position {
  Position({
    required this.X,
    required this.Y,
    this.isRock = false,
  });

  int X;
  int Y;
  bool isRock;

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
  Iterable<Position> getAdjacentFree() {
    return <Position>[
      ...map[Y]!.where((Position pos) =>
          (pos.X == X || pos.X == X + 1 || pos.X == X - 1) &&
          !pos.isRock &&
          !blizzards[Y]!.any((Blizzard blizzard) => blizzard.position == pos)),
      if (map[Y - 1] != null)
        ...map[Y - 1]!.where((Position pos) =>
            pos.X == X &&
            !pos.isRock &&
            !blizzards[Y - 1]!
                .any((Blizzard blizzard) => blizzard.position == pos)),
      if (map[Y + 1] != null)
        ...map[Y + 1]!.where((Position pos) =>
            pos.X == X &&
            !pos.isRock &&
            !blizzards[Y + 1]!
                .any((Blizzard blizzard) => blizzard.position == pos)),
    ];
  }
}
