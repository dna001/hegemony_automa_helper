// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ClassNames { Worker, Capitalist, Middle }

class PriorityState {
  final int id;
  int priority = 0;
  PriorityState(this.id, this.priority);
}

class AutomaState extends ChangeNotifier {
  int saveSlot = 0;
  List<PriorityState> _policyListWC = [];
  List<PriorityState> _policyListCC = [];
  List<PriorityState> _policyListMC = [];
  List<PriorityState> _actionListWC = [];
  List<PriorityState> _actionListCC = [];
  List<PriorityState> _actionListMC = [];
  List<List<PriorityState>> _undoPolicyListWC = [];
  List<List<PriorityState>> _undoPolicyListCC = [];
  List<List<PriorityState>> _undoPolicyListMC = [];
  List<List<PriorityState>> _undoActionListWC = [];
  List<List<PriorityState>> _undoActionListCC = [];
  List<List<PriorityState>> _undoActionListMC = [];

  AutomaState() {
    _resetPolicies(ClassNames.Worker);
    _resetPolicies(ClassNames.Capitalist);
    _resetPolicies(ClassNames.Middle);
    _resetActions(ClassNames.Worker);
    _resetActions(ClassNames.Capitalist);
    _resetActions(ClassNames.Middle);
  }

  Future<void> init() async {
    await setSaveSlot(0);
  }

  void _resetPolicies(ClassNames className) {
    switch (className) {
      case ClassNames.Worker:
        _policyListWC = [
          PriorityState(0, 1),
          PriorityState(4, 1),
          PriorityState(1, 0),
          PriorityState(3, 0),
          PriorityState(5, 0),
          PriorityState(2, -1),
          PriorityState(6, -1)
        ];
        break;
      case ClassNames.Capitalist:
        _policyListCC = [
          PriorityState(2, 1),
          PriorityState(1, 0),
          PriorityState(3, 0),
          PriorityState(4, 0),
          PriorityState(5, 0),
          PriorityState(0, -1),
          PriorityState(4, -1)
        ];
        break;
      case ClassNames.Middle:
        _policyListMC = [
          PriorityState(0, 0),
          PriorityState(2, 0),
          PriorityState(4, 0),
          PriorityState(6, 0),
          PriorityState(1, -1),
          PriorityState(3, -1),
          PriorityState(5, -1)
        ];
        break;
    }
  }

  void _resetActions(ClassNames className) {
    switch (className) {
      case ClassNames.Worker:
        _actionListWC = [
          PriorityState(0, 1),
          PriorityState(1, 1),
          PriorityState(2, 1),
          PriorityState(3, 0),
          PriorityState(4, 0),
          PriorityState(5, 0)
        ];
        break;
      case ClassNames.Capitalist:
        _actionListCC = [
          PriorityState(0, 1),
          PriorityState(1, 1),
          PriorityState(2, 1),
          PriorityState(3, 0),
          PriorityState(4, 0),
          PriorityState(5, 0)
        ];
        break;
      case ClassNames.Middle:
        _actionListMC = [
          PriorityState(0, 1),
          PriorityState(1, 1),
          PriorityState(2, 1),
          PriorityState(3, 0),
          PriorityState(4, 0),
          PriorityState(5, 0)
        ];
        break;
    }
  }

  List<PriorityState> getPolicyList(ClassNames className) {
    switch (className) {
      case ClassNames.Worker:
        return _policyListWC;
      case ClassNames.Capitalist:
        return _policyListCC;
      case ClassNames.Middle:
        return _policyListMC;
    }
  }

  List<PriorityState> getActionList(ClassNames className) {
    switch (className) {
      case ClassNames.Worker:
        return _actionListWC;
      case ClassNames.Capitalist:
        return _actionListCC;
      case ClassNames.Middle:
        return _actionListMC;
    }
  }

  Future<void> setSaveSlot(int slot) async {
    // Set save slot and load state
    saveSlot = slot;
    await load(slot: slot);
    notifyListeners();
  }

  Future<void> _loadPriorities(
      SharedPreferences prefs,
      List<PriorityState> priorityList,
      String typeAndClass,
      int numItems,
      int slot) async {
    for (int i = 0; i < numItems; i++) {
      String orderKey =
          slot.toString() + "_" + typeAndClass + "_order_" + i.toString();
      int id = prefs.getInt(orderKey) ?? -1;
      if (id >= 0) {
        String priorityKey =
            slot.toString() + "_" + typeAndClass + "_priority_" + id.toString();
        int priority = prefs.getInt(priorityKey) ?? 0;
        priorityList.add(PriorityState(id, priority));
      }
    }
  }

