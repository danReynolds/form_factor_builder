# Form Factor Builder

A Flutter package for checking and building building widgets by form factor (desktop, tablet, mobile).

## Setup

To get started, initialize the `FormFactor` instance with your desired breakpoints and a `navigatorKey` used to keep track of the current screen size:

```dart
import 'package:form_factor_builder/form_factor_builder.dart';

final navigatorKey = GlobalKey<NavigatorState>();

FormFactor.init(
  /// The breakpoints at which the form factor should switch from mobile to tablet and desktop.
  breakpoints: FormFactorBreakpoints(
    tablet: 760,
    desktop: 1280,
  ),
  /// A global navigator key used to determine the current screen size.
  navigatorKey: navigatorKey,
);

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      home: Home(),
      /// Pass the same `navigatorKey` to the root of your app so that it maintains the current
      // screen size.
      navigatorKey: navigatorKey,
    );
  }
}
```

You can then make form factor checks throughout your application:

```dart
import 'package:form_factor_builder/form_factor_builder.dart';

if (FormFactor.instance.isDesktop) {
  print('desktop');
} else if (FormFactor.instance.isMobile) {
  print('mobile');
}
```

The [FormFactorBuilder](https://pub.dev/documentation/form_factor_builder/latest/form_factor_builder/FormFactorBuilder-class.html) widget makes it easy to build different widgets by form factor:

```dart
import 'package:form_factor_builder/form_factor_builder.dart';

class MyWidget extends StatelessWidget {
  @override
  build(context) {
    return FormFactorBuilder(
      mobileBuilder: (context) {...},
      builder: (context) {...},
    );
  }
}
```

The full list of builders you can specify are:

* builder
* mobileBuilder
* tabletBuilder
* desktopBuilder

The three more specific builders take precedence over the generic [builder](https://pub.dev/documentation/form_factor_builder/latest/form_factor_builder/FormFactorBuilder/builder.html) parameter, which can be used as a default if multiple form factors should share the same implementation.

## Live updates

If you need the form factor you build to live update as the device's screen size changes such as when changing the window size of a Flutter web application on desktop or rotating a tablet from potrait to landscape, then you can add the [FormFactorChangeListener](https://pub.dev/documentation/form_factor_builder/latest/form_factor_change_listener/FormFactorChangeListener-class.html) widget at the root of your app:

```dart
import 'package:form_factor_builder/form_factor_builder.dart';

final navigatorKey = GlobalKey<NavigatorState>();

FormFactor.init(
  breakpoints: FormFactorBreakpoints(
    tablet: 760,
    desktop: 1280,
  ),
  navigatorKey: navigatorKey,
);

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      home: FormFactorChangeListener(
        child: Home(),
      ),
      navigatorKey: navigatorKey,
    );
  }
}
```

Now all `FormFactorBuilder` widgets will rebuild whenever the screen size changes.

## Streaming changes

You can listen to a stream of form factor updates off of the `FormFactor` singleton:

```dart
FormFactor.instance.stream((formFactor) {
  print(formFactor); // desktop
});
```

This can be useful if you want to perform some side-effect when the form factor changes. One example might be for navigating off of screens that are specific to a particular form factor. You may be looking at a modal window on desktop that is actually a separate screen on mobile. To handle a scenario like this, we can perform a side effect like this:

```dart
FormFactors? prevFormFactor;

FormFactor.instance.stream((formFactor) {
  if (formFactor == FormFactors.mobile && prevFormFactor == FormFactors.desktop) {
    Navigator.of(context).pushReplacement(...);
  }
  prevFormFactor = formFactor;
});
```

To make this slightly simpler, you can use the `FormFactor` [changes](https://pub.dev/documentation/form_factor_builder/latest/form_factor/FormFactor/changes.html) stream, which provides the current and previous value:

```dart
FormFactor.instance.changes((formFactors) {
  if (formFactor.first == FormFactors.mobile && formFactors.last == FormFactors.desktop) {
    Navigator.of(context).pushReplacement(...);
  }
});
```

## Feedback welcome

Let us know if there are any issues or improvements you would like to see on the [GitHub](https://github.com/danReynolds/form_factor_builder).