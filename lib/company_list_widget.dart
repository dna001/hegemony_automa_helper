// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';
import 'company_widget.dart';

const rowDivider = SizedBox(width: 5);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class CompanyListWidget extends StatelessWidget {
  const CompanyListWidget(
      {super.key,
      required this.title,
      required this.cls,
      required this.borderColor,
      required this.bsKeyBase,
      this.columns = 4,
      this.rows = 2});
  final String title;
  final ClassName cls;
  final Color borderColor;
  final String bsKeyBase;
  final int columns;
  final int rows;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();

    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Column(children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.orange)),
                    Row(children: <Widget>[
                      Icon(Icons.person, color: Colors.grey),
                      Text(boardState
                          .workersInCompaniesCount(
                              bsKeyBase, cls, ClassName.Worker)
                          .toString()),
                      Icon(Icons.engineering, color: Colors.grey),
                      Text(boardState
                          .workersInCompaniesCount(
                              bsKeyBase, cls, ClassName.Middle)
                          .toString()),
                    ]),
                  ]),
              colDivider,
              SizedBox(
                height: rows * 110,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 2.0,
                      childAspectRatio: 1.0),
                  itemCount: boardState.usedCompanySlots(cls),
                  itemBuilder: (context, index) => CompanyWidget(
                      info: boardState.companyInfo(boardState
                          .getItem(bsKeyBase + index.toString() + "_id"))!,
                      mode: CompanyViewMode.small,
                      onTap: () => companyDetailsDialogue(
                          context,
                          boardState.companyInfo(boardState
                              .getItem(bsKeyBase + index.toString() + "_id"))!,
                          index),
                      bsKeyBase: bsKeyBase,
                      slot: index),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => companyListDialogue(
                      context,
                      (id) => boardState.addCompanyToFreeSlot(bsKeyBase, id,
                          pay: true))),
            ])));
  }

  Future<void> companyListDialogue(
      BuildContext context, void Function(int id) onAdd) {
    BoardState boardState = context.read<BoardState>();
    List<CompanyInfo> companyInfoList = boardState.companyCardList(cls);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
            width: widthConstraint,
            child: ListView.builder(
              itemCount: companyInfoList.length,
              itemBuilder: (context, index) => CompanyWidget(
                  info: companyInfoList[index],
                  mode: CompanyViewMode.select,
                  onAdd: () => {
                        onAdd(companyInfoList[index].id),
                        Navigator.pop(context)
                      },
                  bsKeyBase: bsKeyBase,
                  slot: index),
            ),
          ));
        });
  }

  Future<void> companyDetailsDialogue(
      BuildContext context, CompanyInfo info, int slot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: widthConstraint,
              height: 200,
              child: CompanyWidget(
                  info: info,
                  mode: CompanyViewMode.edit,
                  onSell: () => Navigator.pop(context),
                  bsKeyBase: bsKeyBase,
                  slot: slot),
            ),
          );
        });
  }
}
