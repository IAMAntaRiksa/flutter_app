import 'package:app/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Favorite",
            style: styleTitle.copyWith(
              fontSize: 55,
              color: Colors.white,
            ),
          ),
        ),
        body: const FavoriteBody());
  }
}

class FavoriteBody extends StatelessWidget {
  const FavoriteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Hello word'),
      ],
    );
  }
}
