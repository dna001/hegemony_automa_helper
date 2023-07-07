// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:window_size/window_size.dart';

import 'constants.dart';
import 'home.dart';
import 'data/automa_state.dart';
import 'data/board_state.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    //setWindowMinSize(const Size(800, 500));
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AutomaState>(
        create: (_) => AutomaState(),
      ),
      ChangeNotifierProvider<BoardState>(
        create: (_) => BoardState(),
      ),
    ],
    child: const App(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.dark;
  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorScheme? imageColorScheme = const ColorScheme.light();

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<AutomaState>().init(),
        initialData: Center(child: CircularProgressIndicator()),
        builder: (context, snapshot) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Hegemony Automa Helper',
              themeMode: themeMode,
              theme: ThemeData(
                colorSchemeSeed: colorSelected.color,
                useMaterial3: useMaterial3,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                colorSchemeSeed: colorSelected.color,
                useMaterial3: useMaterial3,
                brightness: Brightness.dark,
              ),
              home: Home(
                useLightMode: useLightMode,
                useMaterial3: useMaterial3,
                colorSelected: colorSelected,
              ));
        });
  }
}
