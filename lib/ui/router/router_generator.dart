import 'package:app/ui/router/route_list.dart';
import 'package:app/ui/screen/dashboard/dashboard_screen.dart';
import 'package:app/ui/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  static Route<dynamic>? generate(RouteSettings seting) {
    switch (seting.name) {
      case routeDashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      /// Splash group
      case routeSplash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: routeSplash),
        );
      default:
    }
    return null;
  }
}
