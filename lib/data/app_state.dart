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

class AppState extends ChangeNotifier {
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

  AppState() {
    resetPolicies(ClassNames.Worker);
    resetPolicies(ClassNames.Capitalist);
    resetPolicies(ClassNames.Middle);
    resetActions(ClassNames.Worker);
    resetActions(ClassNames.Capitalist);
    resetActions(ClassNames.Middle);
  }

  void resetPolicies(ClassNames className) {
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

  void resetActions(ClassNames className) {
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
    _policyListWC = [];
    _policyListCC = [];
    _policyListMC = [];
    _actionListWC = [];
    _actionListCC = [];
    _actionListMC = [];
    _loadPriorities(prefs, _policyListWC, "policy_wc", 7, slot);
    _loadPriorities(prefs, _policyListCC, "policy_cc", 7, slot);
    _loadPriorities(prefs, _policyListMC, "policy_mc", 7, slot);
    _loadPriorities(prefs, _actionListWC, "action_wc", 6, slot);
    _loadPriorities(prefs, _actionListCC, "action_cc", 6, slot);
    _loadPriorities(prefs, _actionListMC, "action_mc", 6, slot);
    notifyListeners();
  }

  void savePriorities(SharedPreferences prefs, List<PriorityState> priorityList,
      String typeAndClass, int slot) {
    for (int i = 0; i < priorityList.length; i++) {
      int id = priorityList[i].id;
      String orderKey =
          slot.toString() + "_" + typeAndClass + "_order_" + i.toString();
      String priorityKey =
          slot.toString() + "_" + typeAndClass + "_priority_" + id.toString();
      prefs.setInt(orderKey, id);
      prefs.setInt(priorityKey, priorityList[i].priority);
    }
  }

  Future<void> save({int slot = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    savePriorities(prefs, _policyListWC, "policy_wc", slot);
    savePriorities(prefs, _policyListCC, "policy_cc", slot);
    savePriorities(prefs, _policyListMC, "policy_mc", slot);
    savePriorities(prefs, _actionListWC, "action_wc", slot);
    savePriorities(prefs, _actionListCC, "action_cc", slot);
    savePriorities(prefs, _actionListMC, "action_mc", slot);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void incPolicyPriority(ClassNames cls, int id) {
    storeUndoInfo(cls);
    List<PriorityState> policyList = getPolicyList(cls);
    for (PriorityState state in policyList) {
      if (state.id == id) {
        state.priority += 1;
      }
    }
    // Reorder list
    policyList.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }

  void removePolicy(ClassNames cls, int id) {
    storeUndoInfo(cls);
    List<PriorityState> policyList = getPolicyList(cls);
    for (PriorityState state in policyList) {
      if (state.id == id) {
        state.priority = -1;
      }
    }
    // Reorder list
    policyList.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }

  void incActionPriority(ClassNames cls, int id) {
    storeUndoInfo(cls);
    List<PriorityState> actionList = getActionList(cls);
    for (PriorityState state in actionList) {
      if (state.id == id) {
        state.priority += 1;
      }
    }
    // Reorder list
    actionList.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }

  void decActionPriority(ClassNames cls, int id) {
    storeUndoInfo(cls);
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
    notifyListeners();
  }

  void resetPriorities(ClassNames cls) {
    storeUndoInfo(cls);
    resetPolicies(cls);
    resetActions(cls);
    notifyListeners();
  }

  void flattenPrioritiesHelper(List<PriorityState> priorityList) {
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

  void flattenPriorities(ClassNames cls) {
    storeUndoInfo(cls);
    flattenPrioritiesHelper(getPolicyList(cls));
    flattenPrioritiesHelper(getActionList(cls));
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
  }

  void storeUndoInfo(ClassNames className) {
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
    if (undoPriorityList.length > 50) {
      // Discard oldest undo history
      undoPriorityList.removeAt(0);
    }
  }

  void undo(ClassNames className) {
    // Undo last action
    _undoHelper(_getUndoPolicyList(className), getPolicyList(className));
    _undoHelper(_getUndoActionList(className), getActionList(className));
    notifyListeners();
  }
}
