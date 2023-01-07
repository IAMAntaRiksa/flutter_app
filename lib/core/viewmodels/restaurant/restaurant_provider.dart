import 'package:app/core/models/restaurant/restaurant_model.dart';
import 'package:app/core/models/review/create_review_model.dart';
import 'package:app/core/services/restaurant/restaurant_service.dart';
import 'package:app/injector.dart';
import 'package:app/ui/widget/dialog/snackbar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RestaurantProvider extends ChangeNotifier {
  ///=========================
  /// Property Sections
  ///=========================

  /// List of restaurants
  List<RestaurantModel>? _restaurants;
  List<RestaurantModel>? get restaurants => _restaurants;

  /// Detail of restaurant
  RestaurantModel? _restaurant;
  RestaurantModel? get restaurant => _restaurant;

  /// List of search result restaurants
  List<RestaurantModel>? _searchRestaurants;
  List<RestaurantModel>? get searchRestaurants => _searchRestaurants;

  /// List of restaurants by cities
  List<RestaurantModel>? _restaurantsByCity;
  List<RestaurantModel>? get restaurantsByCity => _restaurantsByCity;

  /// List of city
  List<String>? _cities;
  List<String>? get cities => _cities;

  /// Save latest keyword
  String? _latestKeyword;
  String? get latestKeyword => _latestKeyword;

  /// List of favorites restaurant
  List<RestaurantModel>? _restaurantFavorites;
  List<RestaurantModel>? get restaurantFavorites => _restaurantFavorites;

  /// Property to check mounted before notify
  bool isDisposed = false;

  /// Event handling
  bool _onSearch = false;
  bool get onSearch => _onSearch;

  /// Dependency injection
  final restaurantService = locator<RestaurantService>();

  ///=========================
  /// Function Logic Sections
  ///=========================

  /// Instance provider
  static RestaurantProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  /// Finding list of restaurant from API
  Future<void> getRestaurants() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setOnSearch(true);
    try {
      final result = await restaurantService.getRestaurants();
      if (result.error == false) {
        _restaurants = result.data;
      } else {
        _restaurants = [];
      }
    } catch (e, stacktrace) {
      debugPrint("Error: ${e.toString()}");
      debugPrint("Stacktrace: ${stacktrace.toString()}");
      _restaurants = [];
    }
    setOnSearch(false);
  }

  void getRestaurantFavorites(List<String> favoritesId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    setOnSearch(true);
    try {
      if (_restaurants == null) {
        await getRestaurants();
      }
      _restaurantFavorites = [];

      for (var item in _restaurants!) {
        if (favoritesId.contains(item.id)) {
          _restaurantFavorites!.add(item);
        }
      }
    } catch (e) {
      _restaurantFavorites = [];
    }
    setOnSearch(false);
  }

  /// Get detail of restaurant
  void getRestaurant(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    setOnSearch(true);
    try {
      final result = await restaurantService.getRestaurant(id);
      if (result.error == false) {
        _restaurant = result.data;
      } else {
        _restaurant = RestaurantModel.failure();
      }
    } catch (e, stacktrace) {
      debugPrint("Error: ${e.toString()}");
      debugPrint("Stacktrace: ${stacktrace.toString()}");
      _restaurants = [];
    }
    setOnSearch(false);
  }

  void search(String keyword) async {
    _searchRestaurants = null;
    if (keyword.isEmpty) {
      _searchRestaurants = null;
      setOnSearch(false);
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
      setOnSearch(true);
      _latestKeyword = keyword;
      try {
        var result = await restaurantService.searchRestaurants(keyword);
        if (result.error == false) {
          _searchRestaurants = result.data;
        } else {
          _searchRestaurants = [];
        }
      } catch (e) {
        debugPrint("Error: ${e.toString()}");
        _searchRestaurants = [];
      }
      setOnSearch(false);
    }
  }

  /// finding list of restaurants by cities
  void getRestaurantsByCity(String city) async {
    await Future.delayed(const Duration(milliseconds: 100));
    setOnSearch(true);
    await getRestaurants();
    try {
      _restaurantsByCity = _restaurants!
          .where((e) => e.city.toLowerCase() == city.toLowerCase())
          .toList();
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      _restaurantsByCity = [];
    }
    setOnSearch(false);
  }

  /// Finding list of city from local assets
  void getCities() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setOnSearch(true);
    try {
      final result = await restaurantService.getRestaurants();
      if (result.error == false) {
        _cities = result.data?.map((e) => e.city).toSet().toList();
      } else {
        _cities = [];
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      _cities = [];
    }
    setOnSearch(false);
  }

  void createReview(CreateReviewModel data) async {
    try {
      final result = await restaurantService.createReview(data);
      if (result.error == false) {
        _restaurant!.reviews = result.data;
        showSnackbar(
            title: "Successfully create new review", color: Colors.green);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      showSnackbar(
          title: "Failed creating review", color: Colors.red, isError: true);
    }
  }

  void removeFavorite(String id) {
    _restaurantFavorites?.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Set event search
  void setOnSearch(bool value) {
    _onSearch = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
