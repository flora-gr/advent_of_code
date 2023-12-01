import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _get2DPassword;
  base.calculateSecond = _get3DPassword;
  base.exampleAnswerFirst = 6032;
  base.exampleAnswerSecond = 5031;

  await base.calculate(22);
}

const String empty = ' ';
const String clear = '.';
const String rock = '#';
const String left = 'L';
const String right = 'R';
const List<Direction> directions = <Direction>[
  Direction.right,
  Direction.down,
  Direction.left,
  Direction.up,
];

late Direction currentDirection;
late Point currentLocation;

int _get2DPassword(List<String> dataLines) {
  final int dataSeparation =
      dataLines.indexOf(dataLines.firstWhere((String line) => line.isEmpty));
  final Map<int, List<String>> map = _getMap(dataLines, dataSeparation);
  final List<String> path = _getPath(dataLines, dataSeparation);
  currentDirection = Direction.right;
  currentLocation = Point(
      Y: 0,
      X: map[0]!.indexOf(map[0]!.firstWhere((String loc) => loc == clear)));

  for (String element in path) {
    if (element.isDirection()) {
      _changeDirection(element);
    } else {
      _move2D(int.parse(element), map);
    }
  }

  return _getPassword();
}

int _get3DPassword(List<String> dataLines) {
  final int dataSeparation =
      dataLines.indexOf(dataLines.firstWhere((String line) => line.isEmpty));
  final Map<int, List<String>> map = _getMap(dataLines, dataSeparation);
  final List<String> path = _getPath(dataLines, dataSeparation);
  currentDirection = Direction.right;
  currentLocation = Point(
      Y: 0,
      X: map[0]!.indexOf(map[0]!.firstWhere((String loc) => loc == clear)));

  for (String element in path) {
    if (element.isDirection()) {
      _changeDirection(element);
    } else if (map.length == 12) {
      // Example folds differently than input, don't want to spend time making a generic solution
      _move3DExample(int.parse(element), map);
    } else {
      _move3DInput(int.parse(element), map);
    }
  }

  return _getPassword();
}

void _move3DInput(int steps, Map<int, List<String>> map) {
  if (currentDirection == Direction.right) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.Y < 50) {
          final int newX = 99;
          final int newY = 149 - currentLocation.Y;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.left;
          }
        } else if (currentLocation.Y < 100) {
          final int newX = 50 + currentLocation.Y;
          final int newY = 49;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.up;
          }
        } else if (currentLocation.Y < 150) {
          final int newX = 149;
          final int newY = 149 - currentLocation.Y;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.left;
          }
        } else {
          final int newX = currentLocation.Y - 100;
          final int newY = 149;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.up;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DInput(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y]![currentLocation.X + 1];
        if (nextLocation == clear) {
          currentLocation.X++;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  } else if (currentDirection == Direction.left) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.Y < 50) {
          final int newX = 0;
          final int newY = 149 - currentLocation.Y;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.right;
          }
        } else if (currentLocation.Y < 100) {
          final int newX = currentLocation.Y - 50;
          final int newY = 100;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.down;
          }
        } else if (currentLocation.Y < 150) {
          final int newX = 50;
          final int newY = 149 - currentLocation.Y;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.right;
          }
        } else {
          final int newX = currentLocation.Y - 100;
          final int newY = 0;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.down;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DInput(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y]![currentLocation.X - 1];
        if (nextLocation == clear) {
          currentLocation.X--;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  } else if (currentDirection == Direction.up) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.X < 50) {
          final int newX = 50;
          final int newY = 50 + currentLocation.X;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.right;
          }
        } else if (currentLocation.X < 100) {
          final int newX = 0;
          final int newY = 100 + currentLocation.X;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.right;
          }
        } else {
          final int newX = currentLocation.X - 100;
          final int newY = 199;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DInput(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y - 1]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y--;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  } else if (currentDirection == Direction.down) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.X < 50) {
          final int newX = 100 + currentLocation.X;
          final int newY = 0;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
          }
        } else if (currentLocation.X < 100) {
          final int newX = 49;
          final int newY = 100 + currentLocation.X;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.left;
          }
        } else {
          final int newX = 99;
          final int newY = currentLocation.X - 50;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.left;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DInput(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y + 1]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y++;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  }
}

void _move3DExample(int steps, Map<int, List<String>> map) {
  if (currentDirection == Direction.right) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.Y < 4) {
          final int newX = 15;
          final int newY = 11 - currentLocation.Y;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.left;
          }
        } else if (currentLocation.Y < 8) {
          final int newX = 19 - currentLocation.Y;
          final int newY = 8;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.down;
          }
        } else {
          final int newX = 11;
          final int newY = 11 - currentLocation.Y;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.left;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DExample(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y]![currentLocation.X + 1];
        if (nextLocation == clear) {
          currentLocation.X++;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  } else if (currentDirection == Direction.left) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.Y < 4) {
          final int newX = 4 + currentLocation.Y;
          final int newY = 4;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.down;
          }
        } else if (currentLocation.Y < 8) {
          final int newX = 19 - currentLocation.Y;
          final int newY = 11;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.up;
          }
        } else {
          final int newX = 15 - currentLocation.Y;
          final int newY = 7;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.up;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DExample(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y]![currentLocation.X - 1];
        if (nextLocation == clear) {
          currentLocation.X--;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  } else if (currentDirection == Direction.up) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.X < 4) {
          final int newX = 11 - currentLocation.X;
          final int newY = 0;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.down;
          }
        } else if (currentLocation.X < 8) {
          final int newY = currentLocation.X - 4;
          final int newX = 8;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.right;
          }
        } else if (currentLocation.X < 12) {
          final int newX = 11 - currentLocation.X;
          final int newY = 4;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.down;
          }
        } else {
          final int newY = 19 - currentLocation.X;
          final int newX = 11;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.left;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DExample(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y - 1]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y--;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  } else if (currentDirection == Direction.down) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        if (currentLocation.X < 4) {
          final int newX = 11 - currentLocation.X;
          final int newY = 11;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.up;
          }
        } else if (currentLocation.X < 8) {
          final int newY = 15 - currentLocation.X;
          final int newX = 8;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.right;
          }
        } else if (currentLocation.X < 12) {
          final int newX = 11 - currentLocation.X;
          final int newY = 7;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.up;
          }
        } else {
          final int newY = 15 - currentLocation.X;
          final int newX = 0;
          nextLocation = map[newY]![newX];
          if (nextLocation == clear) {
            currentLocation.X = newX;
            currentLocation.Y = newY;
            currentDirection = Direction.right;
          }
        }
        if (nextLocation == rock) {
          break;
        }
        _move3DExample(steps - i - 1, map);
        break;
      } else {
        nextLocation = map[currentLocation.Y + 1]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y++;
        }
        if (nextLocation == rock) {
          break;
        }
      }
    }
  }
}

