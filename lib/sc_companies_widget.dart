// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'company_widget.dart';

const rowDivider = SizedBox(width: 5);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class StateClassCompaniesWidget extends StatelessWidget {
  const StateClassCompaniesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Column(children: <Widget>[
              Text("STATE CLASS COMPANIES",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              Row(children: [
                CompanyWidget(info: stateClassCompanyCards[0]),
                rowDivider,
                CompanyWidget(info: stateClassCompanyCards[1]),
              ]),
              colDivider,
              Row(children: [
                CompanyWidget(info: stateClassCompanyCards[2]),
                rowDivider,
              ]),
            ])));
  }
}

const List<CompanyInfo> stateClassCompanyCards = <CompanyInfo>[
  CompanyInfo(0, "PUBLIC HOSPITAL", Colors.red, 20, 4, 0, Icons.heart_broken,
      Colors.white, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(1, "PUBLIC UNIVERSITY", Colors.orange, 20, 4, 0, Icons.school,
      Colors.orange, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(2, "REGIONAL TV STATION", Colors.purple, 20, 3, 0,
      Icons.chat_bubble, Colors.purple, 25, 20, 15, 1, 1, 0, 0),
];
