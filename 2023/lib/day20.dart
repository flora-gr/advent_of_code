import 'dart:core';
import 'dart:math';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 11687500;
  base.exampleAnswerSecond = 0;

  await base.calculate(20);
}

int _first(List<String> dataLines) {
  final modules = _getModules(dataLines);

  var low = 0;
  var high = 0;
  for (int i = 1; i <= 1000; i++) {
    low++;
    final currentPulses = modules['broadcaster']!
        .output
        .map((String out) => Pulse('low', 'broadcaster', out))
        .toList();
    while (currentPulses.isNotEmpty) {
      for (Pulse pulse in List.of(currentPulses)) {
        if (pulse.type == 'low') {
          low++;
        } else {
          high++;
        }
        currentPulses.remove(pulse);
        if (modules.containsKey(pulse.to)) {
          final toModule = modules[pulse.to]!;
          if (toModule.type == '%') {
            if (pulse.type == 'low') {
              if (toModule.isOn) {
                currentPulses.addAll(toModule.output
                    .map((String out) => Pulse('low', pulse.to, out)));
              } else {
                currentPulses.addAll(toModule.output
                    .map((String out) => Pulse('high', pulse.to, out)));
              }
              modules[pulse.to] =
                  Module(toModule.type, toModule.output, isOn: !toModule.isOn);
            }
          } else {
            final memory = Set.of(toModule.anyHigh);
            if (pulse.type == 'low') {
              memory.remove(pulse.from);
            } else {
              memory.add(pulse.from);
            }
            if (memory.length == toModule.connected) {
              currentPulses.addAll(toModule.output
                  .map((String out) => Pulse('low', pulse.to, out)));
            } else {
              currentPulses.addAll(toModule.output
                  .map((String out) => Pulse('high', pulse.to, out)));
            }
            modules[pulse.to] = Module(toModule.type, toModule.output,
                anyHigh: memory, connected: toModule.connected);
          }
        }
      }
    }
  }

  return low * high;
}

int _second(List<String> dataLines) {
  if (dataLines.length < 10) {
    return 0;
  }

  final modules = _getModules(dataLines);

  // jq needs all high pulses to send a low pulse to rx
  final jq_connected = modules.keys
      .where((String key) => modules[key]!.output.contains('jq'))
      .toList();
  final cycles = <int>[];

  for (int i = 1; jq_connected.isNotEmpty; i++) {
    final currentPulses = modules['broadcaster']!
        .output
        .map((String out) => Pulse('low', 'broadcaster', out))
        .toList();
    while (currentPulses.isNotEmpty) {
      if (currentPulses
          .any((Pulse pulse) => pulse.to == 'rx' && pulse.type == 'low')) {
        return i;
      }
      for (Pulse pulse in List.of(currentPulses)) {
        currentPulses.remove(pulse);
        if (modules.containsKey(pulse.to)) {
          final toModule = modules[pulse.to]!;
          if (toModule.type == '%') {
            if (pulse.type == 'low') {
              if (toModule.isOn) {
                currentPulses.addAll(toModule.output
                    .map((String out) => Pulse('low', pulse.to, out)));
              } else {
                currentPulses.addAll(toModule.output
                    .map((String out) => Pulse('high', pulse.to, out)));
              }
              modules[pulse.to] =
                  Module(toModule.type, toModule.output, isOn: !toModule.isOn);
            }
          } else {
            final memory = Set.of(toModule.anyHigh);
            if (pulse.type == 'low') {
              memory.remove(pulse.from);
            } else {
              memory.add(pulse.from);
            }
            if (memory.length == toModule.connected) {
              currentPulses.addAll(toModule.output
                  .map((String out) => Pulse('low', pulse.to, out)));
            } else {
              currentPulses.addAll(toModule.output
                  .map((String out) => Pulse('high', pulse.to, out)));
              if (jq_connected.contains(pulse.to)) {
                jq_connected.remove(pulse.to);
                cycles.add(i);
              }
            }
            modules[pulse.to] = Module(toModule.type, toModule.output,
                anyHigh: memory, connected: toModule.connected);
          }
        }
      }
    }
  }

  return _leastCommonMultiple(cycles);
}

Map<String, Module> _getModules(List<String> dataLines) {
  if (base.dataCache == null) {
    final modules = <String, Module>{};
    for (String line in dataLines) {
      final split = line.split(' -> ');
      final output = split[1].split(', ');
      if (line.startsWith('broadcaster')) {
        modules['broadcaster'] = Module('', output);
      } else {
        modules[split[0].substring(1)] = Module(
          split[0].substring(0, 1),
          output,
        );
      }
    }

    for (String key
        in modules.keys.where((String key) => (modules[key]!.type == '&'))) {
      var connected = 0;
      for (Module module in modules.values) {
        if (module.output.contains(key)) {
          connected++;
        }
      }
      final oldModule = modules[key]!;
      modules[key] =
          Module(oldModule.type, oldModule.output, connected: connected);
    }

    base.dataCache = modules;
  }
  return Map.from(base.dataCache as Map<String, Module>);
}

int _leastCommonMultiple(List<int> cycles) {
  final lowest = cycles.reduce(min);
  for (int i = 2; i < lowest; i++) {
    if (cycles.every((int step) => step % i == 0)) {
      return cycles.reduce((a, b) => (a * b) ~/ i);
    }
  }
  return cycles.reduce((a, b) => a * b);
}

class Module {
  const Module(
    this.type,
    this.output, {
    this.isOn = false,
    this.anyHigh = const <String>{},
    this.connected = 0,
  });

  final String type;
  final List<String> output;
  final bool isOn;
  final Set<String> anyHigh;
  final int connected;
}

class Pulse {
  const Pulse(
    this.type,
    this.from,
    this.to,
  );

  final String type;
  final String from;
  final String to;
}
