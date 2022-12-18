import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getTowerHeight1;
  base.calculateSecond = _getTowerHeight2;
  base.exampleAnswerFirst = 3068;
  base.exampleAnswerSecond = 1514285714288;

  await base.calculate(17);
}

late int currentJet;
late int currentRock;
late int numberOfRocks;
late Map<int, List<Position>> occupied;
late int cycleHeight;
late int cyclesSkipped;
int? cycleLength;
late Map<int, int> highestList;
late Map<int, String> patterns;

int _getTowerHeight1(List<String> dataLines) {
  return _getTowerHeight(dataLines, 2022);
}

int _getTowerHeight2(List<String> dataLines) {
  return _getTowerHeight(dataLines, 1000000000000);
}

int _getTowerHeight(List<String> dataLines, int maxRocks) {
  final List<String> jetPattern = dataLines.single.split('');
  _resetTower();

  while (numberOfRocks <= maxRocks) {
    final int highestOccupied = (occupied.keys.toList()..sort()).last;
    Rock rock = _createNewRock(highestOccupied);
    bool settled = false;
    while (!settled) {
      _pushRock(jetPattern, rock);
      settled = !rock.moveDown();
    }
    for (Position position in rock.positions) {
      if (occupied[position.Y] == null) {
        occupied[position.Y] = <Position>[];
      }
      occupied[position.Y]!.add(position);
    }

    if (cycleLength == null) {
      cycleLength = _getRepetitiveCycleLength();
      if (cycleLength != null) {
        final int numberOfRocksLeft = maxRocks - numberOfRocks;
        cyclesSkipped = (numberOfRocksLeft / cycleLength!).floor();
        numberOfRocks += cycleLength! * cyclesSkipped;
      }
    }
    numberOfRocks++;
  }

  return (occupied.keys.toList()..sort()).last + (cycleHeight * cyclesSkipped);
}

void _resetTower() {
  currentJet = 0;
  currentRock = 5;
  numberOfRocks = 1;
  occupied = <int, List<Position>>{
    0: List<Position>.generate(7, (int i) => Position(X: i, Y: 0)),
  };
  cycleHeight = 0;
  cyclesSkipped = 0;
  cycleLength = null;
  highestList = <int, int>{};
  patterns = <int, String>{};
}

Rock _createNewRock(int highestOccupied) {
  int startHeight = highestOccupied + 4;
  if (currentRock == 5) {
    currentRock = 1;
  } else {
    currentRock++;
  }
  switch (currentRock) {
    case 1:
      return Rock.create1(height: startHeight);
    case 2:
      return Rock.create2(height: startHeight);
    case 3:
      return Rock.create3(height: startHeight);
    case 4:
      return Rock.create4(height: startHeight);
    case 5:
    default:
      return Rock.create5(height: startHeight);
  }
}

void _pushRock(List<String> jetPattern, Rock rock) {
  final String jet = jetPattern[currentJet];
  if (jet == '>') {
    rock.moveRight();
  } else {
    rock.moveLeft();
  }
  if (currentJet == jetPattern.length - 1) {
    currentJet = 0;
  } else {
    currentJet++;
  }
}

int? _getRepetitiveCycleLength() {
  // Somehow the pattern only stabilizes after a while
  if (occupied.length > 200) {
    final int highest = (occupied.keys.toList()..sort()).last;
    final String pattern = 'rock$currentRock-jet$currentJet-'
        '${occupied[highest]!.map((Position occup) => occup.X)}-'
        '${occupied[highest - 1]!.map((Position occup) => occup.X)}-'
        '${occupied[highest - 2]!.map((Position occup) => occup.X)}-';
    if (patterns.containsValue(pattern)) {
      final MapEntry<int, String> previous = patterns.entries
          .singleWhere((MapEntry<int, String> entry) => entry.value == pattern);
      cycleHeight = highest - highestList[previous.key]!;
      return numberOfRocks - previous.key;
    }
    highestList[numberOfRocks] = highest;
    patterns[numberOfRocks] = pattern;
  }
  return null;
}

class Rock {
  Rock({
    required this.positions,
  });

  final List<Position> positions;

  static Rock create1({required int height}) {
    return Rock(positions: <Position>[
      Position(X: 2, Y: height),
      Position(X: 3, Y: height),
      Position(X: 4, Y: height),
      Position(X: 5, Y: height),
    ]);
  }

  static Rock create2({required int height}) {
    return Rock(positions: <Position>[
      Position(X: 3, Y: height),
      Position(X: 2, Y: height + 1),
      Position(X: 3, Y: height + 1),
      Position(X: 4, Y: height + 1),
      Position(X: 3, Y: height + 2),
    ]);
  }

  static Rock create3({required int height}) {
    return Rock(positions: <Position>[
      Position(X: 2, Y: height),
      Position(X: 3, Y: height),
      Position(X: 4, Y: height),
      Position(X: 4, Y: height + 1),
      Position(X: 4, Y: height + 2),
    ]);
  }

  static Rock create4({required int height}) {
    return Rock(positions: <Position>[
      Position(X: 2, Y: height),
      Position(X: 2, Y: height + 1),
      Position(X: 2, Y: height + 2),
      Position(X: 2, Y: height + 3),
    ]);
  }

  static Rock create5({required int height}) {
    return Rock(positions: <Position>[
      Position(X: 2, Y: height),
      Position(X: 3, Y: height),
      Position(X: 2, Y: height + 1),
      Position(X: 3, Y: height + 1),
    ]);
  }
}

extension RockExtension on Rock {
  void moveLeft() {
    final List<Position> occupiedOnRockLevel = _getOccupiedOnRockLevel();
    if (!positions.any((Position position) => position.X == 0) &&
        !occupiedOnRockLevel.any((Position occup) => positions.any(
            (Position position) =>
                position.Y == occup.Y && position.X - 1 == occup.X))) {
      for (Position position in positions) {
        position.X--;
      }
    }
  }

  void moveRight() {
    final List<Position> occupiedOnRockLevel = _getOccupiedOnRockLevel();
    if (!positions.any((Position position) => position.X == 6) &&
        !occupiedOnRockLevel.any((Position occup) => positions.any(
            (Position position) =>
                position.Y == occup.Y && position.X + 1 == occup.X))) {
      for (Position position in positions) {
        position.X++;
      }
    }
  }

  List<Position> _getOccupiedOnRockLevel() {
    final List<Position> occupiedOnRockLevel = <Position>[];
    for (int level in positions.map((Position position) => position.Y)) {
      if (occupied[level] != null) {
        occupiedOnRockLevel.addAll(occupied[level]!);
      }
    }
    return occupiedOnRockLevel;
  }

  bool moveDown() {
    if (positions.any((Position position) =>
        occupied[position.Y - 1]
            ?.any((Position occup) => occup.X == position.X) ==
        true)) {
      return false;
    } else {
      for (Position position in positions) {
        position.Y--;
      }
      return true;
    }
  }
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
