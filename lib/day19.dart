import 'dart:core';
import 'base/base.dart' as base;

Future<void> calculate() async {
  base.calculateFirst = _first;
  base.calculateSecond = _second;
  base.exampleAnswerFirst = 33;
  base.exampleAnswerSecond = 56 * 62;

  await base.calculate(19);
}

int _first(List<String> dataLines) {
  final List<Blueprint> bluePrints = _getBlueprints(dataLines);
  int total = 0;
  for (int i = 1; i <= bluePrints.length; i++) {
    total += i * _getMaxGeodes(bluePrints[i - 1], minutes: 24);
  }
  return total;
}

int _second(List<String> dataLines) {
  int numberOfBlueprints = 2;
  if (dataLines.length > 2) {
    numberOfBlueprints = 3;
  }
  final List<Blueprint> bluePrints = _getBlueprints(
    dataLines.sublist(0, numberOfBlueprints),
  );

  int multiply = 1;
  for (Blueprint blueprint in bluePrints) {
    multiply *= _getMaxGeodes(blueprint, minutes: 32, reduceCapping: 1);
  }

  return multiply;
}

int _getMaxOreCosts(Blueprint blueprint) {
  int maxOre = blueprint.clayRobotCosts.ore;
  if (blueprint.obsidianRobotCosts.ore > maxOre) {
    maxOre = blueprint.obsidianRobotCosts.ore;
  }
  if (blueprint.geodeRobotCosts.ore > maxOre) {
    maxOre = blueprint.geodeRobotCosts.ore;
  }
  return maxOre;
}

int _getMaxClayCosts(Blueprint blueprint) {
  int maxClay = blueprint.obsidianRobotCosts.clay;
  if (blueprint.geodeRobotCosts.clay > maxClay) {
    maxClay = blueprint.geodeRobotCosts.clay;
  }
  return maxClay;
}

int _getMaxGeodes(
  Blueprint blueprint, {
  required int minutes,
  int reduceCapping = 0,
}) {
  final int maxOre = _getMaxOreCosts(blueprint);
  final int maxClay = _getMaxClayCosts(blueprint);
  final int maxObsidian = blueprint.geodeRobotCosts.obsidian;

  final Set<Plan> plans = <Plan>{
    Plan(wallet: Resources()),
  };

  for (int i = 1; i <= minutes; i++) {
    int maxGeodes = 0;
    for (Plan plan in Set<Plan>.of(plans)) {
      if (i == minutes) {
        plan.wallet.addOutput(plan);
      } else {
        if (plan.wallet.geodes < maxGeodes - reduceCapping) {
          plans.remove(plan);
        } else {
          maxGeodes = plan.wallet.geodes;
          if (plan.wallet.subtract(blueprint.geodeRobotCosts)) {
            plan.wallet.addOutput(plan);
            plan.geodeRobots++;
          } else {
            final Plan plan2 = plan.copy();
            if (_shouldGetObsidianRobot(plan2.obsidianRobots, maxObsidian) &&
                plan2.wallet.subtract(blueprint.obsidianRobotCosts)) {
              plan2.wallet.addOutput(plan2);
              plan2.obsidianRobots++;
              plans.add(plan2);
              // This else statement doesn't work for part 2 example blueprint 1
            } else {
              final Plan plan3 = plan.copy();
              if (_shouldGetClayRobot(plan3.clayRobots, maxClay) &&
                  plan3.wallet.subtract(blueprint.clayRobotCosts)) {
                plan3.wallet.addOutput(plan3);
                plan3.clayRobots++;
                plans.add(plan3);
              }

              final Plan plan4 = plan.copy();
              if (_shouldGetOreRobot(plan4.oreRobots, maxOre) &&
                  plan4.wallet.subtract(blueprint.oreRobotCosts)) {
                plan4.wallet.addOutput(plan4);
                plan4.oreRobots++;
                plans.add(plan4);
              }
            }

            plan.wallet.addOutput(plan);
          }
        }
      }
    }
  }

  final List<int> geodes = plans
      .map((Plan plan) => plan.wallet.geodes)
      .toList(growable: false)
    ..sort();
  return geodes.last;
}

bool _shouldGetObsidianRobot(int obsidianRobots, int maxObsidian) {
  return obsidianRobots < 10 && obsidianRobots < maxObsidian;
}

