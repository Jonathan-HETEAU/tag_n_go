import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tag_n_go/resources/app_colors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.color1,
      child: Center(
        child: SpinKitFadingGrid(
          color: AppColors.textPrimary,
          size: 50.0,
        ),
      ),
    );
  }
}
