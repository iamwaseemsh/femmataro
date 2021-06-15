import 'package:flutter/material.dart';
class ExploreScreenStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        child: Column(
          children: [
            Center(child: Text("Explore"),)
          ],
        ),
      ),
    ));
  }
}