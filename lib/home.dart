// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import 'data/automa_state.dart';
import 'screens/automa_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/settings_screen.dart';
import 'constants.dart';
import 'sidenavigationbar.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int screenIndex = ScreenSelected.overview.value;
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

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

  Widget createScreenFor(int screenSelected) {
    switch (screenSelected) {
      case 0:
        return const OverviewScreen();
      case 1:
        return const AutomaScreen(className: ClassNames.Worker);
      case 2:
        return const AutomaScreen(className: ClassNames.Capitalist);
      case 3:
        return const AutomaScreen(className: ClassNames.Middle);
      case 4:
        return const SettingsScreen();
      default:
        return const Text("Out of screens");
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
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 500;
        return Scaffold(
          key: _scaffoldKey,
          appBar: isSmallScreen
              ? AppBar(
                  backgroundColor: Colors.black,
                  title: Text(sideNavbarGetTitleByIndex(screenIndex)),
                  leading: IconButton(
                    onPressed: () {
                      // if (!Platform.isAndroid && !Platform.isIOS) {
                      //   _controller.setExtended(true);
                      // }
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  ),
                )
              : null,
          drawer: SideNavbarX(
              controller: _controller, onSelectItem: handleScreenChanged),
          body: Row(
            children: [
              if (!isSmallScreen)
                SideNavbarX(
                    controller: _controller, onSelectItem: handleScreenChanged),
              Expanded(
                child: Center(
                  child: createScreenFor(screenIndex),
                ),
              ),
            ],
          ),
        );
      },
    );

    /*Scaffold(
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
        ));*/
  }
}
