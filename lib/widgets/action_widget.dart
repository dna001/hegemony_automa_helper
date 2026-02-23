// Copyright 2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

class ActionWidget extends StatelessWidget {
  const ActionWidget({super.key});

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
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: boardState.activePlayer == ClassName.Worker
                    ? Colors.red
                    : boardState.activePlayer == ClassName.Capitalist
                        ? Colors.blue
                        : Colors.yellow,
              ),
              child: Icon(Icons.sentiment_satisfied, color: Colors.black),
            ),
            Text("PHASE: ${boardState.phase.name}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.orange)),
            IconButton(icon: Icon(Icons.list), onPressed: () => {}),
            IconButton(icon: Icon(Icons.undo), onPressed: () => {}),
            IconButton(icon: Icon(Icons.message), onPressed: () => {}),
            IconButton(icon: Icon(Icons.navigate_next), onPressed: () => {}),
          ]),
        ));
  }
}
