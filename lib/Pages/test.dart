import 'package:flutter/material.dart';

class NoBlinkPageRoute<T> extends MaterialPageRoute<T> {
  NoBlinkPageRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
