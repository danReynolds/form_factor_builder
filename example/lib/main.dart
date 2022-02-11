import 'package:flutter/material.dart';
import 'package:form_factor_builder/form_factor_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  initState() {
    super.initState();

    FormFactor.init(
      navigatorKey: _navigatorKey,
      breakpoints: FormFactorBreakpoints(
        tablet: 760,
        desktop: 1200,
      ),
    );

    FormFactor.instance.changes.listen((values) {
      // ignore: avoid_print
      print('Form factor changed from ${values.current} to ${values.previous}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: FormFactorChangeListener(
        child: Scaffold(
          body: Center(
            child: FormFactorBuilder(
              mobileBuilder: (_context) => const Text('mobile form factor'),
              tabletBuilder: (_context) => const Text('tablet form factor'),
              desktopBuilder: (_context) => const Text('desktop form factor'),
            ),
          ),
        ),
      ),
    );
  }
}
