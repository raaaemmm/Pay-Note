import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShowLoadingScreen extends StatelessWidget {
  const ShowLoadingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).primaryColor,
          highlightColor: Colors.pink,
          child: Image.asset(
            'images/Money.png',
            height: 120.0,
            width: 120.0,
          ),
        ),
      ),
    );
  }
}