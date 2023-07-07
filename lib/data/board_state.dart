// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ClassNames { Worker, Capitalist, Middle }

class BoardState extends ChangeNotifier {
  int saveSlot = 0;
  Map<String, int> boardData = {};
  List<Map<String, int>> undoBoardData = [];

  BoardState() {
    _resetBoardState();
  }

  Future<void> init() async {
    await setSaveSlot(0);
  }

  Future<void> setSaveSlot(int slot) async {
    // Set save slot and load state
    saveSlot = slot;
    await load(slot: slot);
    notifyListeners();
  }

  void _resetBoardState() {
    // Global variables
    boardData["policy_fp"] = 0;
    boardData["policy_lm"] = 0;
    boardData["policy_tx"] = 0;
    boardData["policy_hb"] = 0;
    boardData["policy_ed"] = 0;
    boardData["policy_ft"] = 0;
    boardData["policy_im"] = 0;
    boardData["round"] = 0;
    boardData["tax_multiplier"] = 0;
    // Class variables
    boardData["wc_points"] = 0;
    boardData["cc_points"] = 0;
    boardData["mc_points"] = 0;
    boardData["sc_points"] = 0;
  }

  void setItem(String key, int value) {
    boardData[key] = value;
    notifyListeners();
  }

  int getItem(String key) {
    return boardData[key] ?? 0;
  }

  Future<void> load({int slot = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if slot used before loading
    int foundKeys = 0;
    for (MapEntry<String, int> item in boardData.entries) {
      if (!prefs.containsKey(item.key)) {
        break;
      }
      boardData[item.key] = prefs.getInt(item.key) ?? 0;
    }
    if (foundKeys == 0) {
      print("Slot " + slot.toString() + " is empty");
    } else {
      print("Loaded " +
          foundKeys.toString() +
          " keys from, slot " +
          slot.toString());
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    for (MapEntry<String, int> item in boardData.entries) {
      await prefs.setInt(item.key, item.value);
    }
  }

  void _storeUndoInfo(String key, int value) {
    Map<String, int> map = {};
    map[key] = value;
    undoBoardData.add(map);
  }

  Future<void> undo() async {
    final prefs = await SharedPreferences.getInstance();
    // Undo last action
    if (undoBoardData.length > 0) {
      Map<String, int> map = undoBoardData.removeLast();
      for (MapEntry<String, int> item in map.entries) {
        boardData[item.key] = item.value;
        await prefs.setInt(item.key, item.value);
      }
    }
    notifyListeners();
  }
}
