// Copyright 2026 Daniel Nygren. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import '../policy_widget.dart';
import '../company_list_widget.dart';
import '../state_area_widget.dart';
import '../unemployed_workers_widget.dart';
import '../export_widget.dart';
import '../round_and_tax_widget.dart';
import '../data/board_state.dart';
import '../business_deals_widget.dart';

const tinySpacing = 3.0;
const smallSpacing = 10.0;
const double cardWidth = 115;
const double widthConstraintLeft = 450;
const double widthConstraintRight = 350;

class GameBoardScreen extends StatefulWidget {
  const GameBoardScreen({super.key});

  @override
  State<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    print("w: $width h: $height");
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(children: [
        SizedBox(width: widthConstraintLeft, child: PolicyWidget()),
        Row(children: [BusinessDealsWidget(), ExportWidget()]),
        SizedBox(
          width: widthConstraintLeft,
          height: 300,
          child: CompanyListWidget(
              title: "CAPITALIST CLASS COMPANIES",
              cls: ClassName.Capitalist,
              borderColor: Colors.blue,
              bsKeyBase: "cc_company_slot"),
        ),
        SizedBox(
          width: widthConstraintLeft,
          child: CompanyListWidget(
              title: "MIDDLE CLASS COMPANIES",
              cls: ClassName.Middle,
              borderColor: Colors.yellow,
              bsKeyBase: "mc_company_slot"),
        )
      ]),
      Column(children: [
        SizedBox(width: widthConstraintRight, child: RoundAndTaxWidget()),
        SizedBox(width: widthConstraintRight, child: StateAreaWidget()),
        SizedBox(
            width: widthConstraintRight,
            child: CompanyListWidget(
                title: "PUBLIC COMPANIES",
                cls: ClassName.State,
                borderColor: Colors.grey,
                bsKeyBase: "sc_company_slot",
                columns: 3,
                rows: 3)),
        SizedBox(width: widthConstraintRight, child: UnemployedWorkersWidget())
      ]),
    ]);
    //return CustomRenderBoxWidget();
    //final automaState automaState = context.watch<automaState>();
  }
}

class CustomRenderBoxWidget extends LeafRenderObjectWidget {
  // ...

  @override
  RenderObject createRenderObject(BuildContext context) {
    final box = CustomRenderBox();
    // ...
    return box;
  }
}

class CustomRenderBox extends RenderBox with WidgetsBindingObserver {
  // ...

  /// Vsync loop ticker.
  Ticker? _ticker;

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get alwaysNeedsCompositing => false;

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  void _onTick(Duration elapsed) {
    // ...
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    WidgetsBinding.instance.addObserver(this);
    _ticker = Ticker(_onTick, debugLabel: 'CustomRenderBox')..start();
    // ...
  }

  @override
  void detach() {
    _ticker?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.detach();
    // ...
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final localBounds = Offset.zero & size;
    final paint = Paint()..style = PaintingStyle.fill;

    context.canvas
      // Canvas background color
      ..drawPaint(paint..color = const Color(0xFF00AAFF))
      // Rectangle
      ..drawRect(
        localBounds.deflate(32),
        paint..color = const Color(0xFF00FF1A),
      )
      // Circle
      ..drawCircle(
        localBounds.center,
        localBounds.longestSide / 4,
        paint..color = const Color(0xFFFFFFFF),
      ); // ...
  }
}
