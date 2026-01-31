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

class WorkerClassBoardWidget extends StatefulWidget {
  WorkerClassBoardWidget({this.small = false});
  final bool small;

  @override
  State<WorkerClassBoardWidget> createState() => _WorkerClassBoardState();
}

class _WorkerClassBoardState extends State<WorkerClassBoardWidget> {
  int? _prosperity = 0;

  Future<void> _detailsDialogue(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                width: widthConstraint,
                height: 600,
                child: WorkerClassBoardWidget()),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    _prosperity = boardState.getItem("wc_prosperity");
    Widget wcWidget = SizedBox();

    if (widget.small) {
      wcWidget = SizedBox(
          width: smallWidthConstraint,
          height: smallHeightConstraint,
          child: InkWell(
              onTap: () => _detailsDialogue(context),
              child: Column(
                children: [
                  Text("WORKER CLASS",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.orange)),
                  Row(children: [
                    VictoryPoints(
                        vpKey: "wc_vp", color: Colors.red, canModify: false),
                    SizedBox(
                        height: 40,
                        child: ProsperityRadioListTile<int>(
                          value: _prosperity ?? 0,
                          groupValue: _prosperity ?? 0,
                          onChanged: (value) {},
                        )),
                    Icon(Icons.person, color: Colors.red),
                    rowDivider,
                    Text(boardState.workerCount(ClassName.Worker).toString()),
                    rowDivider,
                    Icon(Icons.groups, color: Colors.red),
                    rowDivider,
                    Text(boardState.population(ClassName.Worker).toString()),
                    Icon(Icons.assignment_ind, color: Colors.red),
                    rowDivider,
                    Text(boardState.getItem("wc_bill_markers").toString()),
                  ]),
                  Row(children: [
                    Icon(Icons.money, color: Colors.red),
                    rowDivider,
                    Text(boardState.getItem("wc_income").toString() + "£",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.orange)),
                  ]),
                ],
              )));
    } else {
      wcWidget = Column(children: <Widget>[
        Text("WORKER CLASS",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.orange)),
        VictoryPoints(vpKey: "wc_vp", color: Colors.red),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.person, color: Colors.red),
          rowDivider,
          Text(boardState.workerCount(ClassName.Worker).toString()),
          rowDivider,
          Icon(Icons.groups, color: Colors.red),
          rowDivider,
          Text(boardState.population(ClassName.Worker).toString()),
          rowDivider,
          Icon(Icons.assignment_ind, color: Colors.red),
          rowDivider,
          Text(boardState.getItem("wc_bill_markers").toString()),
        ]),
        colDivider,
        Column(children: <Widget>[
          Text("INCOME"),
          AdjustableValueWidget(valueKey: "wc_income", showBorder: true),
        ]),
        colDivider,
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text("PROSPERITY"),
          rowDivider,
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
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
              itemBuilder: (context, index) => ProsperityRadioListTile<int>(
                value: index,
                groupValue: _prosperity ?? 0,
                onChanged: (value) {
                  _prosperity = value;
                  boardState.setItem("wc_prosperity", value ?? 0);
                },
              ),
            )),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          StorageArea(
            bsKey: "wc_food",
            icon: Icons.agriculture,
            iconColor: Colors.green,
            price: 0,
          ),
          StorageArea(
            bsKey: "wc_luxury",
            icon: Icons.smartphone,
            iconColor: Colors.blue,
            price: 0,
          ),
          StorageArea(
            bsKey: "wc_health",
            icon: Icons.heart_broken,
            iconColor: Colors.red,
            price: 0,
          ),
          StorageArea(
            bsKey: "wc_education",
            icon: Icons.school,
            iconColor: Colors.orange,
            price: 0,
          ),
          StorageArea(
            bsKey: "wc_influence",
            icon: Icons.chat_bubble,
            iconColor: Colors.purple,
            price: 0,
          ),
        ]),
        Text("LABOUR UNIONS"),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          UnionWidget(
              icon: Icons.agriculture,
              color: Colors.green,
              active: boardState.unionState(CompanyType.Food),
              onTap: () => boardState.toggleUnion(CompanyType.Food)),
          rowDivider,
          UnionWidget(
              icon: Icons.smartphone,
              color: Colors.blue,
              active: boardState.unionState(CompanyType.Luxury),
              onTap: () => boardState.toggleUnion(CompanyType.Luxury)),
          rowDivider,
          UnionWidget(
              icon: Icons.heart_broken,
              color: Colors.white,
              active: boardState.unionState(CompanyType.Health),
              onTap: () => boardState.toggleUnion(CompanyType.Health)),
          rowDivider,
          UnionWidget(
              icon: Icons.school,
              color: Colors.orange,
              active: boardState.unionState(CompanyType.Education),
              onTap: () => boardState.toggleUnion(CompanyType.Education)),
          rowDivider,
          UnionWidget(
              icon: Icons.chat_bubble,
              color: Colors.purple,
              active: boardState.unionState(CompanyType.Media),
              onTap: () => boardState.toggleUnion(CompanyType.Media)),
        ]),
        colDivider,
      ]);
    }
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.red, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6), child: wcWidget));
  }
}

class ProsperityRadioListTile<T> extends StatelessWidget {
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  const ProsperityRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        height: 20,
        //padding: EdgeInsets.symmetric(horizontal: 16),
        child: _customRadioButton,
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.red : Colors.black,
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
      child: Center(
          child: Text(
        this.value.toString(),
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      )),
    );
  }
}

class UnionWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const UnionWidget({
    required this.icon,
    required this.color,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 20,
          //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Icon(Icons.person,
              color: active ? color : color.withOpacity(0.5))),
    );
  }
}
