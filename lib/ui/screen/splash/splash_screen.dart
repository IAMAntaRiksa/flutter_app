import 'package:app/core/untils/navigation/navigation_untlis.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/ui/constant/constant.dart';
import 'package:app/ui/router/route_list.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLogo = 0;
  double opacityText = 0;

  void initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opacityLogo = 1;
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      opacityText = 1;
    });

    await Future.delayed(const Duration(seconds: 2));
    navigate.pushToRemoveUntil(routeDashboard);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBar();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: opacityLogo,
              duration: const Duration(milliseconds: 300),
              child: Image.asset(
                Assets.icons.logoRestaurant.path,
                width: deviceWidth * 0.4,
                height: setHeight(400),
                color: primaryColor,
              ),
            ),
            AnimatedOpacity(
              opacity: opacityText,
              duration: const Duration(milliseconds: 300),
              child: Text(
                "Restaurant App",
                style: styleTitle.copyWith(
                  fontSize: setFontSize(60),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
