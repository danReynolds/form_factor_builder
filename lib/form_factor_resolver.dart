import 'package:form_factor_builder/form_factor.dart';

// A class that determines the value to resolve given the provided resolvers
// and form factor precedence.
class FormFactorResolver<T> {
  final T Function()? mobileResolver;
  final T Function()? tabletResolver;
  final T Function()? desktopResolver;
  final T Function()? resolver;

  FormFactorResolver({
    this.mobileResolver,
    this.tabletResolver,
    this.desktopResolver,
    this.resolver,
    Set<FormFactors>? supportedFormFactors,
  }) {
    supportedFormFactors ??= FormFactor.instance.supportedFormFactors;

    if (supportedFormFactors.contains(FormFactors.mobile)) {
      assert(_mobile != null, 'Missing mobile resolver');
    }
    if (supportedFormFactors.contains(FormFactors.tablet)) {
      assert(_tablet != null, 'Missing tablet resolver');
    }
    if (supportedFormFactors.contains(FormFactors.desktop)) {
      assert(_desktop != null, 'Missing desktop resolver');
    }
  }

  static T current<T>({
    T Function()? mobileResolver,
    T Function()? tabletResolver,
    T Function()? desktopResolver,
    T Function()? resolver,
  }) {
    return FormFactorResolver(
      mobileResolver: mobileResolver,
      tabletResolver: tabletResolver,
      desktopResolver: desktopResolver,
      resolver: resolver,
    ).resolve();
  }

  /// Resolves the value for the given form factor by precedence, defaulting to the current form factor.
  T resolve([FormFactors? formFactor]) {
    switch (formFactor ?? FormFactor.instance.value!) {
      case FormFactors.mobile:
        return mobile;
      case FormFactors.tablet:
        return tablet;
      case FormFactors.desktop:
        return desktop;
    }
  }

  T Function()? get _mobile {
    return mobileResolver ?? resolver;
  }

  T Function()? get _tablet {
    return tabletResolver ?? resolver;
  }

  T Function()? get _desktop {
    return desktopResolver ?? resolver;
  }

  T get mobile {
    return _mobile!();
  }

  T get tablet {
    return _tablet!();
  }

  T get desktop {
    return _desktop!();
  }
}
