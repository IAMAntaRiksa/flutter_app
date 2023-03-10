import 'package:app/ui/widget/idle/loading/loading_singlebox.dart';
import 'package:flutter/material.dart';

class LoadingListView extends StatelessWidget {
  final int length;
  final double height;
  const LoadingListView({
    Key? key,
    this.length = 10,
    this.height = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const BouncingScrollPhysics(),
      itemCount: length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: LoadingSingleBox(
            height: height,
          ),
        );
      },
    );
  }
}
