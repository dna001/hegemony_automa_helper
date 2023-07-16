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
      required this.bsKeyBase});
  final String title;
  final ClassName cls;
  final Color borderColor;
  final String bsKeyBase;

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
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              SizedBox(
                height: 145,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      childAspectRatio: 1.25),
                  itemCount: boardState.getUsedCompanySlots(cls),
                  itemBuilder: (context, index) => CompanyWidget(
                      info: boardState.getCompanyInfo(boardState
                          .getItem(bsKeyBase + index.toString() + "_id"))!,
                      //onEdit: () => {companyEditDialogue(context, index)},
                      bsKeyBase: bsKeyBase + index.toString()),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => companyListDialogue(context,
                      (id) => boardState.addCompanyToFreeSlot(bsKeyBase, id))),
            ])));
  }

  Future<void> companyEditDialogue(BuildContext context, int id) {
    BoardState boardState = context.read<BoardState>();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(children: <Widget>[
            CompanyWidget(
                info: boardState.getCompanyInfo(
                    boardState.getItem(bsKeyBase + id.toString() + "_id"))!,
                mode: CompanyViewMode.edit,
                bsKeyBase: bsKeyBase + id.toString()),
          ]);
        });
  }

  Future<void> companyListDialogue(
      BuildContext context, void Function(int id) onAdd) {
    BoardState boardState = context.read<BoardState>();
    List<CompanyInfo> companyInfoList = boardState.getCompanyCardList(cls);

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
                  bsKeyBase: bsKeyBase + index.toString()),
            ),
          ));
        });
  }
}
