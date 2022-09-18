import 'package:flutter/cupertino.dart';

class Endpoints extends InheritedWidget {
  const Endpoints({required super.child});

  static Endpoints? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Endpoints>();

  final String GET_SONGS = "https://";

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }


}