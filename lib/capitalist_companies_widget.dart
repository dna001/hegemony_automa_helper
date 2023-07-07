// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/board_state.dart';
import 'constants.dart';
import 'company_widget.dart';

const rowDivider = SizedBox(width: 5);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class CapitalistCompaniesWidget extends StatelessWidget {
  const CapitalistCompaniesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.blue, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Column(children: <Widget>[
              Row(children: [
                CompanyWidget(info: capitalistCompanyCards[0]),
                rowDivider,
                CompanyWidget(info: capitalistCompanyCards[1]),
              ]),
              colDivider,
              Row(children: [
                CompanyWidget(info: capitalistCompanyCards[2]),
                rowDivider,
                CompanyWidget(info: capitalistCompanyCards[3]),
              ]),
            ])));
  }
}

const List<CompanyInfo> capitalistCompanyCards = <CompanyInfo>[
  CompanyInfo(0, "SUPERMARKET", Colors.green, 16, 4, 1, Icons.agriculture, 25,
      20, 15, 1, 1),
  CompanyInfo(1, "SHOPPING MALL", Colors.blue, 16, 6, 2, Icons.smartphone, 25,
      20, 15, 1, 1),
  CompanyInfo(
      2, "COLLEGE", Colors.orange, 16, 6, 2, Icons.school, 25, 20, 15, 1, 1),
  CompanyInfo(
      3, "CLINIC", Colors.red, 16, 6, 2, Icons.heart_broken, 25, 20, 15, 1, 1),
];
