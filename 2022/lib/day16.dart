import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getMaxFlowOnMyOwn;
  base.calculateSecond = _getMaxFlowTogether;
  base.exampleAnswerFirst = 1651;
  base.exampleAnswerSecond = 1707;

  await base.calculate(16);
}

late List<ValveDistance> distances;

int _getMaxFlowOnMyOwn(List<String> dataLines) {
  List<Valve> valves = _getValves(dataLines);
  final List<Valve> valvesToOpen =
      valves.where((Valve valve) => valve.flow > 0).toList();
  return _getMaxFlow(valves, valvesToOpen, 30);
}

int _getMaxFlowTogether(List<String> dataLines) {
  final int minutes = 26;
  final List<Valve> valves = _getValves(dataLines);
  final List<Valve> valvesToOpen =
      valves.where((Valve valve) => valve.flow > 0).toList();

  if (dataLines.length < 11) {
    return _getMaxFlowSimultaneously(valves, valvesToOpen, minutes);
  }

  Set<List<Valve>> paths1 = _getPaths(valves, valvesToOpen, minutes);

  int maxFlow1 = 0;
  Set<Valve> opened1 = <Valve>{};
  for (List<Valve> path in paths1) {
    final Set<Valve> open = <Valve>{};
    Valve current = path.first;
    int totalFlow = 0;
    for (int i = 0; i <= minutes + 1; i++) {
      for (Valve valve in open) {
        totalFlow += valve.flow;
      }
      if (path[i] == current) {
        open.add(current);
      }
      current = path[i];
    }
    if (totalFlow > maxFlow1) {
      maxFlow1 = totalFlow;
      opened1 = open;
    }
  }

  final List<Valve> valvesLeftToOpen = valvesToOpen
      .where((Valve valve) => !opened1.contains(valve))
      .toList(growable: false);
  final int maxFlow2 = _getMaxFlow(valves, valvesLeftToOpen, 26);

  return maxFlow1 + maxFlow2;
}

int _getMaxFlow(List<Valve> valves, List<Valve> valvesToOpen, int minutes) {
  Set<List<Valve>> paths = _getPaths(valves, valvesToOpen, minutes);
  final List<int> flows = <int>[];
  for (List<Valve> path in paths) {
    final Set<Valve> open = <Valve>{};
    Valve current = path.first;
    int totalFlow = 0;
    for (int i = 0; i <= minutes + 1; i++) {
      for (Valve valve in open) {
        totalFlow += valve.flow;
      }
      if (path[i] == current) {
        open.add(current);
      }
      current = path[i];
    }
    flows.add(totalFlow);
  }
  return (flows..sort()).last;
}

Set<List<Valve>> _getPaths(
    List<Valve> valves, List<Valve> valvesToOpen, int minutes) {
  Valve start = valves.singleWhere((Valve valve) => valve.name == 'AA');
  final List<ValveDistance> distances = _getDistances(valvesToOpen, start);
  final Set<List<Valve>> paths = <List<Valve>>{
    <Valve>[start]
  };

  while (paths.any((List<Valve> path) => path.length <= minutes + 1)) {
    for (List<Valve> path in Set<List<Valve>>.from(paths)) {
      final Valve current = path.last;
      final Iterable<Valve> valvesToGo =
          valvesToOpen.where((Valve valve) => !path.contains(valve));
      if (valvesToGo.isNotEmpty && path.length <= minutes + 1) {
        paths.remove(path);
        for (Valve valve in valvesToGo) {
          final List<Valve> newPath = List<Valve>.from(path);
          int minutesToValve = distances
              .singleWhere((ValveDistance distance) =>
                  distance.from == current && distance.to == valve)
              .minutes;
          for (int i = 0;
              i < minutesToValve && path.length < minutes + 1;
              i++) {
            newPath.add(current);
          }
          newPath.add(valve);
          paths.add(newPath);
        }
      } else {
        while (path.length <= minutes + 1) {
          path.add(current);
        }
      }
    }
  }
  return paths;
}

List<ValveDistance> _getDistances(List<Valve> valvesToOpen, Valve start) {
  final List<ValveDistance> distances = <ValveDistance>[];
  for (Valve valve in <Valve>[...valvesToOpen, start]) {
    for (Valve other in valvesToOpen.where((Valve other) => other != valve)) {
      final int distance = _getShortestPath(valve, other);
      distances.add(ValveDistance(from: valve, to: other, minutes: distance));
    }
  }
  return distances;
}

