// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ClassName { Worker, Capitalist, Middle, State }

enum WorkerType {
  None,
  WcUnskilled,
  WcFood,
  WcLuxury,
  WcHealth,
  WcEducation,
  WcMedia,
  McUnskilled,
  McFood,
  McLuxury,
  McHealth,
  McEducation,
  McMedia
}

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
    boardData["policy_fp"] = 2;
    boardData["policy_lm"] = 1;
    boardData["policy_tx"] = 0;
    boardData["policy_hb"] = 1;
    boardData["policy_ed"] = 2;
    boardData["policy_ft"] = 1;
    boardData["policy_im"] = 1;
    boardData["round"] = 1;
    boardData["tax_multiplier"] = 5;
    // Worker Class variables
    boardData["wc_vp"] = 0;
    boardData["wc_income"] = 30;
    boardData["wc_prosperity"] = 0;
    boardData["wc_food"] = 0;
    boardData["wc_luxury"] = 0;
    boardData["wc_health"] = 0;
    boardData["wc_education"] = 0;
    boardData["wc_influence"] = 1;
    // Capital Class variables
    boardData["cc_vp"] = 0;
    boardData["cc_revenue"] = 120;
    boardData["cc_capital"] = 0;
    boardData["cc_wealth"] = 0;
    boardData["cc_storage_food"] = 1;
    boardData["cc_storage_luxury"] = 2;
    boardData["cc_storage_health"] = 0;
    boardData["cc_storage_education"] = 2;
    boardData["cc_influence"] = 1;
    addCompanyToSlot("cc_company_slot0", 1); // CLINIC
    addCompanyToSlot("cc_company_slot1", 2,
        filled: true, cls: ClassName.Worker); // COLLEGE
    addCompanyToSlot("cc_company_slot2", 3,
        filled: true, cls: ClassName.Middle); // SHOPPING MALL
    addCompanyToSlot("cc_company_slot3", 4,
        filled: true, cls: ClassName.Worker); // SUPERMARKET
    // Middle Class variables
    boardData["mc_vp"] = 0;
    boardData["mc_income"] = 40;
    boardData["mc_prosperity"] = 0;
    boardData["mc_storage_food"] = 1;
    boardData["mc_storage_luxury"] = 0;
    boardData["mc_storage_health"] = 1;
    boardData["mc_storage_education"] = 0;
    boardData["mc_influence"] = 1;
    addCompanyToSlot("mc_company_slot0", 100,
        filled: true, cls: ClassName.Middle); // DOCTOR'S OFFICE
    addCompanyToSlot("mc_company_slot1", 101,
        filled: true, cls: ClassName.Middle); // CONVENIENCE STORE
    // State variables
    boardData["sc_vp"] = 0;
    boardData["sc_treasury"] = 120;
    boardData["sc_storage_health"] = 6;
    boardData["sc_storage_education"] = 6;
    boardData["sc_storage_media"] = 4;
    boardData["sc_influence"] = 1;
    addCompanyToSlot("sc_company_slot0", 200,
        filled: true, cls: ClassName.Worker); // UNIVERSITY HOSPITAL
    addCompanyToSlot("sc_company_slot1", 201,
        filled: true, cls: ClassName.Middle); // TECHNICAL UNIVERSITY
    addCompanyToSlot("sc_company_slot2", 202); // NATIONAL PUBLIC BROADCASTING
  }

  void setItem(String key, int value) {
    boardData[key] = value;
    notifyListeners();
  }

  int getItem(String key) {
    return boardData[key] ?? 0;
  }

  void incDecItem(String key, int value) {
    int oldValue = boardData[key] ?? 0;
    boardData[key] = oldValue + value;
    // No value should be negative
    if (boardData[key]! < 0) {
      boardData[key] = 0;
    }
    notifyListeners();
  }

  void addCompanyToSlot(String keyBase, int id,
      {bool filled = false, ClassName cls = ClassName.Worker}) {
    boardData[keyBase + "_id"] = id;
    if (filled) {
      boardData[keyBase + "_worker0"] = (cls == ClassName.Worker)
          ? WorkerType.WcUnskilled.index
          : WorkerType.McUnskilled.index;
      boardData[keyBase + "_worker1"] = (cls == ClassName.Worker)
          ? WorkerType.WcUnskilled.index
          : WorkerType.McUnskilled.index;
      boardData[keyBase + "_worker2"] = (cls == ClassName.Worker)
          ? WorkerType.WcUnskilled.index
          : WorkerType.McUnskilled.index;
    } else {
      boardData[keyBase + "_worker0"] = 0;
      boardData[keyBase + "_worker1"] = 0;
      boardData[keyBase + "_worker2"] = 0;
    }
    boardData[keyBase + "_price"] = getItem("policy_lm");
    boardData[keyBase + "_commited"] = 0;
  }

  void addCompanyToFreeSlot(String keyBase, int id) {
    for (int slot = 0; slot < 16; slot++) {
      if (getItem(keyBase + slot.toString() + "_id") == 0) {
        addCompanyToSlot(keyBase + slot.toString(), id);
        print("New company $id added in slot $slot");
        break;
      }
    }
    notifyListeners();
  }

  int getNumWorkers(ClassName cls) {
    return 10;
  }

  int getPopulation(ClassName cls) {
    return (getNumWorkers(cls) / 3).floor();
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

  int getUsedCompanySlots(ClassName cls) {
    String key = "";
    int maxSlots = 0;
    int usedSlots = 0;
    switch (cls) {
      case ClassName.Capitalist:
        key = "cc_company_slot";
        maxSlots = 12;
        break;
      case ClassName.Middle:
        key = "mc_company_slot";
        maxSlots = 8;
        break;
      case ClassName.State:
        key = "sc_company_slot";
        maxSlots = 9;
        break;
      case ClassName.Worker:
        key = "wc_company_slot";
        maxSlots = 2;
        break;
    }
    for (int slot = 0; slot < maxSlots; slot++) {
      if (getItem(key + slot.toString() + "_id") > 0) {
        usedSlots++;
      }
    }
    return usedSlots;
  }

  List<CompanyInfo> getCompanyCardList(ClassName cls) {
    List<CompanyInfo> companyInfoList = [];
    for (CompanyInfo info in companyCards) {
      if (info.cls == cls) {
        companyInfoList.add(info);
      }
    }
    return companyInfoList;
  }

  CompanyInfo? getCompanyInfo(int id) {
    for (CompanyInfo info in companyCards) {
      if (info.id == id) {
        return info;
      }
    }
    return null;
  }
}

