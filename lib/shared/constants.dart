import 'package:flutter/material.dart';
import 'package:tag_n_go/resources/app_colors.dart';

const textInputDecoration = InputDecoration(
    fillColor: AppColors.color1,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.color5, width: 4.0),
    ),
    errorStyle: TextStyle(color: AppColors.color3),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.color3, width: 4.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 6.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 6.0)));
