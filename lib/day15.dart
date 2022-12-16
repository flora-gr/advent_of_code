import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getEmptiesOnRow;
  base.calculateSecond = _getDistressSignal;
  base.exampleAnswerFirst = 26;
  base.exampleAnswerSecond = 56000011;

  await base.calculate(15);
}

int _getEmptiesOnRow(List<String> dataLines) {
  final int levelToCheck = int.parse(dataLines[0]);
  final List<Position> sensors = _getSensors(dataLines);

  Set<int> emptiesOnLevel = <int>{};
  void addEmptiesToLevel(int xManhattanDist, int sensorX) {
    List<int> newEmpties = List<int>.generate(
        xManhattanDist * 2 + 1, (int i) => i + sensorX - xManhattanDist);
    emptiesOnLevel.addAll(newEmpties);
  }

  for (Position sensor in sensors) {
    final int manhattanDist = sensor.manhattanDist;
    if (sensor.Y < levelToCheck && sensor.Y + manhattanDist >= levelToCheck) {
      int xManhattanDist = (sensor.Y + manhattanDist - levelToCheck).abs();
      addEmptiesToLevel(xManhattanDist, sensor.X);
    } else if (sensor.Y > levelToCheck &&
        sensor.Y - manhattanDist <= levelToCheck) {
      int xManhattanDist = (sensor.Y - manhattanDist - levelToCheck).abs();
      addEmptiesToLevel(xManhattanDist, sensor.X);
    }
  }

  final int beaconsOnLevel = sensors
      .map((Position sensor) => sensor.beacon!)
      .toSet()
      .where((Position beacon) => beacon.Y == levelToCheck)
      .length;

  return emptiesOnLevel.length - beaconsOnLevel;
}

int _getDistressSignal(List<String> dataLines) {
  final int maxCoordinate = int.parse(dataLines[1]);
  final List<Position> sensors = _getSensors(dataLines);

  Set<Position> sensorsWithMinimalSpaceBetween = <Position>{};
  for (Position sensor in sensors) {
    final Iterable<Position> closeBy = sensors.where((Position other) =>
        sensor.manhattanDist + other.manhattanDist ==
        sensor.manhattanDistExt(other) - 2);
    sensorsWithMinimalSpaceBetween.addAll(closeBy);
  }

  final Set<Position> potentialPositions = <Position>{};
  for (Position sensor in sensorsWithMinimalSpaceBetween) {
    final int distanceOneAround = sensor.manhattanDist + 1;
    for (int i = -distanceOneAround; i <= distanceOneAround; i++) {
      final int y = sensor.Y + i;
      if (y >= 0 && y <= maxCoordinate) {
        final int xManHattanDist = distanceOneAround - i.abs();
        final int leftX = sensor.X - xManHattanDist;
        final int rightX = sensor.X + xManHattanDist;
        if (rightX >= 0 && rightX <= maxCoordinate) {
          potentialPositions.add(Position(X: rightX, Y: y));
        }
        if (leftX >= 0 && leftX <= maxCoordinate) {
          potentialPositions.add(Position(X: leftX, Y: y));
        }
      }
    }
  }

  Position? distressBeacon;
  for (Position position in potentialPositions) {
    if (sensors.every((Position sensor) =>
        sensor.manhattanDist < sensor.manhattanDistExt(position))) {
      distressBeacon = position;
      break;
    }
  }

  return distressBeacon!.X * 4000000 + distressBeacon.Y;
}

List<Position> _getSensors(List<String> dataLines) {
  final List<Position> sensors = <Position>[];

  for (String line in dataLines.sublist(2)) {
    final List<String> split = line.split(':');

    final Iterable<List<String>> beaconCoord =
        split.last.split(',').map((String coord) => coord.split('='));
    final Position beacon = Position(
      X: int.parse(beaconCoord.first.last),
      Y: int.parse(beaconCoord.last.last),
    );

    final Iterable<List<String>> sensorCoord =
        split.first.split(',').map((String coord) => coord.split('='));
    final Position sensor = Position(
      X: int.parse(sensorCoord.first.last),
      Y: int.parse(sensorCoord.last.last),
      beacon: beacon,
    );
    sensors.add(sensor);
  }
  return sensors;
}

class Position {
  Position({
    required this.X,
    required this.Y,
    this.beacon,
  });

  final int X;
  final int Y;
  final Position? beacon;

  int get manhattanDist => (X - beacon!.X).abs() + (Y - beacon!.Y).abs();

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
  int manhattanDistExt(Position ext) => (X - ext.X).abs() + (Y - ext.Y).abs();
}

extension IntExtension on int {
  int abs() => this < 0 ? -1 * this : this;
}
