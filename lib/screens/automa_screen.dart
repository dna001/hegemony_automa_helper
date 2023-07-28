// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/automa_state.dart';
import '../data/board_state.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 410;

class PriorityCardData {
  final int id;
  final int priority;

  PriorityCardData(this.id, this.priority);
}

class AutomaScreen extends StatelessWidget {
  const AutomaScreen({super.key, this.className = ClassName.Worker});
  final ClassName className;

  void onPolicyButtonPressed(BuildContext context, int id) {
    context.read<AutomaState>().incPolicyPriority(className, id);
  }

  void onActionButtonPressed(BuildContext context, int id) {
    context.read<AutomaState>().incActionPriority(className, id);
  }

  @override
  Widget build(BuildContext context) {
    final AutomaState automaState = context.watch<AutomaState>();
    final List<PriorityState> policyStateList =
        automaState.getPolicyList(className);
    // Add Policy Priority Cards to grid
    List<List<PriorityCardData>> policyPriorityCardsList =
        <List<PriorityCardData>>[];
    int oldPriority = policyStateList[0].priority;
    List<PriorityCardData> stateList = [];
    for (int i = 0; i < policyStateList.length; i++) {
      if (oldPriority != policyStateList[i].priority) {
        policyPriorityCardsList.add(stateList);
        stateList = [];
        oldPriority = policyStateList[i].priority;
      }
      if (policyStateList[i].priority >= 0) {
        stateList.add(PriorityCardData(
            policyStateList[i].id, policyStateList[i].priority));
      }
    }
    if (stateList.length > 0) {
      policyPriorityCardsList.add(stateList);
    }
    List<Widget> policySlivers = [];
    for (int i = 0; i < policyPriorityCardsList.length; i++) {
      policySlivers.add(PriorityGrid(
          priorityCardIds: policyPriorityCardsList[i],
          priorityCardsInfo: policyPriorityCards,
          className: className,
          count: 7));
    }
    // Add Action Priority Cards to grid
    List<PriorityState> actionStateList = automaState.getActionList(className);
    List<List<PriorityCardData>> actionPriorityCardsList =
        <List<PriorityCardData>>[];
    oldPriority = actionStateList[0].priority;
    stateList = [];
    for (int i = 0; i < actionStateList.length; i++) {
      if (oldPriority != actionStateList[i].priority) {
        actionPriorityCardsList.add(stateList);
        stateList = [];
        oldPriority = actionStateList[i].priority;
      }
      stateList.add(
          PriorityCardData(actionStateList[i].id, actionStateList[i].priority));
    }
    if (stateList.length > 0) {
      actionPriorityCardsList.add(stateList);
    }
    List<PriorityInfo> classInfo = actionPriorityCardsWC;
    if (className == ClassName.Capitalist) {
      classInfo = actionPriorityCardsCC;
    } else if (className == ClassName.Middle) {
      classInfo = actionPriorityCardsMC;
    }
    List<Widget> actionSlivers = [];
    for (int i = 0; i < actionPriorityCardsList.length; i++) {
      actionSlivers.add(PriorityGrid(
          priorityCardIds: actionPriorityCardsList[i],
          priorityCardsInfo: classInfo,
          className: className,
          count: 6));
    }

    return SizedBox(
      width: widthConstraint,
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: Row(children: [
                FilledButton(
                  onPressed: () => automaState.resetPriorities(className),
                  child: Text('Reset Priorities'),
                ),
                rowDivider,
                FilledButton(
                  onPressed: () => automaState.flattenPriorities(className),
                  child: Text('Flatten Priorities'),
                ),
              ])),
        ),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: Row(children: [
                FilledButton(
                  onPressed: () => automaState.undo(className),
                  child: Text('Undo'),
                ),
              ])),
        ),
        PolicyButtons(className: className),
        ActionButtons(className: className, classInfo: classInfo),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
            child: Text(
              'Policy Priority',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        ...policySlivers,
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
            child: Text(
              'Action Priority',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        ...actionSlivers,
      ]),
    );
  }
}

class PolicyButtons extends StatelessWidget {
  final ClassName className;

  const PolicyButtons({super.key, required this.className});

  @override
  Widget build(BuildContext context) {
    final AutomaState automaState = context.read<AutomaState>();
    List<Widget> widgets = [];
    for (int i = 0; i < 7; i++) {
      widgets.add(Padding(
          padding: const EdgeInsets.all(4),
          child: FilledButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(policyPriorityCards[i].color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            onPressed: () => automaState.incPolicyPriority(className, i),
            child: Text(policyPriorityCards[i].number.toString()),
          )));
    }

    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverLayoutBuilder(builder: (context, constraints) {
        return SliverGrid.count(
          childAspectRatio: 1.4,
          crossAxisCount: 5,
          children: widgets,
        );
      }),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final ClassName className;
  final List<PriorityInfo> classInfo;

  const ActionButtons(
      {super.key, required this.className, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    final AutomaState automaState = context.read<AutomaState>();
    List<Widget> widgets = [];
    for (int i = 0; i < 6; i++) {
      widgets.add(Padding(
          padding: const EdgeInsets.all(4),
          child: FilledButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(classInfo[i].color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
            onPressed: () => automaState.incActionPriority(className, i),
            child: Text(classInfo[i].shortName),
          )));
    }

    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverLayoutBuilder(builder: (context, constraints) {
        return SliverGrid.count(
          childAspectRatio: 1.4,
          crossAxisCount: 5,
          children: widgets,
        );
      }),
    );
  }
}

class PriorityGrid extends StatelessWidget {
  const PriorityGrid(
      {super.key,
      required this.priorityCardIds,
      required this.priorityCardsInfo,
      required this.className,
      this.count = 1});

