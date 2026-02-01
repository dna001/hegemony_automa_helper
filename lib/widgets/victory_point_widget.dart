// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

class VictoryPoints extends StatelessWidget {
  const VictoryPoints(
      {super.key,
      required this.vpKey,
      required this.color,
      this.canModify = true});
  final String vpKey;
  final Color color;
  final bool canModify;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      canModify
          ? IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => boardState.incDecItem(vpKey, -1))
          : SizedBox(),
      Stack(alignment: Alignment.center, children: <Widget>[
        Icon(Icons.star_rounded, color: Colors.grey, size: 50),
        Text(boardState.getItem(vpKey).toString(),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12)),
      ]),
      canModify
          ? IconButton(
              icon: Icon(Icons.add),
              onPressed: () => boardState.incDecItem(vpKey, 1))
          : SizedBox(),
    ]);
  }
}
