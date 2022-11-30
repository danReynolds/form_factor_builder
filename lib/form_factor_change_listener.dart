import 'package:flutter/material.dart';
import 'package:form_factor_builder/form_factor.dart';

class FormFactorChangeListener extends StatefulWidget {
  final Widget child;

  const FormFactorChangeListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _FormFactorChangeListenerState createState() =>
      _FormFactorChangeListenerState();
}

class _FormFactorChangeListenerState extends State<FormFactorChangeListener> {
  @override
  build(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // The MediaQuery InheritedWidget `of` API must be read in this widget
      // so that it knows to rebuild this widget whenever the MediaQuery value
      // (such as the dimensions of the screen) change.
      MediaQuery.of(context);
      FormFactor.instance.update();
    });

    return StreamBuilder<FormFactors?>(
      stream: FormFactor.instance.stream,
      builder: (context, formFactorSnap) {
        // Delay building the subtree until a form factor has been determined since
        // any descendant widgets dependent on the form factor cannot be built yet.
        if (!formFactorSnap.hasData) {
          return Scaffold(
            body: Container(),
          );
        }

        return widget.child;
      },
    );
  }
}
