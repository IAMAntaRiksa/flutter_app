import 'package:app/core/untils/navigation/navigation_untlis.dart';
import 'package:app/core/viewmodels/connection/connection_provider.dart';
import 'package:app/core/viewmodels/restaurant/restaurant_provider.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/constant/themes.dart';
import 'package:app/ui/router/route_list.dart';
import 'package:app/ui/widget/chip/chip_item.dart';
import 'package:app/ui/widget/idle/idle_item.dart';
import 'package:app/ui/widget/idle/loading/loading_listview.dart';
import 'package:app/ui/widget/idle/loading/loading_type_horizontal.dart';
import 'package:app/ui/widget/restaurant/restaurant_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme(context) ? blackGrayColor : primaryColor,
        elevation: 0,
        title: Text(
          "Restaurant App",
          style: styleTitle.copyWith(
            fontSize: setFontSize(55),
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigate.pushTo(routeRestaurantSearch);
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          ),
          SizedBox(
            height: setFontSize(10),
          ),
          IconButton(
            onPressed: () => navigate.pushTo(routeSetting),
            icon: const Icon(Icons.dark_mode),
            color: Colors.white,
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => RestaurantProvider(),
        child: const RestaurantBody(),
      ),
    );
  }
}

class RestaurantBody extends StatelessWidget {
  const RestaurantBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(
      builder: (context, connectionProv, _) {
        if (connectionProv.internetConnected == false) {
          return IdleNoItemCenter(
            title:
                "No internet connection,\nplease check your wifi or mobile data",
            iconPathSVG: Assets.images.illustrationNoConnection,
            buttonText: "Retry Again",
            color: isDarkTheme(context) ? Colors.white : blackColor,
            onClickButton: () {},
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: setHeight(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CitiesListWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setWidth(40),
                  ),
                  child: Divider(
                    color: blackColor.withOpacity(0.4),
                  ),
                ),
                const _HeaderWidget(),
                const _RestaurantListWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CitiesListWidget extends StatelessWidget {
  const _CitiesListWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: setHeight(40),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cities",
                style: styleTitle.copyWith(
                    fontSize: setFontSize(55),
                    color: isDarkTheme(context) ? Colors.white : blackColor),
              ),
              Text(
                "Interesting city to visit",
                style: styleSubtitle.copyWith(
                  fontSize: setFontSize(40),
                  color: grayDarkColor,
                ),
              ),
            ],
          ),
        ),
        Consumer<RestaurantProvider>(
          builder: (context, restaurantProv, _) {
            if (restaurantProv.cities == null && !restaurantProv.onSearch) {
              restaurantProv.getCities();
              return const LoadingTypeHorizontal();
            }

            if (restaurantProv.cities == null && restaurantProv.onSearch) {
              return const LoadingTypeHorizontal();
            }

            if (restaurantProv.cities!.isEmpty) {
              return const IdleNoItemCenter(
                title: "City not found",
                useDeviceHeight: false,
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: restaurantProv.cities!
                    .asMap()
                    .map(
                      (index, value) => MapEntry(
                        index,
                        ChipItem(
                          name: value,
                          isFirst: index == 0,
                          onClick: () => navigate
                              .pushTo(routeRestaurantByCities, data: value),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RestaurantListWidget extends StatelessWidget {
  const _RestaurantListWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProv, _) {
        if (restaurantProv.restaurants == null && !restaurantProv.onSearch) {
          restaurantProv.getRestaurants();
          return const LoadingListView();
        }

        if (restaurantProv.restaurants == null && restaurantProv.onSearch) {
          return const LoadingListView();
        }

        if (restaurantProv.restaurants!.isEmpty) {
          return IdleNoItemCenter(
            title: "Restaurant not found",
            iconPathSVG: Assets.images.illustrationNotfound,
          );
        }

        return RestaurantListWidget(
          restaurants: restaurantProv.restaurants!,
        );
      },
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: setWidth(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Restaurant",
            style: styleTitle.copyWith(
              fontSize: setFontSize(55),
              color: isDarkTheme(context) ? Colors.white : blackColor,
            ),
          ),
          Text(
            "Recommendation restaurant for you",
            style: styleSubtitle.copyWith(
              fontSize: setFontSize(40),
              color: grayDarkColor,
            ),
          )
        ],
      ),
    );
  }
}
