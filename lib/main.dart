import 'package:app/injector.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/router/route_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/untils/navigation/navigation_untlis.dart';
import 'ui/router/router_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup injector
  await setupLocator();

  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome App',
      navigatorKey: locator<NavigationUtils>().navigatorKey,
      themeMode: ThemeMode.light,
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
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
