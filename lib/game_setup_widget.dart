// Copyright 2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/board_state.dart';

class GameSetupWidget extends StatefulWidget {
  const GameSetupWidget({super.key});

  @override
  State<GameSetupWidget> createState() => _GameSetupWidgetState();
}

class _GameSetupWidgetState extends State<GameSetupWidget> {

  Future<void> _loadGameSelectionDialogue(BuildContext context) async {
    List<int> itemList = [];
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Load Game")),
          content: SizedBox(
            width: 400,
            height: 250,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: itemList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: ElevatedButton(
                        onPressed: () {
                          //gameState.load(slot: itemList[index].slot);
                          Navigator.pop(context);
                        },
                        child:
                            SizedBox() //SaveGameOverviewWidget(info: itemList[index]),
                        ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    int numPlayers = boardState.numPlayers;

    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Hegemony Game Setup", style: TextStyle(fontSize: 50)),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Players", style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            RadioGroup<int>(
                groupValue: numPlayers,
                onChanged: (value) {
                  boardState.setNumPlayers(value ?? 2);
                },
                child: Row(children: <Widget>[
                  Text("2"),
                  Radio<int>(
                    fillColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    focusColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    value: 2,
                  ),
                  SizedBox(width: 10),
                  Text("3"),
                  Radio<int>(
                    fillColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    focusColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    value: 3,
                  ),
                  Text("4"),
                  Radio<int>(
                    fillColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    focusColor:
                        WidgetStateColor.resolveWith((states) => Colors.white),
                    value: 4,
                  ),
                ]))
          ]),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("WORKER CLASS",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red)),
            SizedBox(width: 10),
            Text("AI", style: TextStyle(fontSize: 16)),
            Checkbox(value: false, onChanged: (value) => {})
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("CAPITALIST CLASS",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blue)),
            SizedBox(width: 10),
            Text("AI", style: TextStyle(fontSize: 16)),
            Checkbox(value: false, onChanged: (value) => {})
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("MIDDLE CLASS",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.yellow)),
            SizedBox(width: 10),
            Text("AI", style: TextStyle(fontSize: 16)),
            Checkbox(value: false, onChanged: (value) => {})
          ]),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              boardState.start();
            },
            child: Text("Start"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _loadGameSelectionDialogue(context);
            },
            child: Text("Load"),
          ),
        ],
      ),
    );
  }
}