  final List<PriorityCardData> priorityCardIds;
  final List<PriorityInfo> priorityCardsInfo;
  final ClassName className;
  final int count;

  List<PriorityCard> priorityCards() {
    return priorityCardIds
        .map(
          (priorityInfoId) => PriorityCard(
            info: priorityCardsInfo[priorityInfoId.id],
            priority: priorityInfoId.priority,
            className: className,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverLayoutBuilder(builder: (context, constraints) {
        return SliverGrid.count(
          childAspectRatio: 1.4,
          crossAxisCount: count,
          children: priorityCards(),
        );
      }),
    );
  }
}

class PriorityCard extends StatelessWidget {
  final PriorityInfo info;
  final int priority;
  final ClassName className;

  const PriorityCard(
      {super.key,
      required this.info,
      required this.priority,
      required this.className});

  @override
  Widget build(BuildContext context) {
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(4.0));
    final Color color = info.color;
    final AutomaState automaState = context.read<AutomaState>();

    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          borderRadius: borderRadius,
          elevation: 5.0,
          color: color,
          shadowColor: Theme.of(context).colorScheme.shadow,
          surfaceTintColor: null,
          type: MaterialType.card,
          child: Badge(
            label: Text(priority.toString()),
            child: FilledButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(color),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              onPressed: info.number > 0
                  ? () => automaState.removePolicy(className, info.id)
                  : () => automaState.decActionPriority(className, info.id),
              child: Text(
                  info.number > 0 ? info.number.toString() : info.shortName),
            ),
            /*Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  widget.info.number > 0
                      ? Text(
                          '${widget.info.number}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        )
                      : Text(
                          '',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white),
                        ),
                  SizedBox(width: 8),
                  Text(
                    '${widget.info.shortName}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),*/
          ),
        ));
  }
}

class PriorityInfo {
  const PriorityInfo(
      this.number, this.name, this.shortName, this.color, this.id);
  final int number;
  final String name;
  final String shortName;
  final Color color;
  final int id;
}

const List<PriorityInfo> policyPriorityCards = <PriorityInfo>[
  PriorityInfo(1, "Fiscal Policy", "FP", Colors.blue, 0),
  PriorityInfo(2, "Labor Market", "LM", Colors.deepPurple, 1),
  PriorityInfo(3, "Taxation", "T", Colors.purple, 2),
  PriorityInfo(4, "Healthcare & Benefits", "HB", Colors.red, 3),
  PriorityInfo(5, "Education", "E", Colors.orange, 4),
  PriorityInfo(6, "Foreign Trade", "FT", Colors.brown, 5),
  PriorityInfo(7, "Immigration", "I", Color.fromARGB(255, 128, 128, 128), 6),
];

const List<PriorityInfo> actionPriorityCardsWC = <PriorityInfo>[
  PriorityInfo(0, "Assign Workers", "AW", Colors.yellow, 0),
  PriorityInfo(0, "Buy Goods & Services", "BGS", Colors.green, 1),
  PriorityInfo(0, "Propose Bill", "PB", Colors.blueGrey, 2),
  PriorityInfo(0, "Special Action", "SA", Colors.pink, 3),
  PriorityInfo(0, "Strike", "STR", Colors.red, 4),
  PriorityInfo(0, "Demonstration", "DEM", Color.fromARGB(255, 179, 27, 0), 5),
];

const List<PriorityInfo> actionPriorityCardsCC = <PriorityInfo>[
  PriorityInfo(0, "Build Company", "BC", Colors.blue, 0),
  PriorityInfo(0, "Sell To The Foreign Market", "SFM", Colors.red, 1),
  PriorityInfo(0, "Propose Bill", "PB", Colors.blueGrey, 2),
  PriorityInfo(0, "Special Action", "SA", Colors.pink, 3),
  PriorityInfo(0, "Lobby", "LOB", Colors.purple, 4),
  PriorityInfo(0, "Sell Company", "SC", Colors.orange, 5),
];

const List<PriorityInfo> actionPriorityCardsMC = <PriorityInfo>[
  PriorityInfo(0, "Buy Goods & Services", "BGS", Colors.green, 0),
  PriorityInfo(0, "Build Company", "BC", Colors.blue, 1),
  PriorityInfo(0, "Assign Workers", "AW", Colors.yellow, 2),
  PriorityInfo(0, "Special Action", "SA", Colors.pink, 3),
  PriorityInfo(0, "Sell To The Foreign Market", "SFM", Colors.red, 4),
  PriorityInfo(0, "Propose Bill", "PB", Colors.blueGrey, 5),
];

enum ColorItem {
  red('red', Colors.red),
  orange('orange', Colors.orange),
  yellow('yellow', Colors.yellow),
  green('green', Colors.green),
  blue('blue', Colors.blue),
  indigo('indigo', Colors.indigo),
  violet('violet', Color(0xFF8F00FF)),
  purple('purple', Colors.purple),
  pink('pink', Colors.pink),
  silver('silver', Color(0xFF808080)),
  gold('gold', Color(0xFFFFD700)),
  beige('beige', Color(0xFFF5F5DC)),
  brown('brown', Colors.brown),
  grey('grey', Colors.grey),
  black('black', Colors.black),
  white('white', Colors.white);

  const ColorItem(this.label, this.color);
  final String label;
  final Color color;
}
