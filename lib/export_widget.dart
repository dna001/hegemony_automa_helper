// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';

class ExportWidget extends StatelessWidget {
  const ExportWidget({super.key, this.id = -1, this.onAdd});
  final int id;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    int cardId = (id >= 0) ? id : boardState.getItem("export_card_id");

    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(children: <Widget>[
            Text("EXPORT",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.orange)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ExportGroupWidget(
                      exportList: exportCards[cardId].foodExportList,
                      iconData: Icons.agriculture,
                      iconColor: Colors.green),
                  ExportGroupWidget(
                      exportList: exportCards[cardId].healthExportList,
                      iconData: Icons.heart_broken,
                      iconColor: Colors.red),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ExportGroupWidget(
                      exportList: exportCards[cardId].luxuryExportList,
                      iconData: Icons.smartphone,
                      iconColor: Colors.blue),
                  ExportGroupWidget(
                      exportList: exportCards[cardId].educationExportList,
                      iconData: Icons.school,
                      iconColor: Colors.orange),
                ]),
            (id >= 0)
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => {
                          boardState.setItem("export_card_id", id),
                          Navigator.pop(context)
                        })
                : IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () => exportCardListDialogue(context)),
          ]),
        ));
  }

  Future<void> exportCardListDialogue(
      BuildContext context /*, void Function(int id) onAdd*/) {
    BoardState boardState = context.read<BoardState>();
    List<ExportCard> exportCardList = boardState.exportCardList();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
            width: 450,
            child: ListView.builder(
              itemCount: exportCardList.length,
              itemBuilder: (context, index) => ExportWidget(id: index),
            ),
          ));
        });
  }
}

class ExportGroupWidget extends StatelessWidget {
  const ExportGroupWidget({
    super.key,
    required this.exportList,
    required this.iconData,
    required this.iconColor,
  });
  final List<ExportItem> exportList;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Text(exportList[0].amount.toString()),
        Icon(iconData, color: iconColor),
        Icon(Icons.arrow_forward),
        Text(exportList[0].sellPrice.toString() + "£")
      ]),
      Row(children: <Widget>[
        Text(exportList[1].amount.toString()),
        Icon(iconData, color: iconColor),
        Icon(Icons.arrow_forward),
        Text(exportList[1].sellPrice.toString() + "£")
      ]),
    ]);
  }
}
