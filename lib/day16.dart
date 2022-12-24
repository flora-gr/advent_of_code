import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _getMaxFlowOnMyOwn;
  base.calculateSecond = _getMaxFlowTogether;
  base.exampleAnswerFirst = 1651;
  base.exampleAnswerSecond = 1707;

  await base.calculate(16);
}

int _getMaxFlowOnMyOwn(List<String> dataLines) {
  List<Valve> valves = _getValves(dataLines);

  final List<Valve> valvesToOpen =
      valves.where((Valve valve) => valve.flow > 0).toList();
  Valve start = valves.singleWhere((Valve valve) => valve.name == 'AA');

  final List<ValveDistance> distances = <ValveDistance>[];
  for (Valve valve in <Valve>[...valvesToOpen, start]) {
    for (Valve other in valvesToOpen.where((Valve other) => other != valve)) {
      final int distance = _getShortestPath(valve, other);
      distances.add(ValveDistance(from: valve, to: other, minutes: distance));
    }
  }

  final Set<List<Valve>> paths = <List<Valve>>{
    <Valve>[start]
  };

  while (paths.any((List<Valve> path) => path.length <= 31)) {
    for (List<Valve> path in Set<List<Valve>>.from(paths)) {
      final Valve current = path.last;
      final Iterable<Valve> valvesToGo =
          valvesToOpen.where((Valve valve) => !path.contains(valve));
      if (valvesToGo.isNotEmpty && path.length <= 31) {
        paths.remove(path);
        for (Valve valve in valvesToGo) {
          final List<Valve> newPath = List<Valve>.from(path);
          int minutesToValve = distances
              .singleWhere((ValveDistance distance) =>
                  distance.from == current && distance.to == valve)
              .minutes;
          for (int i = 0; i < minutesToValve && path.length < 31; i++) {
            newPath.add(current);
          }
          newPath.add(valve);
          paths.add(newPath);
        }
      } else {
        while (path.length <= 31) {
          path.add(current);
        }
      }
    }
  }

  final List<int> flows = <int>[];
  for (List<Valve> path in paths) {
    final Set<Valve> open = <Valve>{};
    Valve current = path.first;
    int totalFlow = 0;
    for (int i = 0; i <= 31; i++) {
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

int _getMaxFlowTogether(List<String> dataLines) {
  return 0;
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
  return valves;
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
