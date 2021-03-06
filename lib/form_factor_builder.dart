library form_factor_builder;

import 'package:flutter/material.dart';
import 'package:form_factor_builder/form_factor.dart';

export 'package:form_factor_builder/form_factor.dart';
export 'package:form_factor_builder/form_factor_change_listener.dart';

typedef Builder = Widget Function(BuildContext context);

class FormFactorBuilder extends StatefulWidget {
  final Builder? builder;
  final Builder? mobileBuilder;
  final Builder? tabletBuilder;
  final Builder? desktopBuilder;

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

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // If no form factor value has been set yet, report it after first build.
      if (FormFactor.instance.value == null) {
        FormFactor.instance.update();
      }
    });
  }

  Builder? get _desktopBuilder {
    return widget.desktopBuilder ?? widget.builder;
  }

  Builder? get _tabletBuilder {
    return widget.tabletBuilder ?? widget.builder;
  }

  Builder? get _mobileBuilder {
    return widget.mobileBuilder ?? widget.builder;
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

        final formFactor = formFactorSnap.data!;
        final breakpoints = FormFactor.instance.breakpoints;

        assert(_mobileBuilder != null, 'Missing mobile builder');
        assert(
          breakpoints?.tablet == null || _tabletBuilder != null,
          'Missing tablet builder',
        );
        assert(
          breakpoints?.desktop == null || _desktopBuilder != null,
          'Missing desktop builder',
        );

        switch (formFactor) {
          case FormFactors.mobile:
            return _mobileBuilder!(context);
          case FormFactors.tablet:
            return _tabletBuilder!(context);
          case FormFactors.desktop:
            return _desktopBuilder!(context);
        }
      },
    );
  }
}
