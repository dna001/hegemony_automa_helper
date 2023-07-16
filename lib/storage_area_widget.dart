// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';

class StorageArea extends StatelessWidget {
  const StorageArea(
      {super.key,
      required this.bsKey,
      required this.icon,
      required this.iconColor,
      required this.price});
  final String bsKey;
  final IconData icon;
  final Color iconColor;
  final int price;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(children: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => boardState.incDecItem(bsKey, 1)),
        Row(children: <Widget>[
          Text(boardState.getItem(bsKey).toString(),
              style: Theme.of(context).textTheme.titleMedium),
          Icon(icon, color: iconColor),
        ]),
        IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => boardState.incDecItem(bsKey, -1)),
        (price > 0)
            ? Text(price.toString() + "£",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.orange))
            : SizedBox(height: 1),
      ]),
    );
  }
}