  Future<void> load({int slot = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if slot used before loading
    int foundKeys = 0;
    String wcKey = slot.toString() + "_policy_wc_order_0";
    if (prefs.containsKey(wcKey)) {
      _policyListWC = [];
      _actionListWC = [];
      _loadPriorities(prefs, _policyListWC, "policy_wc", 7, slot);
      _loadPriorities(prefs, _actionListWC, "action_wc", 6, slot);
      print("Loaded WC for slot " + slot.toString());
      foundKeys++;
    }
    String ccKey = slot.toString() + "_policy_cc_order_0";
    if (prefs.containsKey(ccKey)) {
      _policyListCC = [];
      _actionListCC = [];
      _loadPriorities(prefs, _policyListCC, "policy_cc", 7, slot);
      _loadPriorities(prefs, _actionListCC, "action_cc", 6, slot);
      print("Loaded CC for slot " + slot.toString());
      foundKeys++;
    }
    String mcKey = slot.toString() + "_policy_mc_order_0";
    if (prefs.containsKey(mcKey)) {
      _policyListMC = [];
      _actionListMC = [];
      _loadPriorities(prefs, _policyListMC, "policy_mc", 7, slot);
      _loadPriorities(prefs, _actionListMC, "action_mc", 6, slot);
      print("Loaded MC for slot " + slot.toString());
      foundKeys++;
    }
    if (foundKeys == 0) {
      print("Slot " + slot.toString() + " is empty");
    }
    // Clear undo history
    _undoPolicyListWC.clear();
    _undoPolicyListCC.clear();
    _undoPolicyListMC.clear();
    _undoActionListWC.clear();
    _undoActionListCC.clear();
    _undoActionListMC.clear();
  }

  void _savePriorities(
      SharedPreferences prefs,
      List<PriorityState> lastPriorityList,
      List<PriorityState> priorityList,
      String typeAndClass,
      int slot,
      bool saveAll) {
    if (saveAll) {
      print("Save all");
    }
    for (int i = 0; i < priorityList.length; i++) {
      int id = priorityList[i].id;
      String orderKey =
          slot.toString() + "_" + typeAndClass + "_order_" + i.toString();
      String priorityKey =
          slot.toString() + "_" + typeAndClass + "_priority_" + id.toString();
      // Only save if changed. Compare with lastPriorityList.
      if (saveAll ||
          (lastPriorityList[i].priority != priorityList[i].priority) ||
          (lastPriorityList[i].id != priorityList[i].id)) {
        prefs.setInt(orderKey, id);
        prefs.setInt(priorityKey, priorityList[i].priority);
        print("Saving " + orderKey + ":" + id.toString());
        print("Saving " +
            priorityKey +
            ":" +
            priorityList[i].priority.toString());
      }
    }
  }

  Future<void> save(ClassNames cls,
      {List<PriorityState>? undoPolicyPriorityList,
      List<PriorityState>? undoActionPriorityList}) async {
    final prefs = await SharedPreferences.getInstance();
    // Check if slot is used
    if (cls == ClassNames.Worker) {
      String testKey = saveSlot.toString() + "_policy_wc_order_0";
      bool slotUsed = prefs.containsKey(testKey);
      _savePriorities(prefs, undoPolicyPriorityList ?? _undoPolicyListWC.last,
          _policyListWC, "policy_wc", saveSlot, !slotUsed);
      _savePriorities(prefs, undoActionPriorityList ?? _undoActionListWC.last,
          _actionListWC, "action_wc", saveSlot, !slotUsed);
    } else if (cls == ClassNames.Capitalist) {
      String testKey = saveSlot.toString() + "_policy_cc_order_0";
      bool slotUsed = prefs.containsKey(testKey);
      _savePriorities(prefs, undoPolicyPriorityList ?? _undoPolicyListCC.last,
          _policyListCC, "policy_cc", saveSlot, !slotUsed);
      _savePriorities(prefs, undoActionPriorityList ?? _undoActionListCC.last,
          _actionListCC, "action_cc", saveSlot, !slotUsed);
    } else if (cls == ClassNames.Middle) {
      String testKey = saveSlot.toString() + "_policy_mc_order_0";
      bool slotUsed = prefs.containsKey(testKey);
      _savePriorities(prefs, undoPolicyPriorityList ?? _undoPolicyListMC.last,
          _policyListMC, "policy_mc", saveSlot, !slotUsed);
      _savePriorities(prefs, undoActionPriorityList ?? _undoActionListMC.last,
          _actionListMC, "action_mc", saveSlot, !slotUsed);
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> incPolicyPriority(ClassNames cls, int id) async {
    _storeUndoInfo(cls);
    List<PriorityState> policyList = getPolicyList(cls);
    for (PriorityState state in policyList) {
      if (state.id == id) {
        state.priority += 1;
      }
    }
    // Reorder list
    policyList.sort((a, b) => b.priority.compareTo(a.priority));
    await save(cls);
    notifyListeners();
  }

  Future<void> removePolicy(ClassNames cls, int id) async {
    _storeUndoInfo(cls);
    List<PriorityState> policyList = getPolicyList(cls);
    for (PriorityState state in policyList) {
      if (state.id == id) {
        state.priority = -1;
      }
    }
    // Reorder list
    policyList.sort((a, b) => b.priority.compareTo(a.priority));
    await save(cls);
    notifyListeners();
  }

  Future<void> incActionPriority(ClassNames cls, int id) async {
    _storeUndoInfo(cls);
    List<PriorityState> actionList = getActionList(cls);
    for (PriorityState state in actionList) {
      if (state.id == id) {
        state.priority += 1;
      }
    }
    // Reorder list
    actionList.sort((a, b) => b.priority.compareTo(a.priority));
    await save(cls);
    notifyListeners();
  }

  Future<void> decActionPriority(ClassNames cls, int id) async {
    _storeUndoInfo(cls);
    List<PriorityState> actionList = getActionList(cls);
    PriorityState foundState = PriorityState(0, 0);
    for (PriorityState state in actionList) {
      if (state.id == id) {
        foundState = state;
      }
    }
    // Trick to get priority to rigth side of same priority row
    if (foundState.priority > 0) {
      foundState.priority -= 2;
    } else {
      foundState.priority -= 1;
    }
    actionList.sort((a, b) => b.priority.compareTo(a.priority));
    foundState.priority += 1;
    actionList.sort((a, b) => b.priority.compareTo(a.priority));
    await save(cls);
    notifyListeners();
  }

  Future<void> resetPriorities(ClassNames cls) async {
    _storeUndoInfo(cls);
    _resetPolicies(cls);
    _resetActions(cls);
    await save(cls);
    notifyListeners();
  }

  void _flattenPrioritiesHelper(List<PriorityState> priorityList) {
    // Count number of different priorities
    int numDiffPriorities = 0;
    int oldPriority = 255;
    for (PriorityState state in priorityList) {
      if ((state.priority < oldPriority) && (state.priority > -1)) {
        numDiffPriorities++;
        oldPriority = state.priority;
      }
    }
    int currentPriority = numDiffPriorities;
    oldPriority = 255;
    for (PriorityState state in priorityList) {
      if ((state.priority < oldPriority) && (state.priority > -1)) {
        currentPriority--;
        oldPriority = state.priority;
        state.priority = currentPriority;
      } else if (state.priority == oldPriority) {
        state.priority = currentPriority;
      }
    }
  }

  Future<void> flattenPriorities(ClassNames cls) async {
    _storeUndoInfo(cls);
    _flattenPrioritiesHelper(getPolicyList(cls));
    _flattenPrioritiesHelper(getActionList(cls));
    await save(cls);
    notifyListeners();
  }

  List<List<PriorityState>> _getUndoPolicyList(ClassNames className) {
    switch (className) {
      case ClassNames.Worker:
        return _undoPolicyListWC;
      case ClassNames.Capitalist:
        return _undoPolicyListCC;
      case ClassNames.Middle:
        return _undoPolicyListMC;
    }
  }

  List<List<PriorityState>> _getUndoActionList(ClassNames className) {
    switch (className) {
      case ClassNames.Worker:
        return _undoActionListWC;
      case ClassNames.Capitalist:
        return _undoActionListCC;
      case ClassNames.Middle:
        return _undoActionListMC;
    }
  }

  void _storeUndoInfoHelper(List<List<PriorityState>> undoPriorityList,
      List<PriorityState> currentPriorityList) {
    List<PriorityState> copy = [];
    for (PriorityState state in currentPriorityList) {
      copy.add(PriorityState(state.id, state.priority));
    }
    undoPriorityList.add(copy);
    if (undoPriorityList.length > 50) {
      // Discard oldest undo history
      undoPriorityList.removeAt(0);
    }
  }

  void _storeUndoInfo(ClassNames className) {
    // Store policy undo history
    _storeUndoInfoHelper(
        _getUndoPolicyList(className), getPolicyList(className));
    // Store action undo history
    _storeUndoInfoHelper(
        _getUndoActionList(className), getActionList(className));
  }

  void _undoHelper(List<List<PriorityState>> undoPriorityList,
      List<PriorityState> currentPriorityList) {
    if (undoPriorityList.length > 0) {
      List<PriorityState> lastPriorityList = undoPriorityList.removeLast();
      currentPriorityList.clear();
      currentPriorityList.addAll(lastPriorityList);
    }
  }

  Future<void> undo(ClassNames cls) async {
    // Undo last action
    List<PriorityState> oldPolicyPriorityList = [];
    for (PriorityState state in getPolicyList(cls)) {
      oldPolicyPriorityList.add(PriorityState(state.id, state.priority));
    }
    _undoHelper(_getUndoPolicyList(cls), getPolicyList(cls));
    List<PriorityState> oldActionPriorityList = [];
    for (PriorityState state in getActionList(cls)) {
      oldActionPriorityList.add(PriorityState(state.id, state.priority));
    }
    _undoHelper(_getUndoActionList(cls), getActionList(cls));
    await save(cls,
        undoPolicyPriorityList: oldPolicyPriorityList,
        undoActionPriorityList: oldActionPriorityList);
    notifyListeners();
  }
}