bool _shouldGetClayRobot(int clayRobots, int maxClay) {
  return clayRobots < 10 && clayRobots < maxClay;
}

bool _shouldGetOreRobot(int oreRobots, int maxOre) {
  return oreRobots < 10 && oreRobots < maxOre;
}

List<Blueprint> _getBlueprints(List<String> dataLines) {
  if (base.dataCache == null) {
    final List<Blueprint> blueprints = <Blueprint>[];
    for (String line in dataLines) {
      final List<String> costsSplit = line.split('.');
      final List<String> oreRobotSplit = costsSplit.first.split(' ');
      final List<String> clayRobotSplit = costsSplit[1].split(' ');
      final List<String> obsidianRobotSplit = costsSplit[2].split(' ');
      final List<String> geodeRobotSplit = costsSplit[3].split(' ');
      blueprints.add(
        Blueprint(
          oreRobotCosts: Resources(ore: int.parse(oreRobotSplit[6])),
          clayRobotCosts: Resources(ore: int.parse(clayRobotSplit[5])),
          obsidianRobotCosts: Resources(
              ore: int.parse(obsidianRobotSplit[5]),
              clay: int.parse(obsidianRobotSplit[8])),
          geodeRobotCosts: Resources(
              ore: int.parse(geodeRobotSplit[5]),
              obsidian: int.parse(geodeRobotSplit[8])),
        ),
      );
    }
    base.dataCache = blueprints;
  }
  return base.dataCache as List<Blueprint>;
}

class Blueprint {
  const Blueprint({
    required this.oreRobotCosts,
    required this.clayRobotCosts,
    required this.obsidianRobotCosts,
    required this.geodeRobotCosts,
  });

  final Resources oreRobotCosts;
  final Resources clayRobotCosts;
  final Resources obsidianRobotCosts;
  final Resources geodeRobotCosts;
}

class Resources {
  Resources({
    this.ore = 0,
    this.clay = 0,
    this.obsidian = 0,
    this.geodes = 0,
  });

  int ore;
  int clay;
  int obsidian;
  int geodes;

  @override
  bool operator ==(Object other) =>
      other is Resources &&
      other.runtimeType == runtimeType &&
      other.ore == ore &&
      other.clay == clay &&
      other.obsidian == obsidian &&
      other.geodes == geodes;

  @override
  int get hashCode => '$ore,$clay,$obsidian,$geodes'.hashCode;

  Resources copy() {
    return Resources(
      ore: ore,
      clay: clay,
      obsidian: obsidian,
      geodes: geodes,
    );
  }
}

extension ResourcesExtension on Resources {
  bool subtract(Resources resources) {
    if (ore - resources.ore >= 0 &&
        clay - resources.clay >= 0 &&
        obsidian - resources.obsidian >= 0) {
      ore -= resources.ore;
      clay -= resources.clay;
      obsidian -= resources.obsidian;
      return true;
    }
    return false;
  }

  void addOutput(Plan plan) {
    ore += plan.oreRobots;
    clay += plan.clayRobots;
    obsidian += plan.obsidianRobots;
    geodes += plan.geodeRobots;
  }
}

class Plan {
  Plan({
    required this.wallet,
    this.oreRobots = 1,
    this.clayRobots = 0,
    this.obsidianRobots = 0,
    this.geodeRobots = 0,
  });

  Resources wallet;
  int oreRobots;
  int clayRobots;
  int obsidianRobots;
  int geodeRobots;

  @override
  bool operator ==(Object other) =>
      other is Plan &&
      other.runtimeType == runtimeType &&
      other.wallet == wallet &&
      other.oreRobots == oreRobots &&
      other.clayRobots == clayRobots &&
      other.obsidianRobots == obsidianRobots &&
      other.geodeRobots == geodeRobots;

  @override
  int get hashCode =>
      '$wallet,$oreRobots,$clayRobots,$obsidianRobots,$geodeRobots'.hashCode;

  Plan copy() {
    return Plan(
        wallet: wallet.copy(),
        oreRobots: oreRobots,
        clayRobots: clayRobots,
        obsidianRobots: obsidianRobots,
        geodeRobots: geodeRobots);
  }
}