int _getMaxFlowSimultaneously(
    List<Valve> valves, List<Valve> valvesToOpen, int minutes) {
  Valve start = valves.singleWhere((Valve valve) => valve.name == 'AA');
  final List<ValveDistance> distances = _getDistances(valvesToOpen, start);
  final Set<PathPair> paths = <PathPair>{
    PathPair(first: <Valve>[start], second: <Valve>[start]),
  };

  while (paths.any((PathPair pair) => pair.first.length <= minutes + 1)) {
    for (PathPair pair in Set<PathPair>.from(paths)) {
      final Valve current1 = pair.first.last;
      final Valve current2 = pair.second.last;
      final Iterable<Valve> valvesToGo = valvesToOpen.where((Valve valve) =>
          !pair.first.contains(valve) && !pair.second.contains(valve));
      if (valvesToGo.isNotEmpty &&
          (pair.first.length <= minutes + 1 ||
              pair.second.length <= minutes + 1)) {
        paths.remove(pair);
        for (Valve valve in valvesToGo) {
          final List<Valve> newPath1 = List<Valve>.from(pair.first);
          int minutesToValve = distances
              .singleWhere((ValveDistance distance) =>
                  distance.from == current1 && distance.to == valve)
              .minutes;
          for (int i = 0;
              i < minutesToValve && newPath1.length < minutes + 1;
              i++) {
            newPath1.add(current1);
          }
          newPath1.add(valve);
          if (valvesToGo.length > 1) {
            for (Valve secondValve
                in valvesToGo.where((Valve second) => second != valve)) {
              final List<Valve> newPath2 = List<Valve>.from(pair.second);
              int minutesToValve = distances
                  .singleWhere((ValveDistance distance) =>
                      distance.from == current2 && distance.to == secondValve)
                  .minutes;
              for (int i = 0;
                  i < minutesToValve && newPath2.length < minutes + 1;
                  i++) {
                newPath2.add(current2);
              }
              newPath2.add(secondValve);
              paths.add(PathPair(first: newPath1, second: newPath2));
            }
          } else {
            paths.add(PathPair(first: newPath1, second: pair.second));
          }
        }
      } else {
        while (pair.first.length <= minutes + 1) {
          pair.first.add(current1);
        }
        while (pair.second.length <= minutes + 1) {
          pair.second.add(current2);
        }
      }
    }
  }

  final List<int> flows = <int>[];
  for (PathPair pair in paths) {
    final Set<Valve> open = <Valve>{};
    Valve current1 = pair.first.first;
    Valve current2 = pair.second.first;
    int totalFlow = 0;
    for (int i = 0; i <= minutes + 1; i++) {
      for (Valve valve in open) {
        totalFlow += valve.flow;
      }
      if (pair.first[i] == current1) {
        open.add(current1);
      }
      if (pair.second[i] == current2) {
        open.add(current2);
      }
      current1 = pair.first[i];
      current2 = pair.second[i];
    }
    flows.add(totalFlow);
  }

  return (flows..sort()).last;
}

int _getShortestPath(Valve start, Valve end) {
  int minute = 1;
  Set<Valve> queue = <Valve>{...start.connected};
  Set<Valve> nextqueue = <Valve>{};
  while (!queue.contains(end)) {
    for (Valve valve in queue) {
      nextqueue.addAll(valve.connected);
    }
    queue = Set<Valve>.of(nextqueue);
    minute++;
  }
  return minute;
}

List<Valve> _getValves(List<String> dataLines) {
  if (base.dataCache == null) {
    final List<Valve> valves = <Valve>[];
    for (String line in dataLines) {
      final List<String> split = line.split(';').first.split(' ');
      valves.add(Valve(
        name: split[1],
        flow: int.parse(split[4].substring(5)),
      ));
    }
    for (int i = 0; i < valves.length; i++) {
      final List<String> names = dataLines[i]
          .split(';')
          .last
          .split(' ')
          .sublist(5)
          .map((String name) => name.replaceAll(',', ''))
          .toList();
      valves[i].connected =
          valves.where((Valve valve) => names.contains(valve.name)).toList();
    }
    base.dataCache = valves;
  }
  return base.dataCache as List<Valve>;
}

class Valve {
  Valve({
    required this.name,
    required this.flow,
  });

  final String name;
  final int flow;
  List<Valve> connected = <Valve>[];
}

class ValveDistance {
  const ValveDistance({
    required this.from,
    required this.to,
    required this.minutes,
  });

  final Valve from;
  final Valve to;
  final int minutes;
}

class PathPair {
  PathPair({
    required this.first,
    required this.second,
  });

  final List<Valve> first;
  final List<Valve> second;
}
