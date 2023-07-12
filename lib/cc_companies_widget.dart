// Copyright 2023 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'company_widget.dart';

const rowDivider = SizedBox(width: 5);
const colDivider = SizedBox(height: 5);
const double widthConstraint = 450;

class CapitalistClassCompaniesWidget extends StatelessWidget {
  const CapitalistClassCompaniesWidget({super.key});

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
              Text("CAPITALIST CLASS COMPANIES",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.orange)),
              colDivider,
              SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => CompanyWidget(
                        info: capitalistClassCompanyCards[index % 4]),
                  ))
            ])));
  }
}

const List<CompanyInfo> capitalistClassCompanyCards = <CompanyInfo>[
  CompanyInfo(0, "SUPERMARKET", Colors.green, 16, 4, 1, Icons.agriculture,
      Colors.green, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(1, "SHOPPING MALL", Colors.blue, 16, 6, 2, Icons.smartphone,
      Colors.blue, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(2, "COLLEGE", Colors.orange, 16, 6, 2, Icons.school,
      Colors.orange, 25, 20, 15, 1, 1, 0, 0),
  CompanyInfo(3, "CLINIC", Colors.red, 16, 6, 2, Icons.heart_broken,
      Colors.white, 25, 20, 15, 1, 1, 0, 0),
];
