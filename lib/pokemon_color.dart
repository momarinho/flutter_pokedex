import 'dart:math';

import 'package:flutter/material.dart';

Color getRandomPokemonBackgroundColor() {
  final random = Random();
  final red = random.nextInt(256);
  final green = random.nextInt(256);
  final blue = random.nextInt(256);
  return Color.fromARGB(195, red, green, blue);
}
