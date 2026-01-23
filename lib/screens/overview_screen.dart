// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import '../policy_widget.dart';
import '../cc_board_widget.dart';
import '../company_list_widget.dart';
import '../mc_board_widget.dart';
import '../wc_board_widget.dart';
import '../state_area_widget.dart';
import '../unemployed_workers_widget.dart';
import '../export_widget.dart';
import '../round_and_tax_widget.dart';
import '../data/board_state.dart';
import '../business_deals_widget.dart';

const double mediumWidthBreakpoint = 900;
const double largeWidthBreakpoint = 1350;
const double extraLargeWidthBreakpoint = 1800;
const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 450;

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;
  bool showExtraLargeSizeLayout = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    if (width >= extraLargeWidthBreakpoint) {
      showMediumSizeLayout = false;
      showLargeSizeLayout = false;
      showExtraLargeSizeLayout = true;
    } else if (width >= largeWidthBreakpoint) {
      showMediumSizeLayout = false;
      showLargeSizeLayout = true;
      showExtraLargeSizeLayout = false;
    } else if (width >= mediumWidthBreakpoint) {
      showMediumSizeLayout = true;
      showLargeSizeLayout = false;
      showExtraLargeSizeLayout = false;
    } else {
      showMediumSizeLayout = false;
      showLargeSizeLayout = false;
      showExtraLargeSizeLayout = false;
    }
  }

  List<Widget> _scSlivers() {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: RoundAndTaxWidget(),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: PolicyWidget(),
        ),
      ),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: BusinessDealsWidget())),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: ExportWidget())),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: StateAreaWidget())),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: CompanyListWidget(
                  title: "PUBLIC COMPANIES",
                  cls: ClassName.State,
                  borderColor: Colors.grey,
                  bsKeyBase: "sc_company_slot",
                  columns: 3,
                  rows: 3
      ))),
    ];
  }

  List<Widget> _wcSlivers() {
    return [
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: WorkerClassBoardWidget())),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: CompanyListWidget(
                  title: "WORKING CLASS COMPANIES",
                  cls: ClassName.Worker,
                  borderColor: Colors.red,
                  bsKeyBase: "wc_company_slot"))),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: UnemployedWorkersWidget())),
    ];
  }

  List<Widget> _ccSlivers() {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: CapitalistClassBoardWidget(),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: CompanyListWidget(
              title: "CAPITALIST CLASS COMPANIES",
              cls: ClassName.Capitalist,
              borderColor: Colors.blue,
              bsKeyBase: "cc_company_slot"),
        ),
      ),
    ];
  }

  List<Widget> _mcSlivers() {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: MiddleClassBoardWidget(),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: CompanyListWidget(
              title: "MIDDLE CLASS COMPANIES",
              cls: ClassName.Middle,
              borderColor: Colors.yellow,
              bsKeyBase: "mc_company_slot"),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //final automaState automaState = context.watch<automaState>();

    return showExtraLargeSizeLayout
        ? SizedBox(
            width: 2000,
            child: Row(children: [
              SizedBox(
                  width: widthConstraint,
                  child: CustomScrollView(
                    slivers: [..._scSlivers()],
                  )),
              SizedBox(
                  width: widthConstraint,
                  child: CustomScrollView(
                    slivers: [..._wcSlivers()],
                  )),
              SizedBox(
                  width: widthConstraint,
                  child: CustomScrollView(
                    slivers: [..._ccSlivers()],
                  )),
              SizedBox(
                  width: widthConstraint,
                  child: CustomScrollView(
                    slivers: [..._mcSlivers()],
                  )),
            ]),
          )
        : showLargeSizeLayout
            ? SizedBox(
                width: 1500,
                child: Row(children: [
                  SizedBox(
                      width: widthConstraint,
                      child: CustomScrollView(
                        slivers: [..._scSlivers()],
                      )),
                  SizedBox(
                      width: widthConstraint,
                      child: CustomScrollView(
                        slivers: [..._wcSlivers(), ..._ccSlivers()],
                      )),
                  SizedBox(
                      width: widthConstraint,
                      child: CustomScrollView(
                        slivers: [..._mcSlivers()],
                      )),
                ]),
              )
            : showMediumSizeLayout
                ? SizedBox(
                    width: 1000,
                    child: Row(children: [
                      SizedBox(
                          width: widthConstraint,
                          child: CustomScrollView(
                            slivers: [..._scSlivers(), ..._wcSlivers()],
                          )),
                      SizedBox(
                          width: widthConstraint,
                          child: CustomScrollView(
                            slivers: [..._ccSlivers(), ..._mcSlivers()],
                          )),
                    ]),
                  )
                : SizedBox(
                    width: widthConstraint,
                    child: CustomScrollView(slivers: [
                      ..._scSlivers(),
                      ..._wcSlivers(),
                      ..._ccSlivers(),
                      ..._mcSlivers(),
                    ]));
  }
}
