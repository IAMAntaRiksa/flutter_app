import 'package:app/ui/router/route_list.dart';
import 'package:app/ui/screen/dashboard/dashboard_screen.dart';
import 'package:app/ui/screen/restaurant/restaurant_detail_screen.dart';
import 'package:app/ui/screen/restaurant/restaurant_search_screen.dart';
import 'package:app/ui/screen/restaurant/resturant_cities_screen.dart';
import 'package:app/ui/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  /// Initializing route
  static Route<dynamic>? generate(RouteSettings settings) {
    /// Declaring argumen route
    final args = settings.arguments;

    switch (settings.name) {

      /// Dashboard group
      case routeDashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
          settings: const RouteSettings(name: routeDashboard),
        );

      /// Splash group
      case routeSplash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: const RouteSettings(name: routeSplash),
        );

      /// Restaurant group
      // case routeRestaurant:
      //   return MaterialPageRoute(
      //     builder: (_) => const RestaurantScreen(),
      //     settings: const RouteSettings(name: routeRestaurant),
      //   );
      case routeRestaurantSearch:
        return MaterialPageRoute(
          builder: (_) => const RestaurantSearchScreen(),
          settings: const RouteSettings(name: routeRestaurantSearch),
        );
      case routeRestaurantByCities:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => ResturantCitiesScreen(
              city: args,
            ),
            settings: const RouteSettings(name: routeRestaurantByCities),
          );
        }
        break;
      case routeRestaurantDetail:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => RestaurantDetailScreen(
              id: args,
            ),
            settings: const RouteSettings(name: routeRestaurantDetail),
          );
        }
        break;
    }

    return null;
  }
}
