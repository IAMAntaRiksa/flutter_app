import 'package:app/core/viewmodels/connection/connection_provider.dart';
import 'package:app/core/viewmodels/favorite/favorite_provider.dart';
import 'package:app/core/viewmodels/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class GlobalProviders {
  /// Register your provider here
  static Future register() async => [
        ChangeNotifierProvider(create: (context) => ConnectionProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ];
}
