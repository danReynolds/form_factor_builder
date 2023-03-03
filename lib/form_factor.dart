import 'package:flutter/widgets.dart';
import 'package:restate/state_bloc.dart';
import 'package:restate/state_change_tuple.dart';

enum FormFactors {
  mobile,
  tablet,
  desktop;

  bool operator <(Enum other) {
    return index < other.index;
  }

  bool operator <=(Enum other) {
    return index <= other.index;
  }

  bool operator >=(Enum other) {
    return index >= other.index;
  }

  bool operator >(Enum other) {
    return index > other.index;
  }
}

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

  final _formFactorBloc = StateBloc<FormFactors>();
  final _orientationBloc = StateBloc<Orientation>();
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

  void update() {
    final updatedFormFactor = value;
    final updatedOrientation = orientation;

    if (updatedFormFactor != instance._formFactorBloc.value) {
      _formFactorBloc.add(updatedFormFactor);
    }

    if (updatedOrientation != instance._orientationBloc.value) {
      _orientationBloc.add(orientation);
    }
  }

  bool get isInitialized {
    return _formFactorBloc.value != null;
  }

  FormFactors get value {
    final width = MediaQuery.of(navigatorKey.currentContext!).size.width;

    if (breakpoints?.desktop != null && width >= breakpoints!.desktop!) {
      return FormFactors.desktop;
    } else if (breakpoints?.tablet != null && width >= breakpoints!.tablet!) {
      return FormFactors.tablet;
    }
    return FormFactors.mobile;
  }

  Orientation get orientation {
    final size = MediaQuery.of(navigatorKey.currentContext!).size;

    if (size.width > size.height) {
      return Orientation.landscape;
    }
    return Orientation.portrait;
  }

  Set<FormFactors> get supportedFormFactors {
    return {
      FormFactors.mobile,
      if (breakpoints?.tablet != null) FormFactors.tablet,
      if (breakpoints?.desktop != null) FormFactors.desktop,
    };
  }

  Stream<FormFactors?> get stream {
    return _formFactorBloc.stream;
  }

  Stream<StateChangeTuple<FormFactors?>> get changes {
    return _formFactorBloc.changes;
  }

  bool get isMobile {
    return value == FormFactors.mobile;
  }

  bool get isTablet {
    return value == FormFactors.tablet;
  }

  bool get isDesktop {
    return value == FormFactors.desktop;
  }

  bool get isPortrait {
    return orientation == Orientation.portrait;
  }

  bool get isLandscape {
    return orientation == Orientation.landscape;
  }
}
