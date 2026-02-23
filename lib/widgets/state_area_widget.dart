// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

const rowDivider = SizedBox(width: 10);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class StateAreaWidget extends StatelessWidget {
  const StateAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StateTreasurey();
  }
}

class StateTreasurey extends StatelessWidget {
  const StateTreasurey({super.key});

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(children: <Widget>[
              Text("STATE TREASURY",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.remove, size: 40),
                        onPressed: () =>
                            boardState.incDecItem("sc_treasury", -10)),
                    IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () =>
                            boardState.incDecItem("sc_treasury", -1)),
                    rowDivider,
                    Text(boardState.getItem("sc_treasury").toString() + "£",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.orange)),
                    rowDivider,
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () =>
                            boardState.incDecItem("sc_treasury", 1)),
                    IconButton(
                        icon: Icon(Icons.add, size: 40),
                        onPressed: () =>
                            boardState.incDecItem("sc_treasury", 10)),
                  ])
            ])));
  }
}
