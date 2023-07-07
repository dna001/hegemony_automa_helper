// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';
import 'constants.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 5);

class CompanyWidget extends StatefulWidget {
  CompanyWidget({required this.info});
  final CompanyInfo info;

  @override
  State<CompanyWidget> createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  int? _priceSlot = 1;

  @override
  Widget build(BuildContext context) {
    final BoardState boardState = context.watch<BoardState>();

    Widget priceRow = Row(children: <Widget>[
      Radio<int>(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.redAccent),
        focusColor:
            MaterialStateColor.resolveWith((states) => Colors.redAccent),
        value: 0,
        groupValue: _priceSlot,
        onChanged: (value) {
          setState(() {
            _priceSlot = value;
          });
        },
      ),
      Text(widget.info.priceHigh.toString()),
      Radio<int>(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.yellow),
        focusColor: MaterialStateColor.resolveWith((states) => Colors.yellow),
        value: 1,
        groupValue: _priceSlot,
        onChanged: (value) {
          setState(() {
            _priceSlot = value;
          });
        },
      ),
      Text(widget.info.priceMid.toString()),
      Radio<int>(
        fillColor:
            MaterialStateColor.resolveWith((states) => Colors.blueAccent),
        focusColor:
            MaterialStateColor.resolveWith((states) => Colors.blueAccent),
        value: 2,
        groupValue: _priceSlot,
        onChanged: (value) {
          setState(() {
            _priceSlot = value;
          });
        },
      ),
      Text(widget.info.priceLow.toString()),
    ]);

    List<Widget> workerRowWidgets = [];
    if (widget.info.skilledWorkers > 0) {
      workerRowWidgets.add(
        Icon(Icons.person, color: widget.info.color),
      );
    }
    for (int i = 0; i < widget.info.unskilledWorkers; i++) {
      workerRowWidgets.add(
        Icon(Icons.person, color: Colors.blueGrey),
      );
    }

    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: widget.info.color,
      child: Column(
        children: <Widget>[
          Text(widget.info.name + " £" + widget.info.price.toString()),
          Row(children: <Widget>[
            Text(widget.info.production.toString()),
            Icon(widget.info.productionIcon),
          ]),
          (widget.info.skilledWorkers + widget.info.unskilledWorkers > 0)
              ? Row(children: <Widget>[...workerRowWidgets])
              : colDivider,
          (widget.info.priceHigh > 0) ? priceRow : colDivider,
        ],
      ),
    );
  }
}

class CompanyInfo {
  const CompanyInfo(
      this.id,
      this.name,
      this.color,
      this.price,
      this.production,
      this.productionExtra,
      this.productionIcon,
      this.priceHigh,
      this.priceMid,
      this.priceLow,
      this.skilledWorkers,
      this.unskilledWorkers);
  final int id;
  final String name;
  final Color color;
  final int price;
  final int production;
  final int productionExtra;
  final IconData productionIcon;
  final int priceHigh;
  final int priceMid;
  final int priceLow;
  final int skilledWorkers;
  final int unskilledWorkers;
}
