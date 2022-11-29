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
  });

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

  T get mobile {
    assert(
      mobileResolver != null || resolver != null,
      'Missing mobile resolver',
    );
    return mobileResolver?.call() ?? resolver!();
  }

  T get tablet {
    assert(
      tabletResolver != null || resolver != null,
      'Missing tablet resolver',
    );
    return tabletResolver?.call() ?? resolver!();
  }

  T get desktop {
    assert(
      desktopResolver != null || resolver != null,
      'Missing desktop resolver',
    );
    return desktopResolver?.call() ?? resolver!();
  }
}
