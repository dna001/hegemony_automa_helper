// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';

const rowDivider = SizedBox(width: 10);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class VictoryPointsWidget extends StatelessWidget {
  const VictoryPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(children: <Widget>[
              Text("VICTORY POINTS",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ClassVictoryPoints(
                        vpKey: "wc_points",
                        icon: Icons.factory,
                        color: Colors.red),
                    ClassVictoryPoints(
                        vpKey: "cc_points",
                        icon: Icons.money,
                        color: Colors.blue),
                    ClassVictoryPoints(
                        vpKey: "mc_points",
                        icon: Icons.work,
                        color: Colors.yellow),
                    ClassVictoryPoints(
                        vpKey: "sc_points",
                        icon: Icons.account_balance,
                        color: Colors.grey),
                  ]),
            ])));
  }
}

class ClassVictoryPoints extends StatelessWidget {
  const ClassVictoryPoints(
      {super.key,
      required this.vpKey,
      required this.icon,
      required this.color});
  final String vpKey;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Column(children: <Widget>[
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () => boardState.incDecItem(vpKey, 1)),
      Row(children: <Widget>[
        Text(boardState.getItem(vpKey).toString()),
        Icon(icon, color: color),
      ]),
      IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => boardState.incDecItem(vpKey, -1)),
    ]);
  }
}
