import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 19114;
  base.exampleAnswerSecond = 167409079868000;

  await base.calculate(19);
}

int _first(List<String> dataLines) {
  final int dataSeparation = dataLines.indexOf('');

  final workFlows = <String, WorkFlow>{};
  for (int i = 0; i < dataSeparation; i++) {
    final split = dataLines[i].split('{');
    final name = split[0];
    final flowData = split[1].split(',');
    final comparisons = <Comparison>[];
    for (String flow in flowData) {
      if (flow == flowData.last) {
        break;
      }
      final split = flow.split(':');
      comparisons.add(Comparison(
        split.first.substring(0, 1),
        int.parse(split.first.substring(2)),
        split.first.substring(1, 2),
        split.last,
      ));
    }
    workFlows[name] = WorkFlow(comparisons, flowData.last.replaceAll('}', ''));
  }

  final parts = <Part>[];
  for (int i = dataSeparation + 1; i < dataLines.length; i++) {
    final split = dataLines[i].substring(1, dataLines[i].length - 1).split(',');
    parts.add(Part(
      int.parse(split[0].substring(2)),
      int.parse(split[1].substring(2)),
      int.parse(split[2].substring(2)),
      int.parse(split[3].substring(2)),
    ));
  }

  final accepted = <Part>[];
  for (Part part in parts) {
    var current = 'in';
    while (current != 'A' && current != 'R') {
      final workFlow = workFlows[current]!;
      current = workFlow.fallBack;
      for (Comparison c in workFlow.flow) {
        var amount = 0;
        switch (c.prop) {
          case 'x':
            amount = part.x;
          case 'a':
            amount = part.a;
          case 's':
            amount = part.s;
          case 'm':
            amount = part.m;
        }
        if (c.comp == '<' && amount < c.amount ||
            c.comp == '>' && amount > c.amount) {
          current = c.to;
          break;
        }
      }
    }
    if (current == 'A') {
      accepted.add(part);
    }
  }

  return accepted
      .map((Part p) => p.x + p.a + p.s + p.m)
      .reduce((a, b) => a + b);
}

int _second(List<String> dataLines) {
  return 0;
}

class WorkFlow {
  const WorkFlow(
    this.flow,
    this.fallBack,
  );

  final List<Comparison> flow;
  final String fallBack;
}

class Comparison {
  const Comparison(
    this.prop,
    this.amount,
    this.comp,
    this.to,
  );

  final String prop;
  final int amount;
  final String comp;
  final String to;
}

class Part {
  const Part(this.x, this.m, this.a, this.s);

  final int x;
  final int m;
  final int a;
  final int s;
}
