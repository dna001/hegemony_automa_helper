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
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
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
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
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
          icon: Icons.factory,
          label: 'WC Automa',
          onTap: () {
            _controller.selectIndex(1);
            onSelectItem!(1);
          },
        ),
        SidebarXItem(
          icon: Icons.money,
          label: 'CC Automa',
          onTap: () {
            _controller.selectIndex(2);
            onSelectItem!(2);
          },
        ),
        SidebarXItem(
          icon: Icons.work,
          label: 'MC Automa',
          onTap: () {
            _controller.selectIndex(3);
            onSelectItem!(3);
          },
        ),
        SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
          onTap: () {
            _controller.selectIndex(4);
            onSelectItem!(4);
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
      return 'WC Automa';
    case 2:
      return 'CC Automa';
    case 3:
      return 'MC Automa';
    case 4:
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
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
