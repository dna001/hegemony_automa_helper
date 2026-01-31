// Copyright 2023-2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hegemony_automa_helper/automa_widget.dart';
import 'package:hegemony_automa_helper/data/automa_state.dart';
import 'package:hegemony_automa_helper/data/board_state.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraint = 410;

class AutomaScreen extends StatefulWidget {
  @override
  _AutomaScreenState createState() => _AutomaScreenState();
}

class _AutomaScreenState extends State<AutomaScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    AutomaWidget(className: ClassName.Worker),
    AutomaWidget(className: ClassName.Capitalist),
    AutomaWidget(className: ClassName.Middle),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<AutomaState>().init(),
        initialData: Center(child: CircularProgressIndicator()),
        builder: (context, snapshot) {
          return Scaffold(
            body: _tabs[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Worker Class',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.money),
                  label: 'Capitalist Class',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.engineering),
                  label: 'Middle Class',
                ),
              ],
            ),
          );
        });
  }
}
