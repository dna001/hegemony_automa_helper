// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

const rowDivider = SizedBox(width: 50);
const colDivider = SizedBox(height: 2);
const double widthConstraint = 450;

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({super.key, this.small = false});
  final bool small;

  Future<void> _detailsDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                width: widthConstraint,
                height: 400,
                child: PolicyWidget()),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget policyRows = Padding(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
        child: Column(children: <Widget>[
          PolicyRow(info: policyCards[0], small: small),
          colDivider,
          PolicyRow(info: policyCards[1], small: small),
          colDivider,
          PolicyRow(info: policyCards[2], small: small),
          colDivider,
          PolicyRow(info: policyCards[3], small: small),
          colDivider,
          PolicyRow(info: policyCards[4], small: small),
          colDivider,
          PolicyRow(info: policyCards[5], small: small),
          colDivider,
          PolicyRow(info: policyCards[6], small: small),
        ]));
    Widget policyWidget = policyRows;
    if (small) {
      policyWidget = InkWell(onTap: () => _detailsDialogue(context), child: policyRows);
    }

    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        color: Colors.black,
        child: policyWidget);
  }
}

class PolicyRow extends StatefulWidget {
  const PolicyRow({super.key, required this.info, this.small = false});

  final PolicyInfo info;
  final bool small;

  @override
  State<PolicyRow> createState() => _PolicyRowState();
}

class _PolicyRowState extends State<PolicyRow> {
  int? _selectedSlot = 0;

  Widget _customSelectionCircle(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.black : Colors.transparent,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(4.0));
    _selectedSlot = boardState.getItem(widget.info.key);
    int clsA = boardState.getItem(widget.info.key + "_bill") & 0xf;
    int clsB = (boardState.getItem(widget.info.key + "_bill") >> 4) & 0xf;
    int clsC = (boardState.getItem(widget.info.key + "_bill") >> 8) & 0xf;
    Widget policyWidget = SizedBox();
    if (widget.small) {
      policyWidget = Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(children: [
              Text("A"),
              SizedBox(width: 5),
              _customSelectionCircle(_selectedSlot == 0)
            ]),
            rowDivider,
            Row(children: [
              Text("B"),
              SizedBox(width: 5),
              _customSelectionCircle(_selectedSlot == 1)
            ]),
            rowDivider,
            Row(children: [
              Text("C"),
              SizedBox(width: 5),
              _customSelectionCircle(_selectedSlot == 2)
            ])
          ]));
    } else {
      policyWidget = Column(children: <Widget>[
        Text(widget.info.name),
        RadioGroup<int>(
            groupValue: _selectedSlot,
            onChanged: (value) {
              boardState.setItem(widget.info.key, value ?? 0);
            },
            child: Row(children: <Widget>[
              rowDivider,
              Text("A"),
              (_selectedSlot != 0)
                  ? PolicyBill(
                      info: widget.info,
                      cls: clsA,
                      onTap: () =>
                          boardState.togglePolicyBill(widget.info.key, 0))
                  : SizedBox.shrink(),
              Radio<int>(
                fillColor:
                    WidgetStateColor.resolveWith((states) => Colors.black),
                focusColor:
                    WidgetStateColor.resolveWith((states) => Colors.black),
                value: 0,
              ),
              rowDivider,
              Text("B"),
              (_selectedSlot != 1)
                  ? PolicyBill(
                      info: widget.info,
                      cls: clsB,
                      onTap: () =>
                          boardState.togglePolicyBill(widget.info.key, 1))
                  : SizedBox.shrink(),
              Radio<int>(
                fillColor:
                    WidgetStateColor.resolveWith((states) => Colors.black),
                focusColor:
                    WidgetStateColor.resolveWith((states) => Colors.black),
                value: 1,
              ),
              rowDivider,
              Text("C"),
              (_selectedSlot != 2)
                  ? PolicyBill(
                      info: widget.info,
                      cls: clsC,
                      onTap: () =>
                          boardState.togglePolicyBill(widget.info.key, 2))
                  : SizedBox.shrink(),
              Radio<int>(
                fillColor:
                    WidgetStateColor.resolveWith((states) => Colors.black),
                focusColor:
                    WidgetStateColor.resolveWith((states) => Colors.black),
                value: 2,
              ),
            ])),
      ]);
    }

    return Material(
        borderRadius: borderRadius,
        color: widget.info.color,
        type: MaterialType.card,
        child: policyWidget);
  }
}

class PolicyBill extends StatelessWidget {
  final PolicyInfo info;
  final int cls;
  final VoidCallback onTap;

  const PolicyBill({
    required this.info,
    required this.cls,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = (cls == ClassName.Capitalist.index)
        ? Colors.blue
        : (cls == ClassName.Middle.index)
            ? Colors.yellow
            : (cls == ClassName.State.index)
                ? Colors.grey
                : (cls == ClassName.Worker.index)
                    ? Colors.red
                    : Colors.white;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
