// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

const rowDivider = SizedBox(width: 60);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Column(children: <Widget>[
              PolicyRow(info: policyCards[0]),
              colDivider,
              PolicyRow(info: policyCards[1]),
              colDivider,
              PolicyRow(info: policyCards[2]),
              colDivider,
              PolicyRow(info: policyCards[3]),
              colDivider,
              PolicyRow(info: policyCards[4]),
              colDivider,
              PolicyRow(info: policyCards[5]),
              colDivider,
              PolicyRow(info: policyCards[6]),
            ])));
  }
}

class PolicyRow extends StatefulWidget {
  const PolicyRow({super.key, required this.info});

  final PolicyInfo info;

  @override
  State<PolicyRow> createState() => _PolicyRowState();
}

class _PolicyRowState extends State<PolicyRow> {
  int? _selectedSlot = 0;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(4.0));
    _selectedSlot = boardState.getItem(widget.info.key);

    return Material(
      borderRadius: borderRadius,
      color: widget.info.color,
      type: MaterialType.card,
      child: Column(children: <Widget>[
        Text(widget.info.name),
        Row(children: <Widget>[
          rowDivider,
          Text("A"),
          Radio<int>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.black),
            focusColor:
                MaterialStateColor.resolveWith((states) => Colors.black),
            value: 0,
            groupValue: _selectedSlot,
            onChanged: (value) {
              boardState.setItem(widget.info.key, value ?? 0);
            },
          ),
          rowDivider,
          Text("B"),
          Radio<int>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.black),
            focusColor:
                MaterialStateColor.resolveWith((states) => Colors.black),
            value: 1,
            groupValue: _selectedSlot,
            onChanged: (value) {
              boardState.setItem(widget.info.key, value ?? 0);
            },
          ),
          rowDivider,
          Text("C"),
          Radio<int>(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.black),
            focusColor:
                MaterialStateColor.resolveWith((states) => Colors.black),
            value: 2,
            groupValue: _selectedSlot,
            onChanged: (value) {
              boardState.setItem(widget.info.key, value ?? 0);
            },
          ),
        ]),
      ]),
    );
  }
}

class PolicyInfo {
  const PolicyInfo(this.number, this.name, this.color, this.key);
  final int number;
  final String name;
  final Color color;
  final String key;
}

const List<PolicyInfo> policyCards = <PolicyInfo>[
  PolicyInfo(1, "FISCAL POLICY", Colors.blue, "policy_fp"),
  PolicyInfo(2, "LABOR MARKET", Colors.deepPurple, "policy_lm"),
  PolicyInfo(3, "TAXATION", Colors.purple, "policy_tx"),
  PolicyInfo(4, "HEALTHCARD & BENEFITS", Colors.red, "policy_hb"),
  PolicyInfo(5, "EDUCATION", Colors.orange, "policy_ed"),
  PolicyInfo(6, "FOREIGN TRADE", Colors.brown, "policy_ft"),
  PolicyInfo(7, "IMMIGRATION", Color.fromARGB(255, 128, 128, 128), "policy_im"),
];
