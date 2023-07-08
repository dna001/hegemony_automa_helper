// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'company_widget.dart';

const rowDivider = SizedBox(width: 5);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class MiddleClassCompaniesWidget extends StatelessWidget {
  const MiddleClassCompaniesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.orange, width: 2),
        ),
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Column(children: <Widget>[
              Text("MIDDLE CLASS COMPANIES",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              Row(children: [
                CompanyWidget(info: middleClassCompanyCards[0]),
                rowDivider,
                CompanyWidget(info: middleClassCompanyCards[1]),
              ]),
            ])));
  }
}

const List<CompanyInfo> middleClassCompanyCards = <CompanyInfo>[
  CompanyInfo(0, "CONVENIENCE STORE", Colors.green, 14, 2, 1, Icons.agriculture,
      Colors.green, 10, 8, 6, 0, 1, 1, 0),
  CompanyInfo(3, "DOCTOR'S OFFICE", Colors.red, 12, 2, 2, Icons.heart_broken,
      Colors.white, 10, 8, 6, 0, 1, 1, 0),
];
