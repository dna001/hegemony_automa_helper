// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'screens/automa_screen.dart';
import 'screens/overview_screen.dart';
import 'constants.dart';
import 'navigationbar.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.useLightMode,
    required this.useMaterial3,
    required this.colorSelected,
  });

  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int screenIndex = ScreenSelected.overview.value;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  Widget createScreenFor(ScreenSelected screenSelected) {
    switch (screenSelected) {
      case ScreenSelected.overview:
        return const OverviewScreen();
      case ScreenSelected.workerClass:
        return const AutomaScreen(className: ClassNames.Worker);
      case ScreenSelected.capitalistClass:
        return const AutomaScreen(className: ClassNames.Capitalist);
      case ScreenSelected.middleClass:
        return const AutomaScreen(className: ClassNames.Middle);
    }
  }

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: const Text('Hegemony Automa Helper'),
      actions: [Container()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: createAppBar(),
        body: Row(
          children: <Widget>[
            createScreenFor(ScreenSelected.values[screenIndex]),
          ],
        ),
        bottomNavigationBar: NavigationBars(
          onSelectItem: (index) {
            setState(() {
              screenIndex = index;
              handleScreenChanged(screenIndex);
            });
          },
          selectedIndex: screenIndex,
        ));
  }
}
