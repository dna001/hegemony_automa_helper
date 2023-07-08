// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/automa_state.dart';
import '../policy_widget.dart';
import '../cc_companies_widget.dart';
import '../mc_companies_widget.dart';
import '../sc_companies_widget.dart';
import '../state_area_widget.dart';
import '../unemployed_workers_widget.dart';
import '../constants.dart';

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
  bool showLargeSizeLayout = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    if (width > largeWidthBreakpoint) {
      showLargeSizeLayout = true;
    } else {
      showLargeSizeLayout = false;
    }
  }

  List<Widget> _firstHalfSlivers() {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: SaveSlotButtons(),
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
          child: CapitalistClassCompaniesWidget(),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
          child: MiddleClassCompaniesWidget(),
        ),
      ),
    ];
  }

  List<Widget> _secondHalfSlivers() {
    return [
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: StateAreaWidget())),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: StateClassCompaniesWidget())),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
              child: UnemployedWorkersWidget())),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //final automaState automaState = context.watch<automaState>();

    return showLargeSizeLayout
        ? SizedBox(
            width: 1000,
            child: Row(children: [
              SizedBox(
                  width: 450,
                  child: CustomScrollView(
                    slivers: [..._firstHalfSlivers()],
                  )),
              SizedBox(
                  width: 450,
                  child: CustomScrollView(
                    slivers: [..._secondHalfSlivers()],
                  )),
            ]),
          )
        : SizedBox(
            width: 450,
            child: CustomScrollView(
                slivers: [..._firstHalfSlivers(), ..._secondHalfSlivers()]));
  }
}

class SaveSlotButtons extends StatefulWidget {
  const SaveSlotButtons({super.key});

  @override
  State<SaveSlotButtons> createState() => _SaveSlotButtonsState();
}

class _SaveSlotButtonsState extends State<SaveSlotButtons> {
  int? _selectedSlot = 0;

  @override
  Widget build(BuildContext context) {
    final AutomaState automaState = context.watch<AutomaState>();
    final List<Widget> widgets = <Widget>[];
    _selectedSlot = automaState.saveSlot;
    for (int i = 0; i < 5; i++) {
      widgets.add(
          /*ListTile(
        title: Text(i.toString()),
        leading: */
          Radio<int>(
        fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
        focusColor: MaterialStateColor.resolveWith((states) => Colors.white),
        value: i,
        groupValue: _selectedSlot,
        onChanged: (value) {
          automaState.setSaveSlot(value ?? 0);
        },
        //),
      ));
    }

    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      color: Colors.blueGrey,
      child: Row(
        children: <Widget>[
          rowDivider,
          Text(
            "Save Slot",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white),
          ),
          rowDivider,
          ...widgets,
          rowDivider,
          FilledButton(
            onPressed: () => automaState.clear(),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
