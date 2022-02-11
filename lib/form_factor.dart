import 'package:flutter/widgets.dart';
import 'package:restate/state_bloc.dart';
import 'package:restate/state_change_tuple.dart';

enum FormFactors { mobile, tablet, desktop }

class FormFactorBreakpoints {
  final int? tablet;
  final int? desktop;

  FormFactorBreakpoints({
    this.tablet,
    this.desktop,
  });
}

class FormFactor {
  FormFactor._();

  final _stateBloc = StateBloc<FormFactors>();
  late FormFactorBreakpoints? breakpoints;
  late GlobalKey<NavigatorState> navigatorKey;

  static late FormFactor instance;

  static void init({
    FormFactorBreakpoints? breakpoints,
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    instance = FormFactor._();
    instance.breakpoints = breakpoints;
    instance.navigatorKey = navigatorKey;
  }

  FormFactors get _formFactor {
    final width = MediaQuery.of(navigatorKey.currentContext!).size.width;

    if (breakpoints?.desktop != null && width >= breakpoints!.desktop!) {
      return FormFactors.desktop;
    } else if (breakpoints?.tablet != null && width >= breakpoints!.tablet!) {
      return FormFactors.tablet;
    }
    return FormFactors.mobile;
  }

  void update() {
    final updatedFormFactor = _formFactor;
    if (updatedFormFactor != instance._stateBloc.value) {
      _stateBloc.add(updatedFormFactor);
    }
  }

  FormFactors? get value {
    return _stateBloc.value;
  }

  Stream<FormFactors?> get stream {
    return _stateBloc.stream;
  }

  Stream<StateChangeTuple<FormFactors?>> get changes {
    return _stateBloc.changes;
  }

  bool get isMobile {
    return _formFactor == FormFactors.mobile;
  }

  bool get isTablet {
    return _formFactor == FormFactors.tablet;
  }

  bool get isDesktop {
    return _formFactor == FormFactors.desktop;
  }
}
