// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';

class AdjustableValueWidget extends StatelessWidget {
  const AdjustableValueWidget(
      {super.key,
      required this.valueKey,
      this.extraText = "",
      this.showBorder = false});
  final String valueKey;
  final String extraText;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Material(
        shape: showBorder
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.orange, width: 1),
              )
            : null,
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_up),
                        onPressed: () => boardState.incDecItem(valueKey, 1)),
                    IconButton(
                        icon: Icon(Icons.keyboard_double_arrow_up),
                        onPressed: () => boardState.incDecItem(valueKey, 10)),
                  ]),
              Text(extraText + boardState.getItem(valueKey).toString() + "£",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        onPressed: () => boardState.incDecItem(valueKey, -1)),
                    IconButton(
                        icon: Icon(Icons.keyboard_double_arrow_down),
                        onPressed: () => boardState.incDecItem(valueKey, -10)),
                  ]),
            ])));
  }
}
