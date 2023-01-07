import 'package:app/core/models/category/category_model.dart';
import 'package:app/core/models/restaurant/restaurant_model.dart';
import 'package:app/core/models/review/create_review_model.dart';
import 'package:app/core/models/review/review_model.dart';
import 'package:app/core/untils/navigation/navigation_untlis.dart';
import 'package:app/core/viewmodels/connection/connection_provider.dart';
import 'package:app/core/viewmodels/favorite/favorite_provider.dart';
import 'package:app/core/viewmodels/restaurant/restaurant_provider.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/gen/fonts.gen.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/constant/themes.dart';
import 'package:app/ui/widget/chip/chip_item.dart';
import 'package:app/ui/widget/idle/idle_item.dart';
import 'package:app/ui/widget/idle/loading/loading_listview.dart';
import 'package:app/ui/widget/restaurant/restaurant_list.dart';
import 'package:app/ui/widget/review/review_item.dart';
import 'package:app/ui/widget/textfield/custom_textfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantProvider(),
      child: RestaurantInitDetailScreen(
        id: id,
      ),
    );
  }
}

class RestaurantInitDetailScreen extends StatelessWidget {
  final String id;
  const RestaurantInitDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<RestaurantProvider, ConnectionProvider>(
        builder: (context, restaurantProv, connectionProv, _) {
          if (connectionProv.internetConnected == false) {
            return IdleNoItemCenter(
              title:
                  "No internet connection,\nplease check your wifi or mobile data",
              iconPathSVG: Assets.images.illustrationNoConnection,
              buttonText: "Retry Again",
              color: isDarkTheme(context) ? Colors.white : blackColor,
              onClickButton: () => {},
            );
          }
          if (restaurantProv.restaurant == null && !restaurantProv.onSearch) {
            restaurantProv.getRestaurant(id);
            return const IdleLoadingCenter();
          }

          if (restaurantProv.restaurant == null && restaurantProv.onSearch) {
            return const IdleLoadingCenter();
          }

          if (restaurantProv.restaurant!.id.isEmpty) {
            return IdleNoItemCenter(
              title: "Restaurant not found",
              iconPathSVG: Assets.images.illustrationNotfound,
            );
          }

          return RestaurantDetailSliverBody(
            restaurant: restaurantProv.restaurant!,
          );
        },
      ),
    );
  }
}

