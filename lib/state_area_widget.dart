// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';

const rowDivider = SizedBox(width: 10);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class StateAreaWidget extends StatelessWidget {
  const StateAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      StateTreasurey(),
      colDivider,
      PublicServices(),
    ]);
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
              Row(children: <Widget>[
                rowDivider,
                FilledButton(
                    onPressed: () => boardState.incDecItem("sc_money", -10),
                    child: Text('-10£')),
                rowDivider,
                FilledButton(
                    onPressed: () => boardState.incDecItem("sc_money", -1),
                    child: Text('-1£')),
                rowDivider,
                Text(boardState.getItem("sc_money").toString() + "£",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.orange)),
                rowDivider,
                FilledButton(
                    onPressed: () => boardState.incDecItem("sc_money", 1),
                    child: Text('+1£')),
                rowDivider,
                FilledButton(
                    onPressed: () => boardState.incDecItem("sc_money", 10),
                    child: Text('+10£')),
              ])
            ])));
  }
}

class PublicServices extends StatelessWidget {
  const PublicServices({super.key});

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
              Text("PUBLIC SERVICES",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              Row(children: <Widget>[
                PublicService(
                    bsKey: "sc_health",
                    icon: Icons.heart_broken,
                    iconColor: Colors.red),
                VerticalDividerCustom(),
                PublicService(
                    bsKey: "sc_education",
                    icon: Icons.school,
                    iconColor: Colors.orange),
                VerticalDividerCustom(),
                PublicService(
                    bsKey: "sc_media",
                    icon: Icons.chat_bubble,
                    iconColor: Colors.purple),
              ])
            ])));
  }
}

class PublicService extends StatelessWidget {
  const PublicService(
      {super.key,
      required this.bsKey,
      required this.icon,
      required this.iconColor});
  final String bsKey;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(children: <Widget>[
        SizedBox(width: 90),
        Text(boardState.getItem(bsKey + "_price").toString() + "£",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.orange)),
        colDivider,
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
