import 'package:app/core/untils/navigation/navigation_untlis.dart';
import 'package:app/core/viewmodels/connection/connection_provider.dart';
import 'package:app/core/viewmodels/favorite/favorite_provider.dart';
import 'package:app/core/viewmodels/restaurant/restaurant_provider.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/constant/themes.dart';
import 'package:app/ui/router/route_list.dart';
import 'package:app/ui/widget/idle/idle_item.dart';
import 'package:app/ui/widget/idle/loading/loading_listview.dart';
import 'package:app/ui/widget/restaurant/restaurant_item.dart';
import 'package:app/ui/widget/search/search_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantSearchScreen extends StatelessWidget {
  const RestaurantSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantProvider(),
      child: RestaurantInitSearchScreen(),
    );
  }
}

class RestaurantInitSearchScreen extends StatefulWidget {
  const RestaurantInitSearchScreen({super.key});

  @override
  State<RestaurantInitSearchScreen> createState() =>
      _RestaurantInitSearchScreenState();
}

class _RestaurantInitSearchScreenState
    extends State<RestaurantInitSearchScreen> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme(context) ? blackGrayColor : primaryColor,
        title: _searchWidget(),
        elevation: 0,
        leading: IconButton(
          onPressed: () => navigate.pop(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Consumer<ConnectionProvider>(
        builder: (context, connectionProv, _) {
          if (connectionProv.internetConnected == false) {
            return IdleNoItemCenter(
              title:
                  "No internet connection,\nplease check your wifi or mobile data",
              iconPathSVG: Assets.images.illustrationNoConnection,
              color: isDarkTheme(context) ? Colors.white : Colors.black,
              buttonText: "Retry Again",
              onClickButton: () => {},
            );
          }

          return const RestaurantSearchBody();
        },
      ),
    );
  }

  Widget _searchWidget() {
    return SearchItem(
      controller: _textEditingController,
      autoFocus: true,
      onSubmit: (value) => {
        RestaurantProvider.instance(context).search(value),
      },
    );
  }
}

class RestaurantSearchBody extends StatelessWidget {
  const RestaurantSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantProvider, FavoriteProvider>(
      builder: (context, restaurantProv, favoriteProv, _) {
        if (restaurantProv.searchRestaurants == null &&
            !restaurantProv.onSearch) {
          return IdleNoItemCenter(
            title: "What restaurant are you looking for?",
            iconPathSVG: Assets.images.illustrationQuestion,
            color: isDarkTheme(context) ? Colors.white : Colors.black,
          );
        }

        if (restaurantProv.searchRestaurants == null &&
            restaurantProv.onSearch) {
          return const LoadingListView();
        }

        if (restaurantProv.searchRestaurants!.isEmpty) {
          return IdleNoItemCenter(
            title: "Restaurant not found",
            iconPathSVG: Assets.images.illustrationNotfound,
            color: isDarkTheme(context) ? Colors.white : Colors.black,
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: restaurantProv.searchRestaurants!.length,
          itemBuilder: (context, index) {
            final restaurant = restaurantProv.searchRestaurants![index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? _searchResultWidget(
                        restaurantProv.searchRestaurants!.length, context)
                    : const SizedBox(),
                RestaurantItem(
                  restaurant: restaurant,
                  onClick: () => navigate.pushTo(
                    routeRestaurantDetail,
                    data: restaurant.id,
                  ),
                  onClickFavorite: () {
                    favoriteProv.toggleFavorite(restaurant.id);
                  },
                  isFavorite: favoriteProv.isFavorite(restaurant.id),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _searchResultWidget(int total, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: setWidth(40),
        vertical: setHeight(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: primaryColor,
            size: 15,
          ),
          Text(
            '$total Restaurants found',
            style: styleTitle.copyWith(
              fontSize: setFontSize(35),
              color: isDarkTheme(context) ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
