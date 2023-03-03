library form_factor_builder;

import 'package:flutter/material.dart';
import 'package:form_factor_builder/form_factor.dart';
import 'package:form_factor_builder/form_factor_resolver.dart';

export 'package:form_factor_builder/form_factor.dart';
export 'package:form_factor_builder/form_factor_change_listener.dart';
export 'package:form_factor_builder/form_factor_resolver.dart';

typedef _Builder = Widget Function(BuildContext context);

class FormFactorBuilder extends StatefulWidget {
  final _Builder? builder;
  final _Builder? mobileBuilder;
  final _Builder? tabletBuilder;
  final _Builder? desktopBuilder;

  const FormFactorBuilder({
    this.mobileBuilder,
    this.tabletBuilder,
    this.desktopBuilder,
    this.builder,
    key,
  }) : super(key: key);

  @override
  _FormFactorBuilderState createState() => _FormFactorBuilderState();
}

class _FormFactorBuilderState extends State<FormFactorBuilder> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If no form factor value has been set yet, report it after first build.
      if (!FormFactor.instance.isInitialized) {
        FormFactor.instance.update();
      }
    });
  }

  _Builder Function()? _builderToResolver(_Builder? builder) {
    if (builder != null) {
      return () => builder;
    }
    return null;
  }

  @override
  build(context) {
    return StreamBuilder<FormFactors?>(
      stream: FormFactor.instance.stream,
      initialData: FormFactor.instance.value,
      builder: (context, formFactorSnap) {
        if (!formFactorSnap.hasData) {
          return const SizedBox();
        }

        final resolver = FormFactorResolver<_Builder>(
          desktopResolver: _builderToResolver(widget.desktopBuilder),
          tabletResolver: _builderToResolver(widget.tabletBuilder),
          mobileResolver: _builderToResolver(widget.mobileBuilder),
          resolver: _builderToResolver(widget.builder),
        );

        return resolver.resolve()(context);
      },
    );
  }
}
