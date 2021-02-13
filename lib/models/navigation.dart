import 'package:flutter/material.dart';

class NavigationModel {
  final String label;
  final String imageUrl;
  final Widget screen;
  final Function callBack;

  NavigationModel({
    @required this.label,
    @required this.imageUrl,
    this.callBack,
    this.screen,
  });
}
