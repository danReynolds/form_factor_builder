import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:form_factor_builder/form_factor_builder.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

final greenTestWidget = Container(
  height: 50,
  width: 50,
  color: Colors.green,
);

final redTestWidget = Container(
  height: 50,
  width: 50,
  color: Colors.red,
);

void main() {
  testGoldens('basic test', (WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();

    FormFactor.init(
      navigatorKey: key,
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: FormFactorChangeListener(
          child: FormFactorBuilder(
            builder: (context) => greenTestWidget,
          ),
        ),
      ),
    );
    await tester.pump(Duration.zero);

    await screenMatchesGolden(tester, 'basic_builder_test',
        customPump: (widget) {
      return widget.pump(Duration.zero);
    });
  });

  testGoldens('uses tablet breakpoint', (WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();

    FormFactor.init(
      // The default test environment size is 800x600
      breakpoints: FormFactorBreakpoints(
        tablet: 400,
      ),
      navigatorKey: key,
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: FormFactorChangeListener(
          child: FormFactorBuilder(
            builder: (context) => redTestWidget,
            tabletBuilder: (context) => greenTestWidget,
          ),
        ),
      ),
    );
    await tester.pump(Duration.zero);

    await screenMatchesGolden(tester, 'tablet_builder_test',
        customPump: (widget) {
      return widget.pump(Duration.zero);
    });
  });

  testGoldens('uses desktop breakpoint', (WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();

    FormFactor.init(
      navigatorKey: key,
      breakpoints: FormFactorBreakpoints(
        desktop: 400,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: FormFactorChangeListener(
          child: FormFactorBuilder(
            builder: (context) => redTestWidget,
            desktopBuilder: (context) => greenTestWidget,
          ),
        ),
      ),
    );
    await tester.pump(Duration.zero);

    await screenMatchesGolden(tester, 'desktop_builder_test',
        customPump: (widget) {
      return widget.pump(Duration.zero);
    });
  });

  testGoldens('uses mobile breakpoint', (WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();

    FormFactor.init(
      navigatorKey: key,
      breakpoints: FormFactorBreakpoints(
        tablet: 1000,
        desktop: 1000,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: FormFactorChangeListener(
          child: FormFactorBuilder(
            builder: (context) => redTestWidget,
            mobileBuilder: (context) => greenTestWidget,
          ),
        ),
      ),
    );
    await tester.pump(Duration.zero);

    await screenMatchesGolden(tester, 'mobile_builder_test',
        customPump: (widget) {
      return widget.pump(Duration.zero);
    });
  });
}
