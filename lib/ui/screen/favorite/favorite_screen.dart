import 'package:app/core/untils/navigation/navigation_untlis.dart';
import 'package:app/core/viewmodels/favorite/favorite_provider.dart';
import 'package:app/core/viewmodels/restaurant/restaurant_provider.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/constant/themes.dart';
import 'package:app/ui/router/route_list.dart';
import 'package:app/ui/widget/idle/idle_item.dart';
import 'package:app/ui/widget/idle/loading/loading_listview.dart';
import 'package:app/ui/widget/restaurant/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkTheme(context) ? grayDarkColor : primaryColor,
          elevation: 0,
          title: Text(
            "Favorite",
            style: styleTitle.copyWith(
              fontSize: setFontSize(55),
              color: Colors.white,
            ),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) => RestaurantProvider(),
          child: const FavoriteBody(),
        ));
  }
}

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantProvider, FavoriteProvider>(
      builder: (context, restaurantProv, favoriteProv, _) {
        if (restaurantProv.restaurantFavorites == null &&
            !restaurantProv.onSearch) {
          restaurantProv.getRestaurantFavorites(favoriteProv.favorites!);
          return const LoadingListView();
        }

        if (restaurantProv.restaurantFavorites == null &&
            restaurantProv.onSearch) {
          return const LoadingListView();
        }

        if (restaurantProv.restaurantFavorites!.isEmpty) {
          return IdleNoItemCenter(
            title: "Restaurant not found",
            iconPathSVG: Assets.images.illustrationNotfound,
            color: isDarkTheme(context) ? Colors.white : Colors.black,
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: restaurantProv.restaurantFavorites!.length,
          itemBuilder: (context, index) {
            final restaurant = restaurantProv.restaurantFavorites![index];
            bool isFavorite = favoriteProv.isFavorite(restaurant.id);
            return RestaurantItem(
              restaurant: restaurant,
              onClick: () => navigate.pushTo(
                routeRestaurantDetail,
                data: restaurant.id,
              ),
              onClickFavorite: () {
                favoriteProv.toggleFavorite(restaurant.id);
                if (isFavorite) {
                  restaurantProv.removeFavorite(restaurant.id);
                }
              },
              isFavorite: isFavorite,
            );
          },
        );
      },
    );
  }
}
