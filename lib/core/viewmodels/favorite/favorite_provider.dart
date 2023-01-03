import 'package:app/core/untils/favorite/favorite_untils.dart';
import 'package:app/injector.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  ///=========================
  /// Property Sections
  ///=========================

  /// List of restaurants favorite id
  List<String>? _favorites;
  List<String>? get favorites => _favorites;

  /// Property to check mounted before notify
  bool isDisposed = false;

  /// Event handling
  bool _onSearch = false;
  bool get onSearch => _onSearch;

  /// Dependency injection
  final favoriteUtils = locator<FavoriteUtils>();

  ///=========================
  /// Function Logic Sections
  ///=========================

  /// Instance provider
  static FavoriteProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  Future<void> getFavorites() async {
    await Future.delayed(Duration(microseconds: 100));
    setOnSearch(true);
    _favorites = await favoriteUtils.getFavorites();
    setOnSearch(false);
  }

  Future<void> toggleFavorite(String id) async {
    if (isFavorite(id) == false) {
      favoriteUtils.addFavorite(id);
    } else {
      favoriteUtils.removeFavorite(id);
    }
    getFavorites();
  }

  bool isFavorite(String id) => _favorites!.contains(id);

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
