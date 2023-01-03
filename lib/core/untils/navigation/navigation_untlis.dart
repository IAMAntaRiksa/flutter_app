import 'package:app/injector.dart';
import 'package:flutter/widgets.dart';

class NavigationUtils {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> pushTo(String routeName, {dynamic data}) =>
      navigatorKey.currentState!.pushNamed(routeName, arguments: data);

  Future<dynamic> pushToReplacement(String routeName, {dynamic data}) =>
      navigatorKey.currentState!
          .pushReplacementNamed(routeName, arguments: data);

  Future<dynamic> pushToRemoveUntil(String routeName, {dynamic data}) =>
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
          routeName, (route) => false,
          arguments: data);

  dynamic pop({dynamic data}) => navigatorKey.currentState!.pop(data);
}

final navigate = locator<NavigationUtils>();
