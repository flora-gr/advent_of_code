import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getExternalSurfaces;
  base.calculateSecond = _getWaterAccessibleSurfaces;
  base.exampleAnswerFirst = 64;
  base.exampleAnswerSecond = 58;

  await base.calculate(18);
}

int _getExternalSurfaces(List<String> dataLines) {
  final int totalSurfaces = dataLines.length * 6;
  final Set<String> uniqueSurfaces = <String>{};
  for (String line in dataLines) {
    final List<int> cube =
        line.split(',').map((String coord) => int.parse(coord)).toList();
    uniqueSurfaces.add('(X${cube[0]},Y${cube[1]}) at Z${cube[2]}');
    uniqueSurfaces.add('(X${cube[0]},Y${cube[1]}) at Z${cube[2] + 1}');
    uniqueSurfaces.add('(Y${cube[1]},Z${cube[2]}) at X${cube[0]}');
    uniqueSurfaces.add('(Y${cube[1]},Z${cube[2]}) at X${cube[0] + 1}');
    uniqueSurfaces.add('(Z${cube[2]},X${cube[0]}) at Y${cube[1]}');
    uniqueSurfaces.add('(Z${cube[2]},X${cube[0]}) at Y${cube[1] + 1}');
  }
  final int overLappingSurfaces = totalSurfaces - uniqueSurfaces.length;
  return totalSurfaces - (overLappingSurfaces * 2);
}

int _getWaterAccessibleSurfaces(List<String> dataLines) {
  Set<Cube> cubes = <Cube>{};
  for (String line in dataLines) {
    List<int> split = line
        .split(',')
        .map((String coord) => int.parse(coord))
        .toList(growable: false);
    cubes.add(Cube(X: split[0], Y: split[1], Z: split[2]));
  }

  List<int> xValues = cubes.map((Cube cube) => cube.X).toList()..sort();
  final int minX = xValues.first - 1;
  final int maxX = xValues.last + 1;
  List<int> yValues = cubes.map((Cube cube) => cube.Y).toList()..sort();
  final int minY = yValues.first - 1;
  final int maxY = yValues.last + 1;
  List<int> zValues = cubes.map((Cube cube) => cube.Z).toList()..sort();
  final int minZ = zValues.first - 1;
  final int maxZ = zValues.last + 1;

  final Set<Cube> water = <Cube>{};
  Set<Cube> currentQueue = <Cube>{Cube(X: minX, Y: minY, Z: minZ)};
  Set<Cube> nextQueue = <Cube>{};
  while (currentQueue.isNotEmpty) {
    for (Cube drop in currentQueue) {
      Iterable<Cube> touchingWater = drop.getTouchingCubes().where(
          (Cube next) =>
              next.X >= minX &&
              next.X <= maxX &&
              next.Y >= minY &&
              next.Y <= maxY &&
              next.Z >= minZ &&
              next.Z <= maxZ &&
              !cubes.contains(next) &&
              !water.contains(next));
      nextQueue.addAll(touchingWater);
    }
    water.addAll(currentQueue);
    currentQueue = Set.of(nextQueue);
    nextQueue.clear();
  }

  int touchingSurfaces = 0;
  for (Cube cube in cubes) {
    for (Cube water in water) {
      if (cube.touches(water)) {
        touchingSurfaces++;
      }
    }
  }

  return touchingSurfaces;
}

class Cube {
  const Cube({
    required this.X,
    required this.Y,
    required this.Z,
  });

  final int X;
  final int Y;
  final int Z;

  @override
  bool operator ==(Object other) =>
      other is Cube &&
      other.runtimeType == runtimeType &&
      other.X == X &&
      other.Y == Y &&
      other.Z == Z;

  @override
  int get hashCode => '$X,$Y,$Z'.hashCode;
}

extension CubeExtension on Cube {
  Iterable<Cube> getTouchingCubes() {
    return <Cube>[
      Cube(X: X + 1, Y: Y, Z: Z),
      Cube(X: X + -1, Y: Y, Z: Z),
      Cube(X: X, Y: Y + 1, Z: Z),
      Cube(X: X, Y: Y - 1, Z: Z),
      Cube(X: X, Y: Y, Z: Z + 1),
      Cube(X: X, Y: Y, Z: Z - 1),
    ];
  }

  bool touches(Cube other) {
    return (X == other.X &&
            Y == other.Y &&
            (Z == other.Z - 1 || Z == other.Z + 1)) ||
        (Y == other.Y &&
            Z == other.Z &&
            (X == other.X - 1 || X == other.X + 1)) ||
        (Z == other.Z &&
            X == other.X &&
            (Y == other.Y - 1 || Y == other.Y + 1));
  }
}
