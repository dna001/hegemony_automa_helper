// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 450;

enum PolicyState { A, B, C }

class PolicyCardData {
  final int id;
  final PolicyState state;

  PolicyCardData(this.id, this.state);
}

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    List<PolicyCardData> policyCardsList = [
      PolicyCardData(0, PolicyState.C),
      PolicyCardData(1, PolicyState.B),
      PolicyCardData(2, PolicyState.A),
      PolicyCardData(3, PolicyState.B),
      PolicyCardData(4, PolicyState.C),
      PolicyCardData(5, PolicyState.B),
      PolicyCardData(6, PolicyState.B)
    ];

    return Expanded(
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: Row(children: [
                FilledButton(
                  onPressed: () => appState.load(),
                  child: Text('Load'),
                ),
                rowDivider,
                FilledButton(
                  onPressed: () => appState.save(),
                  child: Text('Save'),
                )
              ])),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
            child: Text(
              'Policies',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        PolicyGrid(policyCardIds: policyCardsList),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
            child: Text(
              'State Area',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
            child: Text(
              'Capitalist Companies',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
            child: Text(
              'Middle Class Companies',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ]),
    );
  }
}

class PolicyGrid extends StatelessWidget {
  const PolicyGrid({super.key, this.policyCardIds = const []});

  final List<PolicyCardData> policyCardIds;

  List<PolicyCard> policyCardsList() {
    return policyCards
        .map(
          (cardInfo) => PolicyCard(
            info: cardInfo,
            state: policyCardIds[cardInfo.number - 1].state,
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
          crossAxisCount: 7,
          children: policyCardsList(),
        );
      }),
    );
  }
}

class PolicyCard extends StatefulWidget {
  const PolicyCard({super.key, required this.info, required this.state});

  final CardInfo info;
  final PolicyState state;

  @override
  State<PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<PolicyCard> {
  late PolicyState _policyState;

  @override
  void initState() {
    super.initState();
    _policyState = PolicyState.B;
  }

  @override
  Widget build(BuildContext context) {
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(4.0));
    final Color color = widget.info.color;
    final PolicyState state = widget.state;
    String stateString = 'A';
    if (state == PolicyState.B) {
      stateString = 'B';
    } else if (state == PolicyState.C) {
      stateString = 'C';
    }

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
            label: Text(stateString),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${widget.info.number}',
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
            ),
          ),
        ));
  }
}

class CardInfo {
  const CardInfo(this.number, this.name, this.shortName, this.color);
  final int number;
  final String name;
  final String shortName;
  final Color color;
}

const List<CardInfo> policyCards = <CardInfo>[
  CardInfo(1, "Fiscal Policy", "FP", Colors.blue),
  CardInfo(2, "Labor Market", "LM", Colors.deepPurple),
  CardInfo(3, "Taxation", "T", Colors.purple),
  CardInfo(4, "Healthcare & Benefits", "HB", Colors.red),
  CardInfo(5, "Education", "E", Colors.orange),
  CardInfo(6, "Foreign Trade", "FT", Colors.brown),
  CardInfo(7, "Immigration", "I", Color.fromARGB(255, 128, 128, 128)),
];
