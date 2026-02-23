// Copyright 2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

const colDivider = SizedBox(height: 5);

class PublicServices extends StatelessWidget {
  const PublicServices({super.key, this.small = false});
  final bool small;

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
              Text("PUBLIC SERVICES",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    PublicService(
                        bsKey: "sc_storage_health",
                        icon: Icons.heart_broken,
                        iconColor: Colors.red,
                        price: _getWelfareStatePrice(
                            boardState.getItem("policy_hb")),
                        small: small),
                    VerticalDividerCustom(),
                    PublicService(
                        bsKey: "sc_storage_education",
                        icon: Icons.school,
                        iconColor: Colors.orange,
                        price: _getWelfareStatePrice(
                            boardState.getItem("policy_ed")),
                        small: small),
                    VerticalDividerCustom(),
                    PublicService(
                        bsKey: "sc_storage_media",
                        icon: Icons.chat_bubble,
                        iconColor: Colors.purple,
                        price: 10,
                        small: small),
                  ])
            ])));
  }
}

class PublicService extends StatelessWidget {
  const PublicService(
      {super.key,
      required this.bsKey,
      required this.icon,
      required this.iconColor,
      required this.price,
      this.small = false});
  final String bsKey;
  final IconData icon;
  final Color iconColor;
  final int price;
  final bool small;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(children: [
        Text(price.toString() + "£",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.orange)),
        colDivider,
        small
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: () => boardState.incDecItem(bsKey, 1)),
        Row(children: <Widget>[
          Text(boardState.getItem(bsKey).toString(),
              style: Theme.of(context).textTheme.titleMedium),
          small
              ? IconButton(
                  icon: Icon(icon, color: iconColor), onPressed: () => {})
              : Icon(icon, color: iconColor),
        ]),
        small
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => boardState.incDecItem(bsKey, -1)),
      ]),
    );
  }
}

class VerticalDividerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 80.0,
      width: 2.0,
      color: Colors.orange,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}

int _getWelfareStatePrice(int index) {
  switch (index) {
    case 0:
      return 0;
    case 1:
      return 5;
    case 2:
      return 10;
    default:
      return 0;
  }
}