class CompanyInfo {
  const CompanyInfo(
      this.id,
      this.cls,
      this.name,
      this.color,
      this.price,
      this.production,
      this.productionExtra,
      this.productionIcon,
      this.iconColor,
      this.priceHigh,
      this.priceMid,
      this.priceLow,
      this.skilledWorkers,
      this.unskilledWorkers,
      this.mcSkilledWorkers,
      this.mcUnskilledWorkers);
  final int id;
  final ClassName cls;
  final String name;
  final Color color;
  final int price;
  final int production;
  final int productionExtra;
  final IconData productionIcon;
  final Color iconColor;
  final int priceHigh;
  final int priceMid;
  final int priceLow;
  final int skilledWorkers;
  final int unskilledWorkers;
  final int mcSkilledWorkers;
  final int mcUnskilledWorkers;
}

const List<CompanyInfo> companyCards = <CompanyInfo>[
  // Capitalist class companies
  CompanyInfo(1, ClassName.Capitalist, "CLINIC", Colors.red, 16, 6, 2,
      Icons.heart_broken, Colors.white, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(2, ClassName.Capitalist, "COLLEGE", Colors.orange, 16, 6, 2,
      Icons.school, Colors.orange, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(3, ClassName.Capitalist, "SHOPPING MALL", Colors.blue, 16, 6, 2,
      Icons.smartphone, Colors.blue, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(4, ClassName.Capitalist, "SUPERMARKET", Colors.green, 16, 4, 1,
      Icons.agriculture, Colors.green, 25, 20, 15, 1, 1, 0, 0),
  // Middle class companies
  CompanyInfo(100, ClassName.Middle, "DOCTOR'S OFFICE", Colors.red, 12, 2, 2,
      Icons.heart_broken, Colors.white, 10, 8, 6, 0, 1, 1, 0),
  CompanyInfo(101, ClassName.Middle, "CONVENIENCE STORE", Colors.green, 14, 2,
      1, Icons.agriculture, Colors.green, 10, 8, 6, 0, 1, 1, 0),
  // State class companies
  CompanyInfo(200, ClassName.State, "UNIVERSITY HOSPITAL", Colors.red, 30, 6, 0,
      Icons.heart_broken, Colors.white, 35, 30, 25, 1, 2, 0, 0),
  CompanyInfo(201, ClassName.State, "TECHNICAL UNIVERSITY", Colors.orange, 30,
      6, 0, Icons.school, Colors.orange, 35, 30, 25, 1, 2, 0, 0),
  CompanyInfo(
      202,
      ClassName.State,
      "NATIONAL PUBLIC BROADCASTING",
      Colors.purple,
      30,
      4,
      0,
      Icons.chat_bubble,
      Colors.purple,
      35,
      30,
      25,
      1,
      2,
      0,
      0),
  CompanyInfo(203, ClassName.State, "PUBLIC HOSPITAL", Colors.red, 20, 4, 0,
      Icons.heart_broken, Colors.white, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(204, ClassName.State, "PUBLIC UNIVERSITY", Colors.orange, 20, 4,
      0, Icons.school, Colors.orange, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(205, ClassName.State, "REGIONAL TV STATION", Colors.purple, 20, 3,
      0, Icons.chat_bubble, Colors.purple, 25, 20, 15, 1, 1, 0, 0),
  // Worker class companies
  CompanyInfo(300, ClassName.Worker, "COOPERATIVE FARM", Colors.green, 0, 2, 0,
      Icons.agriculture, Colors.green, 0, 0, 0, 0, 3, 0, 0),
];
