import 'dart:io';

import 'package:flutter/cupertino.dart';

class Plant {
  String name;
  Duration wateringInterval;
  File image;

  Plant(String name, Duration wateringInterval, File image) {
    this.name = name;
    this.wateringInterval = wateringInterval;
    this.image = image;
  }
}
