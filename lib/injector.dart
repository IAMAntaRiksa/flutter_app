import 'package:app/core/data/api.dart';
import 'package:app/core/data/base_api.dart';
import 'package:app/core/services/restaurant/restaurant_service.dart';
import 'package:app/core/untils/favorite/favorite_untils.dart';
import 'package:app/core/untils/navigation/navigation_untlis.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  /// Registering api
  if (locator.isRegistered(instance: Api()) == false) {
    locator.registerSingleton(Api());
  }
  if (locator.isRegistered(instance: BaseAPI()) == false) {
    locator.registerSingleton(BaseAPI());
  }

  /// Registering untils
  locator.registerSingleton(NavigationUtils());
  locator.registerLazySingleton(() => RestaurantService(locator<BaseAPI>()));
  locator.registerLazySingleton(() => FavoriteUtils());
}
