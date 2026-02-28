// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'action_log.dart';

enum ClassName { None, Worker, Capitalist, Middle, State }

enum Phase { Preparation, Action, Production, Election, Scoring }

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
  McMedia,
  AnyUnskilled,
  AnyFood,
  AnyLuxury,
  AnyHealth,
  AnyEducation,
  AnyMedia,
}

enum CompanyType { Food, Luxury, Health, Education, Media, Any }

enum ClassMode { Human, Automa }

class PlayerClass {
  ClassMode mode = ClassMode.Human;
  int vp = 0;
  int billMarkers = 3;
  int money = 0;
}

class WorkerClass extends PlayerClass {
}

class CapitalistClass extends PlayerClass {
}

class MiddleClass extends PlayerClass {
}

class StateClass extends PlayerClass {
}

class BoardState extends ChangeNotifier {
  bool gameSetup = true;
  Phase phase = Phase.Preparation;
  int numPlayers = 2;
  int saveSlot = 0;
  Map<String, int> boardData = {};
  List<Map<String, int>> undoBoardData = [];
  ClassName activePlayer = ClassName.Worker;
  ActionLog actionLog = ActionLog();
  List<PlayerClass> players = [WorkerClass(), CapitalistClass(), MiddleClass(), StateClass()];

  BoardState() {
    _resetBoardState();
  }

  Future<void> init() async {
    await setSaveSlot(0);
  }

  void start() {
    gameSetup = false;
    _resetBoardState();
    notifyListeners();
  }

  void setNumPlayers(int n) {
    numPlayers = n < 2
        ? 2
        : n > 3
            ? 3
            : n;
    notifyListeners();
  }

  void setClassMode(ClassMode mode) {
  }

