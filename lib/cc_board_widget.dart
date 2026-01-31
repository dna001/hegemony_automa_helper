// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';
import 'adjustable_value_widget.dart';
import 'storage_area_widget.dart';
import 'victory_point_widget.dart';

const rowDivider = SizedBox(width: 5);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;
const double smallWidthConstraint = 195;
const double smallHeightConstraint = 102;

class CapitalistClassBoardWidget extends StatefulWidget {
  CapitalistClassBoardWidget({this.small = false});
  final bool small;

  @override
  State<CapitalistClassBoardWidget> createState() =>
      _CapitalistClassBoardState();
}

class _CapitalistClassBoardState extends State<CapitalistClassBoardWidget> {
  int? _wealth = 0;

  Future<void> _detailsDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                width: widthConstraint,
                height: 600,
                child: CapitalistClassBoardWidget()),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    Widget ccWidget = SizedBox();

    if (widget.small) {
      ccWidget = SizedBox(
          width: smallWidthConstraint,
          height: smallHeightConstraint,
          child: InkWell(
              onTap: () => _detailsDialogue(context),
              child: Column(
                children: [
                  Text("CAPITALIST CLASS",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.orange)),
                  Row(children: [
                    VictoryPoints(
                        vpKey: "cc_vp", color: Colors.red, canModify: false),
                    SizedBox(
                        height: 40,
                        width: 40,
                        child: WealthRadioListTile<int>(
                          value: _wealth ?? 0,
                          groupValue: _wealth ?? 0,
                          onChanged: (value) {},
                        ))
                  ]),
                  Row(children: [
                    Icon(Icons.lock, color: Colors.blue),
                    rowDivider,
                    Text(boardState.getItem("cc_capital").toString() + "£",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.orange)),
                    rowDivider,
                    Icon(Icons.money, color: Colors.blue),
                    rowDivider,
                    Text(boardState.getItem("cc_revenue").toString() + "£",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.orange)),
                  ]),
                ],
              )));
    } else {
      ccWidget = Column(children: <Widget>[
        Text("CAPITALIST CLASS",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.orange)),
        colDivider,
        VictoryPoints(vpKey: "cc_vp", color: Colors.red),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.assignment_ind, color: Colors.blue),
          rowDivider,
          Text(boardState.getItem("cc_bill_markers").toString()),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Column(children: <Widget>[
            Text("REVENUE"),
            AdjustableValueWidget(valueKey: "cc_revenue", showBorder: true),
          ]),
          Column(children: <Widget>[
            Text("CAPITAL"),
            AdjustableValueWidget(valueKey: "cc_capital", showBorder: true),
          ]),
        ]),
        Text("WEALTH"),
        colDivider,
        SizedBox(
            height: 100,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9, crossAxisSpacing: 2.0),
              itemCount: 16,
              itemBuilder: (context, index) => WealthRadioListTile<int>(
                value: index,
                groupValue: _wealth ?? 0,
                onChanged: (value) {
                  setState(() {
                    _wealth = value;
                  });
                },
              ),
            )),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          StorageArea(
            bsKey: "cc_storage_food",
            icon: Icons.agriculture,
            iconColor: Colors.green,
            price: 12,
          ),
          StorageArea(
            bsKey: "cc_storage_luxury",
            icon: Icons.smartphone,
            iconColor: Colors.blue,
            price: 8,
          ),
          StorageArea(
            bsKey: "cc_storage_health",
            icon: Icons.heart_broken,
            iconColor: Colors.red,
            price: 8,
          ),
          StorageArea(
            bsKey: "cc_storage_education",
            icon: Icons.school,
            iconColor: Colors.orange,
            price: 8,
          ),
          VerticalDividerCustom(),
          StorageArea(
            bsKey: "cc_influence",
            icon: Icons.chat_bubble,
            iconColor: Colors.purple,
            price: 0,
          ),
        ]),
      ]);
    }
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.blue, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6), child: ccWidget));
  }
}

class WealthRadioListTile<T> extends StatelessWidget {
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  const WealthRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () => onChanged(value), child: _customRadioButton);
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.blue : Colors.black,
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
      ),
      child: Stack(alignment: AlignmentGeometry.center, children: <Widget>[
        Icon(Icons.star_rounded, color: Colors.grey, size: 35),
        Text(this.value.toString(),
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
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
