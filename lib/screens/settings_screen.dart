// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/automa_state.dart';
import '../constants.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 410;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  @override
  Widget build(BuildContext context) {
    final AutomaState automaState = context.watch<AutomaState>();

    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 20, 16.0, 0),
        child: Column(children: <Widget>[
          SaveSlotButtons(),
          colDivider,
          FilledButton(
              onPressed: () => automaState.clear(), child: Text('Clear'))
        ]));
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
        ],
      ),
    );
  }
}
