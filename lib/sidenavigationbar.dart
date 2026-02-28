// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class SideNavbarX extends StatelessWidget {
  const SideNavbarX({
    Key? key,
    required SidebarXController controller,
    required this.onSelectItem,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;
  final void Function(int)? onSelectItem;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withAlpha(192)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withAlpha(64),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(96),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withAlpha(192),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      items: [
        SidebarXItem(
          icon: Icons.widgets,
          label: 'Overview',
          onTap: () {
            _controller.selectIndex(0);
            onSelectItem!(0);
          },
        ),
        SidebarXItem(
          icon: Icons.games,
          label: 'GameBoard',
          onTap: () {
            _controller.selectIndex(1);
            onSelectItem!(1);
          },
        ),
        SidebarXItem(
          icon: Icons.factory,
          label: 'Automa',
          onTap: () {
            _controller.selectIndex(2);
            onSelectItem!(2);
          },
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () {
            _controller.selectIndex(3);
            onSelectItem!(3);
          },
        ),
      ],
    );
  }
}

String sideNavbarGetTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Overview';
    case 1:
      return 'GameBoard';
    case 2:
      return 'Automa';
    case 3:
      return 'Settings';
    default:
      return 'Page not found';
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withAlpha(192);
final divider = Divider(color: white.withAlpha(64), height: 1);
