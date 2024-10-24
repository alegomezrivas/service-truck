import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final int value;
  final double totalSize = 80.0;
  final double outSize = 75.0;
  final double inSize = 65.0;
  final String logo = "assets/logo.png";

  const LoadingWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: totalSize,
        width: totalSize,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: outSize,
                width: outSize,
                child: CircularProgressIndicator(
                  color: Colors.blue[900],
                  value: value / 100.0,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: inSize,
                width: inSize,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(logo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
