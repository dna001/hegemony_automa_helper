// Copyright 2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/action_widget.dart';
import '../widgets/game_setup_widget.dart';
import '../widgets/policy_widget.dart';
import '../widgets/company_list_widget.dart';
import '../widgets/public_services_widget.dart';
import '../widgets/state_area_widget.dart';
import '../widgets/unemployed_workers_widget.dart';
import '../widgets/export_widget.dart';
import '../widgets/round_and_tax_widget.dart';
import '../data/board_state.dart';
import '../widgets/business_deals_widget.dart';
import '../widgets/cc_board_widget.dart';
import '../widgets/mc_board_widget.dart';
import '../widgets/wc_board_widget.dart';

const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;

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
    final double widthConstraint = MediaQuery.of(context).size.width / 2;

    return boardState.gameSetup
        ? GameSetupWidget()
        : Column(children: [
            Row(children: [
              WorkerClassBoardWidget(small: true),
              CapitalistClassBoardWidget(small: true),
              boardState.numPlayers >= 3
                  ? MiddleClassBoardWidget(small: true)
                  : SizedBox()
            ]),
            Row(children: [
              SizedBox(
                  width: widthConstraint, child: PolicyWidget(small: true)),
              Expanded(
                  child: Column(
                      children: [RoundAndTaxWidget(), StateAreaWidget()]))
            ]),
            Row(children: [
              SizedBox(
                  width: widthConstraint,
                  child: Row(children: [
                    BusinessDealsWidget(),
                    Expanded(child: ExportWidget())
                  ])),
              Expanded(child: PublicServices(small: true))
            ]),
            Row(children: [
              SizedBox(
                width: widthConstraint,
                child: CompanyListWidget(
                    title: "CAPITALIST CLASS COMPANIES",
                    cls: ClassName.Capitalist,
                    borderColor: Colors.blue,
                    bsKeyBase: "cc_company_slot",
                    columns: 4,
                    rows: 3),
              ),
              SizedBox(
                  width: widthConstraint,
                  child: CompanyListWidget(
                      title: "PUBLIC COMPANIES",
                      cls: ClassName.State,
                      borderColor: Colors.grey,
                      bsKeyBase: "sc_company_slot",
                      columns: 3,
                      rows: 3)),
            ]),
            Row(children: [
              SizedBox(
                  width: widthConstraint,
                  child: CompanyListWidget(
                      title: "MIDDLE CLASS COMPANIES",
                      cls: ClassName.Middle,
                      borderColor: Colors.yellow,
                      bsKeyBase: "mc_company_slot",
                      columns: 4,
                      rows: 2)),
              SizedBox(
                  width: widthConstraint, child: UnemployedWorkersWidget()),
            ]),
            ActionWidget()
          ]);
  }
}
