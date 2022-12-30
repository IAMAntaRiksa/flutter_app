class Api {
  /// Base Api Endpoint
  static const _baseServer = "";

  /// * -------------------
  ///  * Restaurants Endpoint
  ///  * ------------------
  ///  * In this field will exists
  ///  * some route about restaurants
  /// */
  String getRestaurants = "$_baseServer/list";
  String getRestaurant = "$_baseServer/detail/:id";
  String searchRestaurant = "$_baseServer/search";
  String createReview = "$_baseServer/review";
}