  Future<void> setSaveSlot(int slot) async {
    // Set save slot and load state
    saveSlot = slot;
    //await load(slot: slot);
    //notifyListeners();
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
    boardData["policy_fp_bill"] = 0;
    boardData["policy_lm_bill"] = 0;
    boardData["policy_tx_bill"] = 0;
    boardData["policy_hb_bill"] = 0;
    boardData["policy_ed_bill"] = 0;
    boardData["policy_ft_bill"] = 0;
    boardData["policy_im_bill"] = 0;
    boardData["round"] = 1;
    // Worker Class variables
    boardData["wc_vp"] = 0;
    boardData["wc_bill_markers"] = 3;
    boardData["wc_income"] = 30;
    boardData["wc_prosperity"] = 0;
    boardData["wc_food"] = 0;
    boardData["wc_luxury"] = 0;
    boardData["wc_health"] = 0;
    boardData["wc_education"] = 0;
    boardData["wc_influence"] = 1;
    boardData["wc_workers_unskilled"] = 2;
    boardData["wc_unions"] = 0;
    // Capital Class variables
    boardData["cc_vp"] = 0;
    boardData["cc_bill_markers"] = 3;
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
    boardData["mc_bill_markers"] = 3;
    boardData["mc_income"] = 40;
    boardData["mc_prosperity"] = 0;
    boardData["mc_storage_food"] = 1;
    boardData["mc_storage_luxury"] = 0;
    boardData["mc_storage_health"] = 1;
    boardData["mc_storage_education"] = 0;
    boardData["mc_influence"] = 1;
    if (numPlayers >= 3) {
      addCompanyToSlot("mc_company_slot0", 100,
          filled: true, cls: ClassName.Middle, slotLimit: 1); // DOCTOR'S OFFICE
      addCompanyToSlot("mc_company_slot1", 101,
          filled: true,
          cls: ClassName.Middle,
          slotLimit: 1); // CONVENIENCE STORE
      boardData["mc_workers_unskilled"] = 1;
    }
    // State variables
    boardData["sc_vp"] = 0;
    boardData["sc_bill_markers"] = 3;
    boardData["sc_treasury"] = 120;
    boardData["sc_storage_health"] = numPlayers > 2 ? 6 : 5;
    boardData["sc_storage_education"] = numPlayers > 2 ? 6 : 5;
    boardData["sc_storage_media"] = numPlayers > 2 ? 4 : 3;
    boardData["sc_influence"] = 1;
    if (numPlayers >= 3) {
      addCompanyToSlot("sc_company_slot0", 200,
          filled: true, cls: ClassName.Worker); // UNIVERSITY HOSPITAL
      addCompanyToSlot("sc_company_slot1", 201,
          filled: true, cls: ClassName.Middle); // TECHNICAL UNIVERSITY
      addCompanyToSlot("sc_company_slot2", 202); // NATIONAL PUBLIC BROADCASTING
    } else {
      addCompanyToSlot("sc_company_slot0", 203,
          filled: true, cls: ClassName.Worker); // PUBLIC HOSPITAL
      addCompanyToSlot("sc_company_slot1", 204,
          filled: true, cls: ClassName.Middle); // PUBLIC UNIVERSITY
      addCompanyToSlot("sc_company_slot2", 205); // REGIONAL TV STATION
    }
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

  void setPolicy(String policyKey, int value) {
    boardData[policyKey] = value;
    // Handle Fiscal Policy change
    if (policyKey.contains("policy_fp")) {
      int companyCount = countCompanies("sc_company_slot");
      int companyMaxCount = value == 0
          ? 9
          : value == 1
              ? 6
              : 3;
      if (companyCount < companyMaxCount) {
        // Buy new companies
        for (int i = 0; i < (companyMaxCount - companyCount) ~/ 3; i++) {
          addCompanyToFreeSlot("sc_company_slot", 203,
              pay: true); // PUBLIC HOSPITAL
          addCompanyToFreeSlot("sc_company_slot", 204,
              pay: true); // PUBLIC UNIVERSITY
          addCompanyToFreeSlot("sc_company_slot", 205,
              pay: true); // REGIONAL TV STATION
        }
        // TODO: Check if State need to take loan(s)
      } else if (companyCount > companyMaxCount) {
        // Sell companies
        while (companyCount > companyMaxCount) {
          sellCompany("sc_company_slot", companyCount - 1);
          companyCount--;
        }
      }
    }
  }

  int countCompanies(String keyBase) {
    int count = 0;
    for (int slot = 0; slot < 16; slot++) {
      if (getItem(keyBase + slot.toString() + "_id") != 0) {
        count++;
      }
    }
    return count;
  }

  void addCompanyToSlot(String keyBase, int id,
      {bool filled = false,
      ClassName cls = ClassName.Worker,
      int slotLimit = 3}) {
    boardData[keyBase + "_id"] = id;
    if (filled) {
      CompanyInfo? info = companyInfo(id);
      for (int slot = 0; slot < info!.workerSlots.length; slot++)
        if (slot < slotLimit) {
          boardData[keyBase + "_worker" + slot.toString()] =
              _companyInfoToWorkerType(cls, info, slot);
        }
    } else {
      boardData[keyBase + "_worker0"] = 0;
      boardData[keyBase + "_worker1"] = 0;
      boardData[keyBase + "_worker2"] = 0;
    }
    boardData[keyBase + "_price"] = getItem("policy_lm");
    boardData[keyBase + "_commited"] = 0;
    boardData[keyBase + "_extra_production"] = 0;
  }

  void addCompanyToFreeSlot(String keyBase, int id, {bool pay = false}) {
    for (int slot = 0; slot < 16; slot++) {
      if (getItem(keyBase + slot.toString() + "_id") == 0) {
        addCompanyToSlot(keyBase + slot.toString(), id);
        print("New company $id added in slot $slot");
        if (pay) {
          CompanyInfo? info = companyInfo(id);
          // Remove money from owner
          if (info!.cls == ClassName.Capitalist) {
            incDecItem("cc_revenue", -info.price);
          } else if (info.cls == ClassName.Middle) {
            incDecItem("mc_income", -info.price);
          } else if (info.cls == ClassName.State) {
            incDecItem("sc_treasury", -info.price);
          }
          print("${info.cls} payed ${info.price}");
        }
        break;
      }
    }
    notifyListeners();
  }

  void sellCompany(String keyBase, int slot) {
    String keySlot = keyBase + slot.toString();
    int id = getItem(keySlot + "_id");
    print("Sell company id $id");
    CompanyInfo? info = companyInfo(id);
    int usedSlots = usedCompanySlots(info!.cls);
    // Add money to owner
    if (info.cls == ClassName.Capitalist) {
      incDecItem("cc_revenue", info.price);
    } else if (info.cls == ClassName.Middle) {
      incDecItem("mc_income", info.price);
    } else if (info.cls == ClassName.State) {
      incDecItem("sc_treasury", info.price);
    }
    // Move all workers to unemployed worker pool
    for (int i = 0; i < 3; i++) {
      String workerSlotKey = keySlot + "_worker" + i.toString();
      int workerType = getItem(workerSlotKey);
      print("Workertype: $workerType");
      if (workerType > 0) {
        incDecItem(_workerTypeToWorkerKey(workerType), 1);
        setItem(workerSlotKey, 0);
      }
    }
    setItem(keySlot + "_id", 0);
    // Fill empty slot
    for (int i = slot; i < usedSlots - 1; i++) {
      String thisSlot = keyBase + i.toString();
      String nextSlot = keyBase + (i + 1).toString();
      print(nextSlot + " -> " + thisSlot);
      setItem(thisSlot + "_id", getItem(nextSlot + "_id"));
      setItem(thisSlot + "_worker0", getItem(nextSlot + "_worker0"));
      setItem(thisSlot + "_worker1", getItem(nextSlot + "_worker1"));
      setItem(thisSlot + "_worker2", getItem(nextSlot + "_worker2"));
      setItem(thisSlot + "_price", getItem(nextSlot + "_price"));
      setItem(thisSlot + "_commited", getItem(nextSlot + "_commited"));
      setItem(thisSlot + "_extra_production",
          getItem(nextSlot + "_extra_production"));
      setItem(nextSlot + "_id", 0);
    }
  }

  void cycleWorkers(String companyKeyBase, int workerSlot, int id) {
    String companySlotKey = companyKeyBase + workerSlot.toString();
    print("Cycle worker: $companyKeyBase, slot: $workerSlot, company: $id");
    print("worker type: ${getItem(companySlotKey)}");
    int workerType = getItem(companySlotKey);
    CompanyInfo info = companyInfo(id)!;
    int newWorkerType = workerType + 1;
    while (workerType != newWorkerType) {
      if (newWorkerType >= WorkerType.AnyUnskilled.index) {
        newWorkerType = WorkerType.None.index;
        break;
      }
      WorkerType workerTypeSlot = info.workerSlots[workerSlot];
      bool skilledSlot = (workerTypeSlot != WorkerType.WcUnskilled &&
          workerTypeSlot != WorkerType.McUnskilled &&
          workerTypeSlot != WorkerType.AnyUnskilled);
      if (skilledSlot) {
        if (workerTypeSlot.index == newWorkerType) {
          break;
        }
        if (workerTypeSlot.index >= WorkerType.AnyUnskilled.index) {
          if (((workerTypeSlot.index -
                      WorkerType.AnyUnskilled.index +
                      WorkerType.WcUnskilled.index) ==
                  newWorkerType) ||
              ((workerTypeSlot.index -
                      WorkerType.AnyUnskilled.index +
                      WorkerType.McUnskilled.index) ==
                  newWorkerType)) {
            break;
          }
        }
      } else {
        if (workerTypeSlot == WorkerType.WcUnskilled) {
          if (newWorkerType >= WorkerType.WcUnskilled.index &&
              newWorkerType <= WorkerType.WcMedia.index) {
            break;
          }
        } else if (workerTypeSlot == WorkerType.McUnskilled) {
          if (newWorkerType >= WorkerType.McUnskilled.index &&
              newWorkerType <= WorkerType.McMedia.index) {
            break;
          }
        } else if (workerTypeSlot == WorkerType.AnyUnskilled) {
          if ((newWorkerType >= WorkerType.WcUnskilled.index &&
                  newWorkerType <= WorkerType.WcMedia.index) ||
              (newWorkerType >= WorkerType.McUnskilled.index &&
                  newWorkerType <= WorkerType.McMedia.index)) {
            break;
          }
        }
      }
      newWorkerType += 1;
    }
    setItem(companySlotKey, newWorkerType);
    print("New worker type: $newWorkerType");
  }

  void toggleExtraProduction(String companyKeyBase, int id) {
    String companyExtraProductionKey = companyKeyBase + "_extra_production";
    CompanyInfo info = companyInfo(id)!;
    print("Toggle extra production: $companyExtraProductionKey, company: $id");
    if (info.cls == ClassName.Capitalist) {
      int state = getItem(companyExtraProductionKey);
      setItem(companyExtraProductionKey, state == 0 ? 1 : 0);
    }
  }

  String _workerTypeToWorkerKey(int workerType) {
    switch (workerType) {
      case 1: //WorkerType.WcUnskilled
        return "wc_workers_unskilled";
      case 2: //WorkerType.WcFood
        return "wc_workers_skilled_agriculture";
      case 3: //WorkerType.WcLuxury
        return "wc_workers_skilled_luxury";
      case 4: //WorkerType.WcHealth
        return "wc_workers_skilled_health";
      case 5: //WorkerType.WcEducation
        return "wc_workers_skilled_education";
      case 6: //WorkerType.WcMedia
        return "wc_workers_skilled_media";
      case 7: //WorkerType.McUnskilled
        return "mc_workers_unskilled";
      case 8: //WorkerType.McFood
        return "mc_workers_skilled_agriculture";
      case 9: //WorkerType.McLuxury
        return "mc_workers_skilled_luxury";
      case 10: //WorkerType.McHealth
        return "mc_workers_skilled_health";
      case 11: //WorkerType.McEducation
        return "mc_workers_skilled_education";
      case 12: //WorkerType.McMedia
        return "mc_workers_skilled_media";
      default:
        break;
    }
    return "";
  }

  int taxMultiplier() {
    int taxPolicy = getItem("policy_tx");
    int taxBase = 1;
    int wellfareMulti = 0;
    if (taxPolicy == 0) {
      taxBase = 3;
      wellfareMulti = 2;
    } else if (taxPolicy == 1) {
      taxBase = 2;
      wellfareMulti = 1;
    }
    int hbPolicy = getItem("policy_hb");
    int edPolicy = getItem("policy_ed");
    taxBase += (hbPolicy == 0)
        ? 2 * wellfareMulti
        : (hbPolicy == 1)
            ? 1 * wellfareMulti
            : 0;
    taxBase += (edPolicy == 0)
        ? 2 * wellfareMulti
        : (edPolicy == 1)
            ? 1 * wellfareMulti
            : 0;
    return taxBase;
  }

  int workersInCompaniesCount(
      String companyKeyBase, ClassName companyClass, ClassName workerClass,
      {CompanyType typeFilter = CompanyType.Any}) {
    int numWorkers = 0;
    // Check capitalist company slots
    for (int i = 0; i < usedCompanySlots(companyClass); i++) {
      CompanyInfo info =
          companyInfo(getItem(companyKeyBase + i.toString() + "_id"))!;
      if (typeFilter == CompanyType.Any || typeFilter == info.type) {
        for (int workerSlot = 0;
            workerSlot < info.workerSlots.length;
            workerSlot++) {
          int workerType = getItem(companyKeyBase +
              i.toString() +
              "_worker" +
              workerSlot.toString());
          if ((workerType >= WorkerType.WcUnskilled.index &&
                  workerType <= WorkerType.WcMedia.index &&
                  workerClass == ClassName.Worker) ||
              (workerType >= WorkerType.McUnskilled.index &&
                  workerType <= WorkerType.McMedia.index &&
                  workerClass == ClassName.Middle)) {
            numWorkers++;
          }
        }
      }
    }
    return numWorkers;
  }

  int workerCount(ClassName cls) {
    int numWorkers = 0;
    // Check capitalist company slots
    numWorkers +=
        workersInCompaniesCount("cc_company_slot", ClassName.Capitalist, cls);
    numWorkers +=
        workersInCompaniesCount("mc_company_slot", ClassName.Middle, cls);
    numWorkers +=
        workersInCompaniesCount("sc_company_slot", ClassName.State, cls);
    numWorkers +=
        workersInCompaniesCount("wc_company_slot", ClassName.Worker, cls);
    if (cls == ClassName.Worker) {
      // Get unemployed workers
      for (int i = WorkerType.WcUnskilled.index;
          i <= WorkerType.WcMedia.index;
          i++) {
        numWorkers += getItem(_workerTypeToWorkerKey(i));
      }
      // Get union workers
      for (CompanyType type in CompanyType.values) {
        if (unionState(type)) {
          numWorkers++;
        }
      }
    } else if (cls == ClassName.Middle) {
      // Get unemployed workers
      for (int i = WorkerType.McUnskilled.index;
          i <= WorkerType.McMedia.index;
          i++) {
        numWorkers += getItem(_workerTypeToWorkerKey(i));
      }
    }
    return numWorkers;
  }

  int population(ClassName cls) {
    return (workerCount(cls) / 3).floor();
  }

  bool unionState(CompanyType type) {
    int unions = getItem("wc_unions");
    int bit = 1 << type.index;
    return (unions & bit == bit);
  }

  void toggleUnion(CompanyType type) {
    int bit = 1 << type.index;
    int unions = getItem("wc_unions");
    if (unions & bit == bit) {
      unions &= ~bit;
    } else {
      int numWorkers = workersInCompaniesCount(
          "cc_company_slot", ClassName.Capitalist, ClassName.Worker,
          typeFilter: type);
      numWorkers += workersInCompaniesCount(
          "mc_company_slot", ClassName.Middle, ClassName.Worker,
          typeFilter: type);
      numWorkers += workersInCompaniesCount(
          "sc_company_slot", ClassName.State, ClassName.Worker,
          typeFilter: type);
      numWorkers += workersInCompaniesCount(
          "wc_company_slot", ClassName.Worker, ClassName.Worker,
          typeFilter: type);
      if (numWorkers >= 4) {
        unions |= bit;
      }
    }
    setItem("wc_unions", unions);
    print("Unions updated: $unions");
  }

  void togglePolicyBill(String policyKey, int slot) {
    // policy_x_bill bit mapping:
    // bits 3..0: A, bits 7..4: B, bits 11..8: C
    int policyBill = getItem(policyKey + "_bill");
    int policyBillClass = (policyBill >> (slot * 4)) & 0xf;
    int newPolicyBillClass = policyBillClass + 1;
    // Remove old bill marker
    if (policyBillClass == ClassName.Worker.index) {
      incDecItem("wc_bill_markers", 1);
    } else if (policyBillClass == ClassName.Middle.index) {
      incDecItem("mc_bill_markers", 1);
    } else if (policyBillClass == ClassName.Capitalist.index) {
      incDecItem("cc_bill_markers", 1);
    } else if (policyBillClass == ClassName.State.index) {
      incDecItem("sc_bill_markers", 1);
    }
    while (true) {
      if (newPolicyBillClass == ClassName.Worker.index) {
        int billMarkers = getItem("wc_bill_markers");
        if (billMarkers > 0) {
          incDecItem("wc_bill_markers", -1);
          break;
        }
      } else if (newPolicyBillClass == ClassName.Middle.index) {
        int billMarkers = getItem("mc_bill_markers");
        if (billMarkers > 0) {
          incDecItem("mc_bill_markers", -1);
          break;
        }
      } else if (newPolicyBillClass == ClassName.Capitalist.index) {
        int billMarkers = getItem("cc_bill_markers");
        if (billMarkers > 0) {
          incDecItem("cc_bill_markers", -1);
          break;
        }
      } else if (newPolicyBillClass == ClassName.State.index) {
        int billMarkers = getItem("sc_bill_markers");
        if (billMarkers > 0) {
          incDecItem("sc_bill_markers", -1);
          break;
        }
      } else if (newPolicyBillClass > ClassName.State.index) {
        newPolicyBillClass = ClassName.None.index;
        break;
      }
      newPolicyBillClass += 1;
    }
    if (policyBillClass != newPolicyBillClass) {
      policyBill &= ~(0xf << (slot * 4));
      policyBill |= newPolicyBillClass << (slot * 4);
      setItem(policyKey + "_bill", policyBill);
    }

    print("Policy bill $policyKey, $slot, policyBill: $policyBill");
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

  int usedCompanySlots(ClassName cls) {
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
      default:
        break;
    }
    for (int slot = 0; slot < maxSlots; slot++) {
      if (getItem(key + slot.toString() + "_id") > 0) {
        usedSlots++;
      }
    }
    return usedSlots;
  }

  ClassName workerClass(int workerType) {
    ClassName cls = ClassName.None;
    if (workerType > WorkerType.None.index &&
        workerType < WorkerType.McUnskilled.index) {
      cls = ClassName.Worker;
    } else if (workerType >= WorkerType.McUnskilled.index) {
      cls = ClassName.Middle;
    }
    return cls;
  }

  int _companyInfoToWorkerType(ClassName cls, CompanyInfo info, int slotIndex) {
    int workerTypeIndex = 0;
    if (info.workerSlots[slotIndex] == WorkerType.AnyUnskilled) {
      workerTypeIndex = (cls == ClassName.Worker)
          ? WorkerType.WcUnskilled.index
          : WorkerType.McUnskilled.index;
    } else if (info.workerSlots[slotIndex] == WorkerType.AnyFood) {
      workerTypeIndex = (cls == ClassName.Worker)
          ? WorkerType.WcFood.index
          : WorkerType.McFood.index;
    } else if (info.workerSlots[slotIndex] == WorkerType.AnyLuxury) {
      workerTypeIndex = (cls == ClassName.Worker)
          ? WorkerType.WcLuxury.index
          : WorkerType.McLuxury.index;
    } else if (info.workerSlots[slotIndex] == WorkerType.AnyHealth) {
      workerTypeIndex = (cls == ClassName.Worker)
          ? WorkerType.WcHealth.index
          : WorkerType.McHealth.index;
    } else if (info.workerSlots[slotIndex] == WorkerType.AnyEducation) {
      workerTypeIndex = (cls == ClassName.Worker)
          ? WorkerType.WcEducation.index
          : WorkerType.McEducation.index;
    } else if (info.workerSlots[slotIndex] == WorkerType.AnyMedia) {
      workerTypeIndex = (cls == ClassName.Worker)
          ? WorkerType.WcMedia.index
          : WorkerType.McMedia.index;
    } else {
      workerTypeIndex = info.workerSlots[slotIndex].index;
    }
    return workerTypeIndex;
  }

  List<CompanyInfo> companyCardList(ClassName cls) {
    List<CompanyInfo> companyInfoList = [];
    for (CompanyInfo info in companyCards) {
      if (info.cls == cls) {
        companyInfoList.add(info);
      }
    }
    return companyInfoList;
  }

  CompanyInfo? companyInfo(int id) {
    for (CompanyInfo info in companyCards) {
      if (info.id == id) {
        return info;
      }
    }
    print("getCompanyInfo: Could not find $id");
    return null;
  }

  List<ExportCard> exportCardList() {
    return exportCards;
  }

  List<BusinessDeal> businessDealList() {
    return businessDeals;
  }
}

class CompanyInfo {
  const CompanyInfo(
    this.id,
    this.cls,
    this.name,
    this.type,
    this.color,
    this.price,
    this.production,
    this.productionExtra,
    this.productionIcon,
    this.priceHigh,
    this.priceMid,
    this.priceLow,
    this.workerSlots,
  );
  final int id;
  final ClassName cls;
  final String name;
  final CompanyType type;
  final Color color;
  final int price;
  final int production;
  final int productionExtra;
  final IconData productionIcon;
  final int priceHigh;
  final int priceMid;
  final int priceLow;
  final List<WorkerType> workerSlots;
}

const List<CompanyInfo> companyCards = <CompanyInfo>[
  // Capitalist class companies
  CompanyInfo(
      1,
      ClassName.Capitalist,
      "CLINIC",
      CompanyType.Health,
      Colors.red,
      16,
      6,
      2,
      Icons.heart_broken,
      25,
      20,
      15,
      [WorkerType.AnyHealth, WorkerType.AnyUnskilled]),
  CompanyInfo(
      2,
      ClassName.Capitalist,
      "COLLEGE",
      CompanyType.Education,
      Colors.orange,
      16,
      6,
      2,
      Icons.school,
      25,
      20,
      15,
      [WorkerType.AnyEducation, WorkerType.AnyUnskilled]),
  CompanyInfo(
      3,
      ClassName.Capitalist,
      "SHOPPING MALL",
      CompanyType.Luxury,
      Colors.blue,
      16,
      6,
      2,
      Icons.smartphone,
      25,
      20,
      15,
      [WorkerType.AnyLuxury, WorkerType.AnyUnskilled]),
  CompanyInfo(
      4,
      ClassName.Capitalist,
      "SUPERMARKET",
      CompanyType.Food,
      Colors.green,
      16,
      4,
      1,
      Icons.agriculture,
      25,
      20,
      15,
      [WorkerType.AnyFood, WorkerType.AnyUnskilled]),
  CompanyInfo(
      5,
      ClassName.Capitalist,
      "HOSPITAL",
      CompanyType.Health,
      Colors.red,
      20,
      7,
      0,
      Icons.heart_broken,
      30,
      20,
      10,
      [WorkerType.AnyHealth, WorkerType.AnyUnskilled]),
  CompanyInfo(
      6,
      ClassName.Capitalist,
      "TV STATION",
      CompanyType.Media,
      Colors.purple,
      24,
      4,
      0,
      Icons.chat_bubble,
      40,
      30,
      20,
      [WorkerType.AnyMedia, WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(7, ClassName.Capitalist, "AUTOMATED\nGRAIN FARM",
      CompanyType.Food, Colors.green, 25, 2, 0, Icons.agriculture, 0, 0, 0, []),
  CompanyInfo(8, ClassName.Capitalist, "HOTEL", CompanyType.Luxury, Colors.blue,
      15, 7, 0, Icons.smartphone, 30, 25, 20, [
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled
  ]),
  CompanyInfo(
      9,
      ClassName.Capitalist,
      "RADIO STATION",
      CompanyType.Media,
      Colors.purple,
      8,
      2,
      0,
      Icons.chat_bubble,
      20,
      15,
      10,
      [WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(
      10,
      ClassName.Capitalist,
      "LOBBYING FIRM",
      CompanyType.Media,
      Colors.purple,
      16,
      3,
      0,
      Icons.chat_bubble,
      30,
      20,
      10,
      [WorkerType.AnyMedia, WorkerType.AnyUnskilled]),
  CompanyInfo(
      11,
      ClassName.Capitalist,
      "INSITUTE OF\nTECHNOLOGY",
      CompanyType.Education,
      Colors.orange,
      20,
      8,
      3,
      Icons.school,
      40,
      30,
      20, [
    WorkerType.AnyEducation,
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled
  ]),
  CompanyInfo(
      12,
      ClassName.Capitalist,
      "FISH FARM",
      CompanyType.Food,
      Colors.green,
      20,
      6,
      1,
      Icons.agriculture,
      35,
      30,
      25,
      [WorkerType.AnyFood, WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(
      13,
      ClassName.Capitalist,
      "PHARMACEUTICAL\nCOMPANY",
      CompanyType.Health,
      Colors.red,
      20,
      8,
      3,
      Icons.heart_broken,
      40,
      30,
      20,
      [WorkerType.AnyHealth, WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(14, ClassName.Capitalist, "UNIVERSITY", CompanyType.Education,
      Colors.orange, 24, 9, 2, Icons.school, 40, 30, 20, [
    WorkerType.AnyEducation,
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled
  ]),
  CompanyInfo(
      15,
      ClassName.Capitalist,
      "ACADEMY",
      CompanyType.Education,
      Colors.orange,
      20,
      7,
      0,
      Icons.school,
      30,
      20,
      10,
      [WorkerType.AnyEducation, WorkerType.AnyUnskilled]),
  CompanyInfo(
      16,
      ClassName.Capitalist,
      "STADIUM",
      CompanyType.Luxury,
      Colors.blue,
      20,
      8,
      3,
      Icons.smartphone,
      35,
      30,
      25,
      [WorkerType.AnyLuxury, WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(17, ClassName.Capitalist, "ELECTRONICS\nMANUFACTURER",
      CompanyType.Luxury, Colors.blue, 25, 3, 0, Icons.smartphone, 0, 0, 0, []),
  CompanyInfo(
      18,
      ClassName.Capitalist,
      "FASHION COMPANY",
      CompanyType.Luxury,
      Colors.blue,
      8,
      4,
      2,
      Icons.smartphone,
      20,
      15,
      10,
      [WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(19, ClassName.Capitalist, "PUBLISHING HOUSE", CompanyType.Media,
      Colors.purple, 12, 3, 0, Icons.chat_bubble, 30, 25, 20, [
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled
  ]),
  CompanyInfo(20, ClassName.Capitalist, "AUTOMATED\nDAIRY FARM",
      CompanyType.Food, Colors.green, 45, 3, 0, Icons.agriculture, 0, 0, 0, []),
  CompanyInfo(21, ClassName.Capitalist, "CAR MANUFACTURER", CompanyType.Luxury,
      Colors.blue, 45, 5, 0, Icons.smartphone, 0, 0, 0, []),
  CompanyInfo(22, ClassName.Capitalist, "VEGETABLE FARM", CompanyType.Food,
      Colors.green, 15, 5, 0, Icons.agriculture, 30, 25, 20, [
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled
  ]),
  CompanyInfo(
      23,
      ClassName.Capitalist,
      "FAST FOOD CHAIN",
      CompanyType.Food,
      Colors.green,
      8,
      3,
      0,
      Icons.agriculture,
      20,
      15,
      10,
      [WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(
      24,
      ClassName.Capitalist,
      "MEDICAL\nVILLAGE",
      CompanyType.Health,
      Colors.red,
      24,
      9,
      2,
      Icons.heart_broken,
      40,
      30,
      20,
      [WorkerType.AnyHealth, WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  // Middle class companies
  CompanyInfo(
      100,
      ClassName.Middle,
      "DOCTOR'S OFFICE",
      CompanyType.Health,
      Colors.red,
      12,
      2,
      2,
      Icons.heart_broken,
      10,
      8,
      6,
      [WorkerType.McHealth, WorkerType.WcUnskilled]),
  CompanyInfo(
      101,
      ClassName.Middle,
      "CONVENIENCE\nSTORE",
      CompanyType.Food,
      Colors.green,
      14,
      2,
      1,
      Icons.agriculture,
      10,
      8,
      6,
      [WorkerType.McFood, WorkerType.WcUnskilled]),
  CompanyInfo(
      102,
      ClassName.Middle,
      "FAST FOOD\nRESTAURANT",
      CompanyType.Food,
      Colors.green,
      20,
      3,
      0,
      Icons.agriculture,
      0,
      0,
      0,
      [WorkerType.McFood, WorkerType.McUnskilled]),
  CompanyInfo(
      103,
      ClassName.Middle,
      "PHARMACY",
      CompanyType.Health,
      Colors.red,
      16,
      4,
      0,
      Icons.heart_broken,
      0,
      0,
      0,
      [WorkerType.McHealth, WorkerType.McUnskilled]),
  CompanyInfo(
      104,
      ClassName.Middle,
      "JEWELRY STORE",
      CompanyType.Luxury,
      Colors.blue,
      16,
      4,
      0,
      Icons.smartphone,
      0,
      0,
      0,
      [WorkerType.McLuxury, WorkerType.McUnskilled]),
  CompanyInfo(
      105,
      ClassName.Middle,
      "PR AGENCY",
      CompanyType.Media,
      Colors.purple,
      20,
      3,
      0,
      Icons.chat_bubble,
      0,
      0,
      0,
      [WorkerType.McMedia, WorkerType.McUnskilled]),
  CompanyInfo(
      106,
      ClassName.Middle,
      "TUTORING\nCOMPANY",
      CompanyType.Education,
      Colors.orange,
      12,
      2,
      2,
      Icons.school,
      10,
      8,
      6,
      [WorkerType.McEducation, WorkerType.WcUnskilled]),
  CompanyInfo(
      107,
      ClassName.Middle,
      "TUTORING CENTER",
      CompanyType.Education,
      Colors.orange,
      16,
      4,
      0,
      Icons.school,
      0,
      0,
      0,
      [WorkerType.McEducation, WorkerType.McUnskilled]),
  CompanyInfo(
      108,
      ClassName.Middle,
      "PRIVATE SCHOOL",
      CompanyType.Education,
      Colors.orange,
      20,
      2,
      4,
      Icons.school,
      15,
      12,
      9,
      [WorkerType.McEducation, WorkerType.WcEducation]),
  CompanyInfo(
      109,
      ClassName.Middle,
      "REGIONAL RADIO\nSTATION",
      CompanyType.Media,
      Colors.purple,
      20,
      2,
      2,
      Icons.chat_bubble,
      15,
      12,
      9,
      [WorkerType.McMedia, WorkerType.WcMedia]),
  CompanyInfo(
      110,
      ClassName.Middle,
      "ORGANIC FARM",
      CompanyType.Food,
      Colors.green,
      20,
      2,
      2,
      Icons.agriculture,
      15,
      12,
      9,
      [WorkerType.McFood, WorkerType.McFood]),
  CompanyInfo(
      111,
      ClassName.Middle,
      "MEDICAL LABORATORY",
      CompanyType.Health,
      Colors.red,
      20,
      2,
      4,
      Icons.heart_broken,
      15,
      12,
      9,
      [WorkerType.McHealth, WorkerType.WcHealth]),
  CompanyInfo(
      112,
      ClassName.Middle,
      "GAME STORE",
      CompanyType.Luxury,
      Colors.blue,
      12,
      2,
      2,
      Icons.smartphone,
      10,
      8,
      6,
      [WorkerType.McLuxury, WorkerType.WcUnskilled]),
  CompanyInfo(
      113,
      ClassName.Middle,
      "LOCAL NEWSPAPER",
      CompanyType.Media,
      Colors.purple,
      14,
      2,
      1,
      Icons.chat_bubble,
      10,
      8,
      6,
      [WorkerType.McMedia, WorkerType.WcUnskilled]),
  CompanyInfo(
      114,
      ClassName.Middle,
      "ELECTRONICS STORE",
      CompanyType.Luxury,
      Colors.blue,
      20,
      2,
      4,
      Icons.smartphone,
      15,
      12,
      9,
      [WorkerType.McLuxury, WorkerType.WcLuxury]),
  // State class companies
  CompanyInfo(
      200,
      ClassName.State,
      "UNIVERSITY\nHOSPITAL",
      CompanyType.Health,
      Colors.red,
      30,
      6,
      0,
      Icons.heart_broken,
      35,
      30,
      25,
      [WorkerType.AnyHealth, WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(
      201,
      ClassName.State,
      "TECHNICAL\nUNIVERSITY",
      CompanyType.Education,
      Colors.orange,
      30,
      6,
      0,
      Icons.school,
      35,
      30,
      25, [
    WorkerType.AnyEducation,
    WorkerType.AnyUnskilled,
    WorkerType.AnyUnskilled
  ]),
  CompanyInfo(
      202,
      ClassName.State,
      "NATIONAL PUBL.\nBROADCASTING",
      CompanyType.Media,
      Colors.purple,
      30,
      4,
      0,
      Icons.chat_bubble,
      35,
      30,
      25,
      [WorkerType.AnyMedia, WorkerType.AnyUnskilled, WorkerType.AnyUnskilled]),
  CompanyInfo(
      203,
      ClassName.State,
      "PUBLIC HOSPITAL",
      CompanyType.Health,
      Colors.red,
      20,
      4,
      0,
      Icons.heart_broken,
      25,
      20,
      15,
      [WorkerType.AnyHealth, WorkerType.AnyUnskilled]),
  CompanyInfo(
      204,
      ClassName.State,
      "PUBLIC UNIVERSITY",
      CompanyType.Education,
      Colors.orange,
      20,
      4,
      0,
      Icons.school,
      25,
      20,
      15,
      [WorkerType.AnyEducation, WorkerType.AnyUnskilled]),
  CompanyInfo(
      205,
      ClassName.State,
      "REGIONAL\nTV STATION",
      CompanyType.Media,
      Colors.purple,
      20,
      3,
      0,
      Icons.chat_bubble,
      25,
      20,
      15,
      [WorkerType.AnyMedia, WorkerType.AnyUnskilled]),
  // Worker class companies
  CompanyInfo(
      300,
      ClassName.Worker,
      "COOPERATIVE FARM",
      CompanyType.Food,
      Colors.green,
      0,
      2,
      0,
      Icons.agriculture,
      0,
      0,
      0,
      [WorkerType.WcUnskilled, WorkerType.WcUnskilled, WorkerType.WcUnskilled]),
];

class ExportItem {
  const ExportItem(this.amount, this.sellPrice);
  final int amount;
  final int sellPrice;
}

class ExportCard {
  const ExportCard(this.id, this.foodExportList, this.healthExportList,
      this.luxuryExportList, this.educationExportList);
  final int id;
  final List<ExportItem> foodExportList;
  final List<ExportItem> healthExportList;
  final List<ExportItem> luxuryExportList;
  final List<ExportItem> educationExportList;
}

const List<ExportCard> exportCards = <ExportCard>[
  ExportCard(
      0,
      [ExportItem(4, 45), ExportItem(7, 80)],
      [ExportItem(2, 15), ExportItem(6, 40)],
      [ExportItem(3, 20), ExportItem(5, 30)],
      [ExportItem(3, 20), ExportItem(7, 50)]),
  ExportCard(
      1,
      [ExportItem(2, 15), ExportItem(6, 50)],
      [ExportItem(4, 30), ExportItem(7, 50)],
      [ExportItem(3, 15), ExportItem(7, 35)],
      [ExportItem(3, 20), ExportItem(5, 35)]),
  ExportCard(
      2,
      [ExportItem(3, 30), ExportItem(5, 50)],
      [ExportItem(3, 20), ExportItem(6, 50)],
      [ExportItem(3, 25), ExportItem(7, 55)],
      [ExportItem(3, 20), ExportItem(7, 50)]),
  ExportCard(
      3,
      [ExportItem(2, 15), ExportItem(6, 45)],
      [ExportItem(3, 20), ExportItem(5, 30)],
      [ExportItem(3, 20), ExportItem(7, 50)],
      [ExportItem(4, 25), ExportItem(8, 45)]),
  ExportCard(
      4,
      [ExportItem(3, 25), ExportItem(6, 50)],
      [ExportItem(3, 20), ExportItem(7, 40)],
      [ExportItem(3, 20), ExportItem(7, 50)],
      [ExportItem(2, 15), ExportItem(7, 55)]),
  ExportCard(
      5,
      [ExportItem(2, 20), ExportItem(6, 55)],
      [ExportItem(3, 25), ExportItem(5, 40)],
      [ExportItem(4, 30), ExportItem(8, 55)],
      [ExportItem(3, 15), ExportItem(7, 35)]),
  ExportCard(
      6,
      [ExportItem(4, 50), ExportItem(8, 95)],
      [ExportItem(3, 15), ExportItem(7, 35)],
      [ExportItem(3, 20), ExportItem(5, 30)],
      [ExportItem(2, 15), ExportItem(6, 40)]),
  ExportCard(
      7,
      [ExportItem(3, 25), ExportItem(7, 55)],
      [ExportItem(2, 10), ExportItem(6, 35)],
      [ExportItem(4, 25), ExportItem(8, 45)],
      [ExportItem(3, 20), ExportItem(5, 35)]),
  ExportCard(
      8,
      [ExportItem(3, 30), ExportItem(5, 50)],
      [ExportItem(3, 25), ExportItem(7, 55)],
      [ExportItem(2, 10), ExportItem(6, 35)],
      [ExportItem(4, 25), ExportItem(8, 45)]),
  ExportCard(
      9,
      [ExportItem(2, 25), ExportItem(6, 65)],
      [ExportItem(3, 20), ExportItem(7, 40)],
      [ExportItem(4, 20), ExportItem(7, 35)],
      [ExportItem(3, 25), ExportItem(6, 45)]),
  ExportCard(
      10,
      [ExportItem(2, 15), ExportItem(6, 50)],
      [ExportItem(4, 25), ExportItem(8, 45)],
      [ExportItem(3, 25), ExportItem(5, 40)],
      [ExportItem(3, 15), ExportItem(7, 35)]),
  ExportCard(
      11,
      [ExportItem(4, 40), ExportItem(7, 70)],
      [ExportItem(2, 15), ExportItem(7, 50)],
      [ExportItem(3, 25), ExportItem(6, 50)],
      [ExportItem(3, 20), ExportItem(5, 30)]),
  ExportCard(
      12,
      [ExportItem(3, 30), ExportItem(7, 70)],
      [ExportItem(3, 20), ExportItem(5, 35)],
      [ExportItem(4, 30), ExportItem(6, 40)],
      [ExportItem(2, 15), ExportItem(6, 35)]),
  ExportCard(
      13,
      [ExportItem(4, 45), ExportItem(8, 85)],
      [ExportItem(3, 15), ExportItem(5, 25)],
      [ExportItem(2, 15), ExportItem(6, 40)],
      [ExportItem(3, 15), ExportItem(7, 35)]),
  ExportCard(
      14,
      [ExportItem(3, 35), ExportItem(7, 80)],
      [ExportItem(4, 20), ExportItem(8, 40)],
      [ExportItem(3, 15), ExportItem(5, 25)],
      [ExportItem(2, 15), ExportItem(6, 45)]),
  ExportCard(
      15,
      [ExportItem(3, 35), ExportItem(7, 75)],
      [ExportItem(3, 20), ExportItem(5, 35)],
      [ExportItem(2, 10), ExportItem(6, 35)],
      [ExportItem(4, 25), ExportItem(7, 40)]),
];

class BusinessDeal {
  const BusinessDeal(this.id, this.food, this.luxury, this.price, this.tariffs);
  final int id;
  final int food;
  final int luxury;
  final int price;
  final List<int> tariffs;
}

const List<BusinessDeal> businessDeals = <BusinessDeal>[
  BusinessDeal(1, 0, 8, 30, [16, 8]),
  BusinessDeal(2, 8, 4, 75, [24, 12]),
  BusinessDeal(3, 6, 0, 40, [12, 6]),
  BusinessDeal(4, 7, 0, 50, [14, 7]),
  BusinessDeal(5, 5, 6, 60, [22, 11]),
  BusinessDeal(6, 0, 10, 40, [20, 10]),
  BusinessDeal(7, 8, 0, 55, [16, 8]),
  BusinessDeal(8, 4, 8, 60, [24, 12]),
  BusinessDeal(9, 0, 12, 50, [24, 12]),
  BusinessDeal(10, 7, 5, 70, [24, 12]),
];
