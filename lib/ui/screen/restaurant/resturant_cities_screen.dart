import 'package:app/core/untils/navigation/navigation_untlis.dart';
import 'package:app/core/viewmodels/connection/connection_provider.dart';
import 'package:app/core/viewmodels/restaurant/restaurant_provider.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/constant/themes.dart';
import 'package:app/ui/widget/idle/idle_item.dart';
import 'package:app/ui/widget/idle/loading/loading_listview.dart';
import 'package:app/ui/widget/restaurant/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResturantCitiesScreen extends StatelessWidget {
  final String city;
  const ResturantCitiesScreen({
    Key? key,
    required this.city,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme(context) ? grayDarkColor : primaryColor,
        elevation: 0,
        title: Text(
          "Restaurants in $city",
          style: styleTitle.copyWith(
            fontSize: setFontSize(55),
            color: isDarkTheme(context) ? Colors.white : Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => navigate.pop(),
          icon: const Icon(Icons.arrow_back),
          color: isDarkTheme(context) ? Colors.white : Colors.white,
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => RestaurantProvider(),
        child: RestaurantCitiesBody(
          city: city,
        ),
      ),
    );
  }
}

class RestaurantCitiesBody extends StatelessWidget {
  final String city;
  const RestaurantCitiesBody({
    Key? key,
    required this.city,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantProvider, ConnectionProvider>(
      builder: (context, restaurantProv, connectionProv, _) {
        if (connectionProv.internetConnected == false) {
          return IdleNoItemCenter(
            title:
                "No internet connection,\nplease check your wifi or mobile data",
            iconPathSVG: Assets.images.illustrationNoConnection,
            buttonText: "Retry Again",
            onClickButton: () => {},
          );
        }
        if (restaurantProv.restaurantsByCity == null &&
            !restaurantProv.onSearch) {
          restaurantProv.getRestaurantsByCity(city);
          return const LoadingListView();
        }

        if (restaurantProv.restaurantsByCity == null &&
            restaurantProv.onSearch) {
          return const LoadingListView();
        }

        if (restaurantProv.restaurantsByCity!.isEmpty) {
          return IdleNoItemCenter(
            title: "Restaurant not found",
            iconPathSVG: Assets.images.illustrationNotfound,
          );
        }

        return RestaurantListWidget(
          restaurants: restaurantProv.restaurantsByCity!,
        );
      },
    );
  }
}
