// Copyright 2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_setup_widget.dart';
import '../policy_widget.dart';
import '../company_list_widget.dart';
import '../state_area_widget.dart';
import '../unemployed_workers_widget.dart';
import '../export_widget.dart';
import '../round_and_tax_widget.dart';
import '../data/board_state.dart';
import '../business_deals_widget.dart';
import '../cc_board_widget.dart';
import '../mc_board_widget.dart';
import '../wc_board_widget.dart';

const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraintLeft = 450;
const double widthConstraintRight = 350;

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  bool gameStateSetup = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    print("w: $width h: $height");
  }

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    
    return boardState.gameSetup ? GameSetupWidget() : Column(children: [
      Row(children: [
        WorkerClassBoardWidget(small: true),
        CapitalistClassBoardWidget(small: true),
        boardState.numPlayers >= 3 ? MiddleClassBoardWidget(small: true) : SizedBox()
      ]),
      Row(children: [
        Column(children: [
          SizedBox(
              width: widthConstraintLeft, child: PolicyWidget(small: true)),
          SizedBox(width: widthConstraintLeft, child: Row(children: [BusinessDealsWidget(), Expanded(child: ExportWidget())])),
          SizedBox(
            width: widthConstraintLeft,
            child: CompanyListWidget(
                title: "CAPITALIST CLASS COMPANIES",
                cls: ClassName.Capitalist,
                borderColor: Colors.blue,
                bsKeyBase: "cc_company_slot",
                columns: 4,
                rows: 3),
          ),
          SizedBox(
              width: widthConstraintLeft,
              child: CompanyListWidget(
                  title: "MIDDLE CLASS COMPANIES",
                  cls: ClassName.Middle,
                  borderColor: Colors.yellow,
                  bsKeyBase: "mc_company_slot",
                  columns: 4,
                  rows: 2))
        ]),
        Column(children: [
          SizedBox(width: widthConstraintRight, child: RoundAndTaxWidget()),
          SizedBox(width: widthConstraintRight, child: StateAreaWidget()),
          SizedBox(
              width: widthConstraintRight,
              child: CompanyListWidget(
                  title: "PUBLIC COMPANIES",
                  cls: ClassName.State,
                  borderColor: Colors.grey,
                  bsKeyBase: "sc_company_slot",
                  columns: 3,
                  rows: 3)),
          SizedBox(
              width: widthConstraintRight, child: UnemployedWorkersWidget())
        ]),
      ])
    ]);
  }
}
