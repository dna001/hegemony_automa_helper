// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/board_state.dart';

class BusinessDealsWidget extends StatelessWidget {
  const BusinessDealsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BoardState boardState = context.watch<BoardState>();
    int cardId0 = boardState.getItem("business_deal_slot0");
    int cardId1 = boardState.getItem("business_deal_slot1");

    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(children: <Widget>[
            Text("BUSINESS DEALS",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.orange)),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (cardId0 > 0)
                      ? BusinessDealWidget(
                          businessDeal: businessDeals[cardId0 - 1],
                          onTap: () =>
                              boardState.setItem("business_deal_slot0", 0),
                          iconData: Icons.remove)
                      : IconButton(
                          icon: Icon(Icons.list),
                          onPressed: () =>
                              businessDealListDialogue(context, 0)),
                  VerticalDividerCustom(),
                  (cardId1 > 0)
                      ? BusinessDealWidget(
                          businessDeal: businessDeals[cardId1 - 1],
                          onTap: () =>
                              boardState.setItem("business_deal_slot1", 0),
                          iconData: Icons.remove)
                      : IconButton(
                          icon: Icon(Icons.list),
                          onPressed: () =>
                              businessDealListDialogue(context, 1)),
                ]),
          ]),
        ));
  }

  Future<void> businessDealListDialogue(
      BuildContext context, int slot /*, void Function(int id) onAdd*/) {
    BoardState boardState = context.read<BoardState>();
    List<BusinessDeal> businessDealList = boardState.businessDealList();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  width: 450,
                  child: ListView.builder(
                    itemCount: businessDealList.length,
                    itemBuilder: (context, index) => Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.orange, width: 1),
                      ),
                      child: BusinessDealWidget(
                        businessDeal: businessDealList[index],
                        onTap: () => {
                          boardState.setItem(
                              "business_deal_slot$slot", index + 1),
                          Navigator.pop(context)
                        },
                        iconData: Icons.add,
                      ),
                    ),
                  )));
        });
  }
}

class BusinessDealWidget extends StatelessWidget {
  const BusinessDealWidget({
    super.key,
    required this.businessDeal,
    required this.onTap,
    required this.iconData,
  });
  final BusinessDeal businessDeal;
  final VoidCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        if (businessDeal.food > 0) Text(businessDeal.food.toString()),
        if (businessDeal.food > 0) Icon(Icons.agriculture, color: Colors.green),
        if (businessDeal.luxury > 0) Text(businessDeal.luxury.toString()),
        if (businessDeal.luxury > 0) Icon(Icons.smartphone, color: Colors.blue),
      ]),
      Text(businessDeal.price.toString() + "£",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white)),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text("A: ${businessDeal.tariffs[0]}£"),
        Text("B: ${businessDeal.tariffs[1]}£"),
      ]),
      IconButton(icon: Icon(iconData), onPressed: () => onTap()),
    ]);
  }
}

class VerticalDividerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 80.0,
      width: 2.0,
      color: Colors.orange,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}
