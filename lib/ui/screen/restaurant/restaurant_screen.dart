import 'package:app/ui/constant/constant.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Restaurant App",
          style: styleTitle.copyWith(
            fontSize: 55,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
      ),
      body: const RestaurantBody(),
    );
  }
}

class RestaurantBody extends StatelessWidget {
  const RestaurantBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Restaurant'),
      ],
    );
  }
}
