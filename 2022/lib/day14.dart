import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _howManyUntilAbyss;
  base.calculateSecond = _howManyUntilAllRest;
  base.exampleAnswerFirst = 24;
  base.exampleAnswerSecond = 93;

  await base.calculate(14);
}

int _howManyUntilAbyss(List<String> dataLines) {
  final List<List<Point>> pointsOccupied = _getRocks(dataLines);
  final int lowestLevel = pointsOccupied.last.first.Y;

  int sandCount = 0;
  bool fallsIntoAbyss = false;
  while (!fallsIntoAbyss) {
    Point sand = Point(X: 500, Y: 0);
    while (sand.Y < lowestLevel) {
      final List<Point> levelBelow = pointsOccupied[sand.Y + 1];
      if (canFallDown(levelBelow, sand)) {
        sand = Point(X: sand.X, Y: sand.Y + 1);
      } else if (canFallLeft(levelBelow, sand)) {
        sand = Point(X: sand.X - 1, Y: sand.Y + 1);
      } else if (canFallRight(levelBelow, sand)) {
        sand = Point(X: sand.X + 1, Y: sand.Y + 1);
      } else if (comesToRest(levelBelow, sand)) {
        pointsOccupied[sand.Y].add(sand);
        sandCount++;
        break;
      }
    }
    if (sand.Y == lowestLevel) {
      fallsIntoAbyss = true;
    }
  }

  return sandCount;
}

int _howManyUntilAllRest(List<String> dataLines) {
  final List<List<Point>> pointsOccupied = _getRocks(dataLines);
  final int floor = pointsOccupied.last.first.Y + 2;
  pointsOccupied.add(<Point>[]);

  int sandCount = 0;
  while (!pointsOccupied[0].contains(Point(X: 500, Y: 0))) {
    Point sand = Point(X: 500, Y: 0);
    while (
        sand.Y < floor - 1 && !comesToRest(pointsOccupied[sand.Y + 1], sand)) {
      final List<Point> levelBelow = pointsOccupied[sand.Y + 1];
      if (canFallDown(levelBelow, sand)) {
        sand = Point(X: sand.X, Y: sand.Y + 1);
      } else if (canFallLeft(levelBelow, sand)) {
        sand = Point(X: sand.X - 1, Y: sand.Y + 1);
      } else {
        sand = Point(X: sand.X + 1, Y: sand.Y + 1);
      }
    }
    pointsOccupied[sand.Y].add(sand);
    sandCount++;
  }

  return sandCount;
}

bool canFallDown(List<Point> pointsOnLevelBelow, Point sand) =>
    !pointsOnLevelBelow.contains(Point(X: sand.X, Y: sand.Y + 1));
bool canFallLeft(List<Point> pointsOnLevelBelow, Point sand) =>
    !pointsOnLevelBelow.contains(Point(X: sand.X - 1, Y: sand.Y + 1));
bool canFallRight(List<Point> pointsOnLevelBelow, Point sand) =>
    !pointsOnLevelBelow.contains(Point(X: sand.X + 1, Y: sand.Y + 1));

bool comesToRest(List<Point> pointsOnLevelBelow, Point sand) =>
    !canFallDown(pointsOnLevelBelow, sand) &&
    !canFallLeft(pointsOnLevelBelow, sand) &&
    !canFallRight(pointsOnLevelBelow, sand);

List<List<Point>> _getRocks(List<String> dataLines) {
  final List<Point> rocks = <Point>[];
  for (String line in dataLines) {
    final List<Point> points = line.split(' -> ').map((String point) {
      final Iterable<int> coordinates =
          point.split(',').map((String value) => int.parse(value));
      return Point(X: coordinates.first, Y: coordinates.last);
    }).toList();
    for (int i = 0; i < points.length - 1; i++) {
      final Point first = points[i];
      final Point second = points[i + 1];
      final int xDif = second.X - first.X;
      final int yDif = second.Y - first.Y;
      if (xDif < 0) {
        for (int j = -1; j > xDif; j--) {
          rocks.add(Point(X: first.X + j, Y: first.Y));
        }
      } else if (xDif > 0) {
        for (int j = 1; j < xDif; j++) {
          rocks.add(Point(X: first.X + j, Y: first.Y));
        }
      } else if (yDif < 0) {
        for (int j = -1; j > yDif; j--) {
          rocks.add(Point(X: first.X, Y: first.Y + j));
        }
      } else if (yDif > 0) {
        for (int j = 1; j < yDif; j++) {
          rocks.add(Point(X: first.X, Y: first.Y + j));
        }
      }
    }
    rocks.addAll(points);
  }

  final int lowestLevel =
      (rocks.map((Point point) => point.Y).toList()..sort()).last;
  final List<List<Point>> rocksPerLevel = <List<Point>>[];
  for (int i = 0; i <= lowestLevel; i++) {
    rocksPerLevel.add(rocks.where((Point rock) => rock.Y == i).toList());
  }
  return rocksPerLevel;
}

class Point {
  const Point({
    required this.X,
    required this.Y,
  });

  final int X;
  final int Y;

  @override
  bool operator ==(Object other) =>
      other is Point &&
      other.runtimeType == runtimeType &&
      other.X == X &&
      other.Y == Y;

  @override
  int get hashCode => '$X,$Y'.hashCode;
}
