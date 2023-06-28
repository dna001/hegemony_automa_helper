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

  Future<void> loadPolicies(SharedPreferences prefs,
      List<PriorityState> policyList, String className) async {
    for (int i = 0; i < 7; i++) {
      String orderKey = "policy_" + className + "_order_" + i.toString();
      int id = prefs.getInt(orderKey) ?? -1;
      if (id >= 0) {
        String priorityKey =
            "policy_" + className + "_priority_" + id.toString();
        int priority = prefs.getInt(priorityKey) ?? 0;
        policyList.add(PriorityState(id, priority));
      }
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _policyListWC = [];
    _policyListCC = [];
    _policyListMC = [];
    loadPolicies(prefs, _policyListWC, "wc");
    loadPolicies(prefs, _policyListCC, "cc");
    loadPolicies(prefs, _policyListMC, "mc");
    notifyListeners();
  }

  void savePolicies(SharedPreferences prefs, List<PriorityState> policyList,
      String className) {
    for (int i = 0; i < 7; i++) {
      int id = _policyListWC[i].id;
      String orderKey = "policy_" + className + "_order_" + i.toString();
      String priorityKey = "policy_" + className + "_priority_" + id.toString();
      prefs.setInt(orderKey, id);
      prefs.setInt(priorityKey, policyList[i].priority);
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    savePolicies(prefs, _policyListWC, "wc");
    savePolicies(prefs, _policyListCC, "cc");
    savePolicies(prefs, _policyListMC, "mc");
  }

  void incPolicyPriority(ClassNames cls, int id) {
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

  void incActionPriority(ClassNames cls, int id) {
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

  void resetPriorities(ClassNames cls) {
    resetPolicies(cls);
    resetActions(cls);
    notifyListeners();
  }

  void flattenPriorities(ClassNames cls) {
    List<PriorityState> policyList = getPolicyList(cls);
    // Count number of different priorities
    int numDiffPriorities = 0;
    int oldPriority = 255;
    for (PriorityState state in policyList) {
      if ((state.priority < oldPriority) && (state.priority > -1)) {
        numDiffPriorities++;
        oldPriority = state.priority;
      }
    }
    int currentPriority = numDiffPriorities;
    oldPriority = 255;
    for (PriorityState state in policyList) {
      if ((state.priority < oldPriority) && (state.priority > -1)) {
        currentPriority--;
        oldPriority = state.priority;
        state.priority = currentPriority;
      } else if (state.priority == oldPriority) {
        state.priority = currentPriority;
      }
    }
    notifyListeners();
  }
}
