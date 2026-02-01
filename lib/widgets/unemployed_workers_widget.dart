// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

const rowDivider = SizedBox(width: 10);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class UnemployedWorkersWidget extends StatelessWidget {
  const UnemployedWorkersWidget({super.key});

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
              Text("UNEMPLOYED WORKERS",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              UnemployedWorkerRow(bsKey: "wc_workers", icon: Icons.person),
              colDivider,
              UnemployedWorkerRow(bsKey: "mc_workers", icon: Icons.engineering),
            ])));
  }
}

class UnemployedWorkerRow extends StatelessWidget {
  const UnemployedWorkerRow(
      {super.key, required this.bsKey, required this.icon});
  final String bsKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    //BoardState boardState = context.watch<BoardState>();

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      WorkerAdjustWidget(
          workerKey: bsKey + "_skilled_health",
          icon: icon,
          color: Colors.white),
      WorkerAdjustWidget(
          workerKey: bsKey + "_skilled_education",
          icon: icon,
          color: Colors.orange),
      WorkerAdjustWidget(
          workerKey: bsKey + "_skilled_luxury", icon: icon, color: Colors.blue),
      WorkerAdjustWidget(
          workerKey: bsKey + "_skilled_agriculture",
          icon: icon,
          color: Colors.green),
      WorkerAdjustWidget(
          workerKey: bsKey + "_skilled_media",
          icon: icon,
          color: Colors.purple),
      WorkerAdjustWidget(
          workerKey: bsKey + "_unskilled", icon: icon, color: Colors.grey),
    ]);
  }
}

class WorkerAdjustWidget extends StatelessWidget {
  const WorkerAdjustWidget(
      {super.key,
      required this.workerKey,
      required this.icon,
      required this.color});
  final String workerKey;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Column(children: <Widget>[
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () => boardState.incDecItem(workerKey, 1)),
      Row(children: <Widget>[
        Text(boardState.getItem(workerKey).toString()),
        Icon(icon, color: color),
      ]),
      IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => boardState.incDecItem(workerKey, -1)),
    ]);
  }
}
