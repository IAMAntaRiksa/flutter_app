import 'package:app/core/untils/global/shared_manager.dart';

class FavoriteUtils {
  final _key = "favorites";

  Future<List<String>> getFavorites() async {
    var shared = await SharedManager<List<String>>();
    List<String>? data = await shared.read(_key);
    return data ?? [];
  }

  Future<void> addFavorite(String id) async {
    var shared = await SharedManager<List<String>>();
    var favorite = await getFavorites();
    favorite.add(id);
    await shared.store(_key, favorite);
  }

  Future<void> removeFavorite(String id) async {
    final shared = SharedManager<List<String>>();
    final favorites = await getFavorites();
    favorites.remove(id);
    await shared.store(_key, favorites);
  }
}