class RestaurantDetailSliverBody extends StatelessWidget {
  final RestaurantModel restaurant;
  const RestaurantDetailSliverBody({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      body: RestaurantDetailContentBody(
        restaurant: restaurant,
      ),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            elevation: 0,
            expandedHeight: deviceHeight * 0.4,
            floating: false,
            pinned: true,
            title: Text(
              restaurant.name,
              style: styleTitle.copyWith(
                fontSize: setFontSize(50),
                color: isDarkTheme(context) ? Colors.white : Colors.white,
              ),
            ),
            backgroundColor:
                isDarkTheme(context) ? blackGrayColor : primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: _flexibleSpace(context),
          ),
        ];
      },
    );
  }

  Widget _flexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      collapseMode: CollapseMode.pin,
      background: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Hero(
              tag: restaurant.id,
              child: Image.network(
                restaurant.image?.smallResolution ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: -3,
            left: 0,
            right: 0,
            child: Container(
              height: setHeight(80),
              decoration: BoxDecoration(
                color: isDarkTheme(context) ? blackBGColor : Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              child: Center(
                child: Container(
                  width: deviceWidth * 0.12,
                  height: setHeight(15),
                  decoration: BoxDecoration(
                    color: grayColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(42),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 30,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setWidth(30),
                    vertical: setHeight(30),
                  ),
                  child: AnimatedCrossFade(
                    firstChild: Icon(
                      Icons.favorite,
                      color: primaryColor,
                      size: 20,
                    ),
                    secondChild: Icon(
                      Icons.favorite_border,
                      color: primaryColor,
                      size: 20,
                    ),
                    crossFadeState: CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RestaurantDetailContentBody extends StatelessWidget {
  final RestaurantModel restaurant;

  const RestaurantDetailContentBody({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RestaurantDetailInfoWidget(
            restaurant: restaurant,
          ),
          _RestaurantDetailMenuWidget(
            restaurant: restaurant,
          ),
          _RestaurantDetailReviewWidget(
            reviews: restaurant.reviews,
          ),
          _RestaurantDetailRecommendationsCityWidget(
            city: restaurant.city,
            id: restaurant.id,
          ),
          SizedBox(
            height: deviceHeight * 0.1,
          ),
        ],
      ),
    );
  }
}

class _RestaurantDetailRecommendationsCityWidget extends StatelessWidget {
  final String city;
  final String id;

  const _RestaurantDetailRecommendationsCityWidget(
      {Key? key, required this.city, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: setWidth(40),
          ),
          child: Text(
            "Another Restaurants in $city",
            style: styleTitle.copyWith(
              color: isDarkTheme(context) ? Colors.white : darkColor,
              fontSize: setFontSize(35),
            ),
          ),
        ),
        Consumer<RestaurantProvider>(
          builder: (context, restaurantProv, _) {
            if (restaurantProv.restaurants == null &&
                !restaurantProv.onSearch) {
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
              restaurants: restaurantProv.restaurants!
                  .where((element) => element.city == city && element.id != id)
                  .toList(),
              useReplacement: true,
            );
          },
        )
      ],
    );
  }
}

class _RestaurantDetailReviewWidget extends StatefulWidget {
  final List<ReviewModel>? reviews;
  const _RestaurantDetailReviewWidget({Key? key, required this.reviews})
      : super(key: key);

  @override
  State<_RestaurantDetailReviewWidget> createState() =>
      _RestaurantDetailReviewWidgetState();
}

class _RestaurantDetailReviewWidgetState
    extends State<_RestaurantDetailReviewWidget> {
  var reviewController = TextEditingController();

  void sendReview() {
    if (reviewController.text.isNotEmpty) {
      final resturantProv = RestaurantProvider.instance(context);
      resturantProv.createReview(
        CreateReviewModel(
          id: resturantProv.restaurant!.id,
          name: "Testing",
          review: reviewController.text,
        ),
      );
      reviewController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

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
            "Reviews",
            style: styleTitle.copyWith(
              color: isDarkTheme(context) ? Colors.white : darkColor,
              fontSize: setFontSize(35),
            ),
          ),
          SizedBox(
            height: setHeight(20),
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: reviewController,
                  autoFocus: false,
                  hintText: "Write your review",
                  onSubmit: (value) {},
                ),
              ),
              SizedBox(
                width: setWidth(30),
              ),
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => sendReview(),
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: setWidth(35),
                        vertical: setHeight(18),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: setHeight(40),
          ),
          widget.reviews!.isEmpty
              ? IdleNoItemCenter(
                  title: "No review",
                  iconPathSVG: Assets.images.illustrationNotfound,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.reviews!.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final review = widget.reviews?[index];
                    return ReviewItem(
                      review: review!,
                    );
                  },
                )
        ],
      ),
    );
  }
}

class _RestaurantDetailMenuWidget extends StatelessWidget {
  final RestaurantModel restaurant;
  _RestaurantDetailMenuWidget({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: setHeight(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: setWidth(40),
            ),
            child: Text(
              "Menu",
              style: styleTitle.copyWith(
                color: isDarkTheme(context) ? Colors.white : darkColor,
                fontSize: setFontSize(35),
              ),
            ),
          ),
          _menuItems(
            iconPath: Assets.icons.iconFood,
            title: "Foods",
            items: restaurant.menus != null
                ? restaurant.menus!.foods.map((e) => e.name).toList()
                : [],
          ),
          _menuItems(
            iconPath: Assets.icons.iconDrink,
            title: "Drinks",
            items: restaurant.menus != null
                ? restaurant.menus!.drinks.map((e) => e.name).toList()
                : [],
          )
        ],
      ),
    );
  }

  Widget _menuItems({
    required String iconPath,
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: setWidth(40),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: setWidth(40),
                height: setHeight(40),
                color: primaryColor,
              ),
              SizedBox(
                width: setWidth(10),
              ),
              Text(
                title,
                style: styleTitle.copyWith(
                  fontSize: setFontSize(35),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: setHeight(10),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .asMap()
                .map((index, value) => MapEntry(
                    index,
                    ChipItem(
                      name: value,
                      isFirst: index == 0,
                      onClick: () {},
                    )))
                .values
                .toList(),
          ),
        )
      ],
    );
  }
}

