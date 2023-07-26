// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';

class RoundAndTaxWidget extends StatelessWidget {
  const RoundAndTaxWidget({super.key});

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
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.update, color: Colors.orange),
                  Text(boardState.getItem("round").toString()),
                  SizedBox(width: 10),
                  Icon(Icons.payments, color: Colors.orange),
                  Text(boardState.getTaxMultiplier().toString()),
                ]),
          ]),
        ));
  }
}
