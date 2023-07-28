// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 5);

class CompanyWidget extends StatefulWidget {
  CompanyWidget(
      {required this.info,
      this.mode = CompanyViewMode.small,
      this.onAdd,
      required this.bsKeyBase,
      required this.slot});
  final CompanyInfo info;
  final CompanyViewMode mode;
  final VoidCallback? onAdd;
  final String bsKeyBase;
  final int slot;

  @override
  State<CompanyWidget> createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  @override
  Widget build(BuildContext context) {
    final BoardState boardState = context.watch<BoardState>();
    Widget priceRow = SizedBox(width: 1);
    String bsKeySlot = widget.bsKeyBase + widget.slot.toString();

    if (widget.mode == CompanyViewMode.select) {
      priceRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(widget.info.priceHigh.toString() + "£",
                style: TextStyle(
                  color: Colors.red,
                  //fontWeight: FontWeight.bold,
                  //fontSize: 12)
                )),
            Text(widget.info.priceMid.toString() + "£",
                style: TextStyle(
                  color: Colors.yellow,
                )),
            Text(widget.info.priceLow.toString() + "£",
                style: TextStyle(
                  color: Colors.blue,
                )),
          ]);
    } else if (widget.mode == CompanyViewMode.small) {
      int priceSlot = boardState.getItem(bsKeySlot + "_price");
      Color color = (priceSlot == 0)
          ? Colors.red
          : (priceSlot == 1)
              ? Colors.orange
              : Colors.blue;
      int price = (priceSlot == 0)
          ? widget.info.priceHigh
          : (priceSlot == 1)
              ? widget.info.priceMid
              : widget.info.priceLow;
      priceRow = Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
          child: Container(
            //width: 40,
            //padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: TextButton(
              child: Text(price.toString() + "£",
                  style: TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12)),
              onPressed: () => {
                if (boardState.getItem(bsKeySlot + "_price") == 0)
                  {boardState.setItem(bsKeySlot + "_price", 2)}
                else if (boardState.getItem(bsKeySlot + "_price") == 1)
                  {boardState.setItem(bsKeySlot + "_price", 0)}
                else
                  {boardState.setItem(bsKeySlot + "_price", 1)}
              },
            ),
          ));
    }

    List<Widget> workerRowWidgets = [];
    for (int workerSlot = 0;
        workerSlot < widget.info.workerSlots.length;
        workerSlot++) {
      WorkerType workerType = widget.info.workerSlots[workerSlot];
      IconData baseIcon = (workerType.index >= WorkerType.AnyUnskilled.index)
          ? Icons.people_alt
          : (workerType.index >= WorkerType.McUnskilled.index)
              ? Icons.engineering
              : Icons.person;
      bool isSkilledSlot = (workerType != WorkerType.WcUnskilled &&
          workerType != WorkerType.McUnskilled &&
          workerType != WorkerType.AnyUnskilled);
      int worker =
          boardState.getItem(bsKeySlot + "_worker" + workerSlot.toString());
      bool isSkilledWorker = (worker != 0 &&
          worker != WorkerType.WcUnskilled.index &&
          worker != WorkerType.McUnskilled.index);
      ClassName cls = boardState.workerClass(
          boardState.getItem(bsKeySlot + "_worker" + workerSlot.toString()));
      bool occupied =
          boardState.getItem(bsKeySlot + "_worker" + workerSlot.toString()) > 0;
      if (widget.mode == CompanyViewMode.select) {
        occupied = false;
      }

      workerRowWidgets.add(WorkerWidget(
          info: widget.info,
          workerBaseIconData: baseIcon,
          iconColor: (isSkilledWorker)
              ? _getWorkerColor(worker)
              : (isSkilledSlot)
                  ? (widget.info.type == CompanyType.Health)
                      ? Colors.white
                      : widget.info.color
                  : Colors.grey,
          workerIconData: (occupied)
              ? (cls == ClassName.Worker)
                  ? Icons.person
                  : (cls == ClassName.Middle)
                      ? Icons.engineering
                      : null
              : null,
          onTap: (widget.mode == CompanyViewMode.small)
              ? () => boardState.cycleWorkers(
                  bsKeySlot + "_worker", workerSlot, widget.info.id)
              : null));
    }

    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: widget.info.color,
      child: Column(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(widget.info.name),
              Column(children: <Widget>[
                Text(widget.info.price.toString() + "£"),
                (widget.mode == CompanyViewMode.small)
                    ? IconButton(
                        icon: Icon(Icons.monetization_on),
                        onPressed: () => boardState.sellCompany(
                            widget.bsKeyBase, widget.slot))
                    : SizedBox(width: 10),
              ]),
            ]),
        Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Material(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.black.withOpacity(0.4),
                child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.info.production.toString()),
                        Icon(widget.info.productionIcon,
                            color: widget.info.color),
                        rowDivider,
                        (widget.info.productionExtra > 0)
                            ? (widget.info.cls == ClassName.Middle)
                                ? Icon(Icons.person, color: Colors.grey)
                                : Icon(Icons.settings)
                            : SizedBox(width: 1),
                        (widget.info.productionExtra > 0)
                            ? Text(
                                ": +" + widget.info.productionExtra.toString())
                            : SizedBox(width: 1),
                        (widget.info.productionExtra > 0)
                            ? Icon(widget.info.productionIcon,
                                color: widget.info.color)
                            : SizedBox(width: 1),
                      ]),
                  (widget.info.workerSlots.length > 0)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[...workerRowWidgets])
                      : colDivider,
                  (widget.info.priceHigh > 0) ? priceRow : colDivider,
                ]))),
        (widget.mode == CompanyViewMode.select)
            ? IconButton(
                icon: Icon(Icons.add_business), onPressed: widget.onAdd)
            : SizedBox(width: 1),
      ]),
    );
  }

  Color _getWorkerColor(int workerType) {
    if (workerType == WorkerType.WcFood.index ||
        workerType == WorkerType.McFood.index) {
      return Colors.green;
    } else if (workerType == WorkerType.WcLuxury.index ||
        workerType == WorkerType.McLuxury.index) {
      return Colors.blue;
    } else if (workerType == WorkerType.WcHealth.index ||
        workerType == WorkerType.McHealth.index) {
      return Colors.white;
    } else if (workerType == WorkerType.WcEducation.index ||
        workerType == WorkerType.McEducation.index) {
      return Colors.orange;
    } else if (workerType == WorkerType.WcMedia.index ||
        workerType == WorkerType.McMedia.index) {
      return Colors.purple;
    }
    return Colors.black;
  }
}

class WorkerWidget extends StatelessWidget {
  const WorkerWidget({
    required this.info,
    required this.workerBaseIconData,
    required this.iconColor,
    this.workerIconData,
    this.onTap,
  });
  final CompanyInfo info;
  final IconData workerBaseIconData;
  final Color iconColor;
  final IconData? workerIconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Stack(alignment: Alignment.center, children: [
        // Base unoccuppied
        (workerIconData != null)
            ? Icon(workerIconData, color: iconColor, size: 30)
            : Icon(workerBaseIconData,
                color: (workerIconData != null)
                    ? Colors.grey
                    : iconColor.withOpacity(0.5),
                size: 30)
      ]),
    );
  }
}

enum CompanyViewMode {
  small,
  edit,
  select,
}