class _RestaurantDetailCategoryWidget extends StatelessWidget {
  final List<CategoryModel>? categories;
  const _RestaurantDetailCategoryWidget({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _menuItems(
      context: context,
      title: "Category",
      iconPath: Assets.icons.iconFood,
      items: categories != null ? categories!.map((e) => e.name).toList() : [],
    );
  }

  Widget _menuItems({
    required BuildContext context,
    required String title,
    required String iconPath,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: styleTitle.copyWith(
            fontSize: setFontSize(35),
            color: isDarkTheme(context) ? Colors.white : blackColor,
          ),
        ),
        SizedBox(
          height: setHeight(10),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .asMap()
                .map((index, value) => MapEntry(
                    index,
                    ChipItem(
                      name: value,
                      isFirst: false,
                      onClick: () {},
                    )))
                .values
                .toList(),
          ),
        )
      ],
    );
  }
}

class _RestaurantDetailInfoWidget extends StatefulWidget {
  final RestaurantModel restaurant;
  const _RestaurantDetailInfoWidget({required this.restaurant});

  @override
  State<_RestaurantDetailInfoWidget> createState() =>
      _RestaurantDetailInfoWidgetState();
}

class _RestaurantDetailInfoWidgetState
    extends State<_RestaurantDetailInfoWidget> {
  bool viewMore = false;
  void toggleViewMore() {
    setState(() {
      viewMore = !viewMore;
    });
  }

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
            widget.restaurant.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: styleTitle.copyWith(
              fontSize: setFontSize(55),
              color: isDarkTheme(context) ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(
            height: setHeight(5),
          ),
          Row(
            children: [
              RatingBar(
                initialRating: widget.restaurant.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                ignoreGestures: true,
                itemCount: 5,
                itemSize: 13,
                ratingWidget: RatingWidget(
                  full: const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  half: const Icon(
                    Icons.star_half,
                    color: Colors.amber,
                  ),
                  empty: const Icon(
                    Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
                onRatingUpdate: (rating) {
                  debugPrint(rating.toString());
                },
              ),
              Text(
                " (${widget.restaurant.rating.toString()})",
                style: styleSubtitle.copyWith(
                  fontSize: setFontSize(30),
                  color: grayDarkColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: setHeight(10),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                color: primaryColor,
                size: 15,
              ),
              SizedBox(
                width: setWidth(5),
              ),
              Expanded(
                child: Text(
                  (widget.restaurant.address!.isNotEmpty
                          ? "${widget.restaurant.address}, "
                          : "") +
                      widget.restaurant.city,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styleSubtitle.copyWith(
                    fontSize: setFontSize(35),
                    color: isDarkTheme(context) ? Colors.white : grayDarkColor,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: setHeight(10),
            ),
            child: Divider(
              color: blackColor.withOpacity(0.5),
            ),
          ),
          _RestaurantDetailCategoryWidget(
            categories: widget.restaurant.categories,
          ),
          SizedBox(
            height: setHeight(10),
          ),
          Text(
            "Description",
            style: styleTitle.copyWith(
              fontSize: setFontSize(38),
              color: isDarkTheme(context) ? Colors.white : blackColor,
            ),
          ),
          SizedBox(
            height: setHeight(10),
          ),
          InkWell(
            onTap: () => toggleViewMore(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: viewMore == true
                      ? widget.restaurant.description
                      : "${widget.restaurant.description.substring(0, widget.restaurant.description.length ~/ 2)}...",
                  style: styleSubtitle.copyWith(
                    fontSize: setFontSize(38),
                    color: isDarkTheme(context) ? Colors.white : blackColor,
                    fontFamily: FontFamily.nunitoSans,
                  ),
                ),
                TextSpan(
                  text: viewMore == false ? "View More" : "",
                  style: styleTitle.copyWith(
                    fontSize: setFontSize(38),
                    color: primaryColor,
                    fontFamily: FontFamily.nunitoSans,
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
