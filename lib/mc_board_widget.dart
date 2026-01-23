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

class MiddleClassBoardWidget extends StatefulWidget {
  MiddleClassBoardWidget({this.small = false});
  final bool small;

  @override
  State<MiddleClassBoardWidget> createState() => _MiddleClassBoardState();
}

class _MiddleClassBoardState extends State<MiddleClassBoardWidget> {
  int? _prosperity = 0;

  Future<void> _detailsDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                width: widthConstraint,
                height: 600,
                child: MiddleClassBoardWidget()),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    Widget mcWidget = SizedBox();

    if (widget.small) {
      mcWidget = SizedBox(
          width: 200,
          height: 100,
          child: InkWell(
            onTap: () => _detailsDialogue(context),
            child: Column(children: [
              Text("MIDDLE CLASS",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              Row(children: [
                VictoryPoints(
                    vpKey: "mc_vp", color: Colors.red, canModify: false),
                SizedBox(
                    height: 40,
                    child: ProseprityRadioListTile<int>(
                      value: _prosperity ?? 0,
                      groupValue: _prosperity ?? 0,
                      onChanged: (value) {
                      },
                    )),
                Icon(Icons.person, color: Colors.yellow),
                rowDivider,
                Text(boardState.workerCount(ClassName.Middle).toString()),
                rowDivider,
                Icon(Icons.groups, color: Colors.yellow),
                rowDivider,
                Text(boardState.population(ClassName.Middle).toString()),
                rowDivider,
                Icon(Icons.assignment_ind, color: Colors.yellow),
                rowDivider,
                Text(boardState.getItem("mc_bill_markers").toString()),
              ]),
              Row(children: [
                Icon(Icons.money, color: Colors.yellow),
                rowDivider,
                Text(boardState.getItem("mc_income").toString() + "£",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              ]),
            ]),
          ));
    } else {
      mcWidget = Column(children: <Widget>[
        Text("MIDDLE CLASS",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.orange)),
        VictoryPoints(vpKey: "mc_vp", color: Colors.yellow),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.person, color: Colors.yellow),
          rowDivider,
          Text(boardState.workerCount(ClassName.Middle).toString()),
          rowDivider,
          Icon(Icons.groups, color: Colors.yellow),
          rowDivider,
          Text(boardState.population(ClassName.Middle).toString()),
          rowDivider,
          Icon(Icons.assignment_ind, color: Colors.yellow),
          rowDivider,
          Text(boardState.getItem("mc_bill_markers").toString()),
        ]),
        colDivider,
        Column(children: <Widget>[
          Text("INCOME"),
          AdjustableValueWidget(valueKey: "mc_income", showBorder: true),
        ]),
        colDivider,
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text("PROSPERITY"),
          rowDivider,
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow,
            ),
            child: Icon(Icons.sentiment_satisfied, color: Colors.black),
          ),
        ]),
        colDivider,
        SizedBox(
            height: 40,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 11, crossAxisSpacing: 2.0),
              itemCount: 11,
              itemBuilder: (context, index) => ProseprityRadioListTile<int>(
                value: index,
                groupValue: _prosperity ?? 0,
                onChanged: (value) {
                  setState(() {
                    _prosperity = value;
                  });
                },
              ),
            )),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          StorageArea(
            bsKey: "mc_food",
            icon: Icons.agriculture,
            iconColor: Colors.green,
            price: 0,
          ),
          StorageArea(
            bsKey: "mc_luxury",
            icon: Icons.smartphone,
            iconColor: Colors.blue,
            price: 0,
          ),
          StorageArea(
            bsKey: "mc_health",
            icon: Icons.heart_broken,
            iconColor: Colors.red,
            price: 0,
          ),
          StorageArea(
            bsKey: "mc_education",
            icon: Icons.school,
            iconColor: Colors.orange,
            price: 0,
          ),
          StorageArea(
            bsKey: "mc_influence",
            icon: Icons.chat_bubble,
            iconColor: Colors.purple,
            price: 0,
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          StorageArea(
            bsKey: "mc_storage_food",
            icon: Icons.agriculture,
            iconColor: Colors.green,
            price: 12,
          ),
          StorageArea(
            bsKey: "mc_storage_luxury",
            icon: Icons.smartphone,
            iconColor: Colors.blue,
            price: 8,
          ),
          StorageArea(
            bsKey: "mc_storage_health",
            icon: Icons.heart_broken,
            iconColor: Colors.red,
            price: 8,
          ),
          StorageArea(
            bsKey: "mc_storage_education",
            icon: Icons.school,
            iconColor: Colors.orange,
            price: 8,
          ),
        ]),
      ]);
    }
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.yellow, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6), child: mcWidget));
  }
}

class ProseprityRadioListTile<T> extends StatelessWidget {
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;
  static const List<int> prosperityConverter = [
    0,
    1,
    2,
    3,
    4,
    5,
    5,
    6,
    6,
    7,
    7
  ];

  const ProseprityRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: _customRadioButton,
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.yellow : Colors.black,
        border: Border.all(
          color: Colors.yellow,
          width: 2,
        ),
      ),
      child: Center(
          child: Text(
        prosperityConverter[this.value].toString(),
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.yellow,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      )),
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
