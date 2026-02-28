// Copyright 2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:hegemony_automa_helper/data/board_state.dart';
import 'package:path_provider/path_provider.dart';

enum ActionType {
  // Actions used in setup (and more)
  setNumPlayers,
  playerClassMode, // param == mode (player controlled or automa)
  // Other actions  
  adjustVp,
  adjustMoney,
  adjustCapital, // Capitalist only
  nextPlayer,
  newRound,
  addCompany,
  removeCompany,
  addUnemployedWorker,
  adjustPolicy,
  placeBillMarker,
  // Dummy
  unknown,
}

class Action {
  ActionType type;
  ClassName className;
  int id;
  int? param;
  String? strParam;
  Action(this.type, this.className, this.id);

  static ActionType _strToActionType(String str) {
    for (var actionType in ActionType.values) {
      if (str.compareTo(actionType.name) == 0) {
        return actionType;
      }
    }
    return ActionType.unknown;
  }

  Map<String, dynamic> toJson() {
    if (param != null && strParam != null) {
      return {
        'type': type.name,
        'className': className,
        'id': id,
        'param': param,
        'strParam': strParam,
      };
    } else if (param != null) {
      return {'type': type.name, 'className': className, 'id': id, 'param': param};
    } else if (strParam != null) {
      return {'type': type.name, 'className': className, 'id': id, 'strParam': strParam};
    } else {
      return {'type': type.name, 'className': className, 'id': id};
    }
  }

  static Action fromJson(Map<String, dynamic> data) {
    Action action = Action(
      _strToActionType(data['type'] ?? 'unknown'),
      data['className'],
      data['id'],
    );
    action.param = data['param'];
    action.strParam = data['strParam'];
    return action;
  }
}

class ActionLog {
  List<Action> actionList = [];

  void addAction(ActionType type, ClassName className, int id, {int? param, String? strParam}) {
    Action action = Action(type, className, id);
    action.param = param;
    action.strParam = strParam;
    actionList.add(action);
    print("Action log: ${type.name}, cls=$className, id=$id");
  }

  Future<bool> load(int slot) async {
    var directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/hegemony_save$slot.json';
    var file = File(path);
    bool exists = await file.exists();
    if (!exists) {
      print("Save file $path not found");
      return false;
    }
    String data = await file.readAsString();
    if (data.isEmpty) {
      return false;
    }
    // Create json string
    var jsonResult = json.decode(data);
    actionList = [];
    for (var item in jsonResult) {
      Action action = Action.fromJson(item);
      actionList.add(action);
    }
    return true;
  }

  Future<void> save(int slot) async {
    var directory = await getApplicationDocumentsDirectory();
    var file = File('${directory.path}/hegemony_save$slot.json');
    // Create json string
    var jsonResult = json.encode(actionList);
    await file.writeAsString(jsonResult);
  }
}
