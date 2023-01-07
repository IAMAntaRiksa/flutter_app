import 'package:app/core/untils/global/shared_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ///=========================
  /// Property Sections
  ///=========================

  bool? _theme = false;
  bool? get theme => _theme;

  /// Dependency injection

  ///=========================
  /// Function Logic Sections
  ///=========================

  /// Instance provider

  ThemeProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  void getThemeIsDark() async {
    final shared = SharedManager<bool>();
    final value = await shared.read("theme_dark");
    _theme = value ?? false;
    notifyListeners();
  }

  void setThemeDark(bool value) async {
    final shared = SharedManager<bool>();
    await shared.store("theme_dark", value);
    _theme = value;
    notifyListeners();
  }
}
