import 'package:app/core/viewmodels/theme/theme_provider.dart';
import 'package:app/global_providers.dart';
import 'package:app/injector.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/constant/themes.dart';
import 'package:app/ui/router/route_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/untils/navigation/navigation_untlis.dart';
import 'ui/router/router_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup injector
  await setupLocator();

  /// Registering global providers
  var providers = await GlobalProviders.register();

  /// Initialize screenutil
  await ScreenUtil.ensureScreenSize();

  runApp(MyApp(
    providers: providers,
  ));
}

class MyApp extends StatefulWidget {
  final List<dynamic> providers;

  const MyApp({
    super.key,
    required this.providers,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: widget.providers as List<SingleChildWidget>,
      child: Consumer<ThemeProvider>(builder: (context, themeProv, _) {
        var isDarkTheme = themeProv.theme ?? false;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Welcome App',
          navigatorKey: locator<NavigationUtils>().navigatorKey,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          builder: (ctx, child) {
            setupScreenUtil(ctx);
            return MediaQuery(
              data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1.0),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: child!,
              ),
            );
          },
          initialRoute: routeSplash,
          onGenerateRoute: RouterGenerator.generate,
        );
      }),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
