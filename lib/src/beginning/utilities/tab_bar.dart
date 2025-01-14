import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';

List<Tab> tabsData(double width, double? height) {
  double letterspace = width / 250;
  double tabBarFontSize = orientedCar ? width / 18 : height! / 35.5;

  return [
    Tab(
      child: Text(
        "mansion".tr.toUpperCase(),
        style: TextStyle(
          fontSize: tabBarFontSize,
          letterSpacing: letterspace,
          fontFamily: "Raleway",
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Tab(
      child: Text(
        "tracks".tr.toUpperCase(),
        style: TextStyle(
          letterSpacing: letterspace,
          fontSize: tabBarFontSize,
          fontFamily: "Raleway",
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Tab(
      child: Text(
        "albums".tr.toUpperCase(),
        style: TextStyle(
          letterSpacing: letterspace,
          fontSize: tabBarFontSize,
          fontFamily: "Raleway",
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    /*Tab(
      child: Text(
        "ARTISTS",
        style: TextStyle(
          letterSpacing: letterspace,
          fontSize: tabBarFontSize,
          fontFamily: "Raleway",
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Tab(
      child: Text(
        "GENRES",
        style: TextStyle(
          letterSpacing: letterspace,
          fontSize: tabBarFontSize,
          fontFamily: "Raleway",
          fontWeight: FontWeight.w600,
        ),
      ),
    ),*/
    Tab(
      child: Text(
        "playlists".tr.toUpperCase(),
        style: TextStyle(
          letterSpacing: letterspace,
          fontSize: tabBarFontSize,
          fontFamily: "Raleway",
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ];
}