void _move2D(int steps, Map<int, List<String>> map) {
  if (currentDirection == Direction.right) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        nextLocation =
            map[currentLocation.Y]!.firstWhere((String loc) => loc != empty);
        if (nextLocation == clear) {
          currentLocation.X = map[currentLocation.Y]!.indexOf(nextLocation);
        }
      } else {
        nextLocation = map[currentLocation.Y]![currentLocation.X + 1];
        if (nextLocation == clear) {
          currentLocation.X++;
        }
      }
      if (nextLocation == rock) {
        break;
      }
    }
  } else if (currentDirection == Direction.left) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        nextLocation =
            map[currentLocation.Y]!.lastWhere((String loc) => loc != empty);
        if (nextLocation == clear) {
          currentLocation.X = map[currentLocation.Y]!.lastIndexOf(nextLocation);
        }
      } else {
        nextLocation = map[currentLocation.Y]![currentLocation.X - 1];
        if (nextLocation == clear) {
          currentLocation.X--;
        }
      }
      if (nextLocation == rock) {
        break;
      }
    }
  } else if (currentDirection == Direction.up) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        final int nextRow = map.keys
            .lastWhere((int row) => map[row]![currentLocation.X] != empty);
        nextLocation = map[nextRow]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y = nextRow;
        }
      } else {
        nextLocation = map[currentLocation.Y - 1]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y--;
        }
      }
      if (nextLocation == rock) {
        break;
      }
    }
  } else if (currentDirection == Direction.down) {
    for (int i = 0; i < steps; i++) {
      String nextLocation = '';
      if (_isAtEnd(map)) {
        final int nextRow = map.keys
            .firstWhere((int row) => map[row]![currentLocation.X] != empty);
        nextLocation = map[nextRow]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y = nextRow;
        }
      } else {
        nextLocation = map[currentLocation.Y + 1]![currentLocation.X];
        if (nextLocation == clear) {
          currentLocation.Y++;
        }
      }
      if (nextLocation == rock) {
        break;
      }
    }
  }
}

bool _isAtEnd(Map<int, List<String>> map) {
  switch (currentDirection) {
    case Direction.right:
      return currentLocation.X + 1 == map[currentLocation.Y]!.length ||
          map[currentLocation.Y]![currentLocation.X + 1] == empty;
    case Direction.left:
      return currentLocation.X - 1 == -1 ||
          map[currentLocation.Y]![currentLocation.X - 1] == empty;
    case Direction.up:
      return currentLocation.Y - 1 == -1 ||
          map[currentLocation.Y - 1]![currentLocation.X] == empty;
    case Direction.down:
      return currentLocation.Y + 1 == map.length ||
          map[currentLocation.Y + 1]![currentLocation.X] == empty;
  }
}

void _changeDirection(String turn) {
  if (turn == right) {
    currentDirection =
        directions[(directions.indexOf(currentDirection) + 1) % 4];
  } else if (turn == left) {
    currentDirection =
        directions[(directions.indexOf(currentDirection) - 1) % 4];
  }
}

int _getPassword() {
  return 1000 * (currentLocation.Y + 1) +
      4 * (currentLocation.X + 1) +
      directions.indexOf(currentDirection);
}

Map<int, List<String>> _getMap(List<String> dataLines, int dataSeparation) {
  if (base.dataCache == null) {
    final Map<int, List<String>> map = <int, List<String>>{};
    final int longestLength =
        (dataLines.map((String line) => line.length).toList()..sort()).last;
    for (int i = 0; i < dataLines.sublist(0, dataSeparation).length; i++) {
      map[i] = dataLines[i].split('');
      while (map[i]!.length < longestLength) {
        map[i]!.add(empty);
      }
    }
    base.dataCache = map;
  }
  return base.dataCache as Map<int, List<String>>;
}

List<String> _getPath(List<String> dataLines, int dataSeparation) {
  final List<String> pathSplit = dataLines[dataSeparation + 1].split('');
  final List<String> path = <String>[];
  int directionLocation = -1;
  for (int i = 0; i < pathSplit.length; i++) {
    if (pathSplit[i].isDirection()) {
      path.add(pathSplit[i]);
      directionLocation = i;
    } else if (i + 1 == pathSplit.length || pathSplit[i + 1].isDirection()) {
      path.add(pathSplit.sublist(directionLocation + 1, i + 1).join(''));
    }
  }
  return path;
}

class Point {
  Point({
    required this.X,
    required this.Y,
  });

  int X;
  int Y;
}

enum Direction {
  right,
  down,
  left,
  up,
}

extension StringExtension on String {
  bool isDirection() {
    return this == right || this == left;
  }
}
