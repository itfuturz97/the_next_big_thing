import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Decoration decoration = Decoration();

class Decoration {
  ColorScheme get colorScheme => Theme.of(Get.context!).colorScheme;

  Color selectionColor(BuildContext context) => colorScheme.secondaryContainer;

  Color selectionBorderColor(BuildContext context) => colorScheme.onSecondaryContainer;

  BorderRadius allBorderRadius(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  BorderRadius singleBorderRadius(List selectedSide, double radius) {
    List top = [1], right = [2], left = [3], bottom = [4];
    List topLR = [1, 2], topLBottomR = [1, 3], bottomLR = [3, 4], topRBottomR = [2, 4];
    List ignoreTopL = [2, 3, 4], ignoreTopR = [1, 3, 4];
    if (listEquals(selectedSide, top)) {
      selectedSide = [1, null, null, null];
    } else if (listEquals(selectedSide, right)) {
      selectedSide = [null, 2, null, null];
    } else if (listEquals(selectedSide, left)) {
      selectedSide = [null, null, 3, null];
    } else if (listEquals(selectedSide, bottom)) {
      selectedSide = [null, null, null, 4];
    } else if (listEquals(selectedSide, topLR)) {
      selectedSide = [1, 2, null, null];
    } else if (listEquals(selectedSide, bottomLR)) {
      selectedSide = [null, null, 3, 4];
    } else if (listEquals(selectedSide, topLBottomR)) {
      selectedSide = [1, null, 3, null];
    } else if (listEquals(selectedSide, topRBottomR)) {
      selectedSide = [null, 2, null, 4];
    } else if (listEquals(selectedSide, ignoreTopL)) {
      selectedSide = [null, 2, 3, 4];
    } else if (listEquals(selectedSide, ignoreTopR)) {
      selectedSide = [1, null, 3, 4];
    }
    return BorderRadius.only(
      topLeft: Radius.circular(selectedSide[0] != null ? radius : 0),
      topRight: Radius.circular(selectedSide[1] != null ? radius : 0),
      bottomLeft: Radius.circular(selectedSide[2] != null ? radius : 0),
      bottomRight: Radius.circular(selectedSide[3] != null ? radius : 0),
    );
  }

  List<Color> get primaryGradientColors => [colorScheme.primaryContainer, colorScheme.primary];

  List<Color> get secondaryGradientColors => [colorScheme.secondaryContainer, colorScheme.secondary];

  List<Color> get deleteGradientColors => [colorScheme.errorContainer, colorScheme.error];

  List<Color> get appliedGradientColors => [colorScheme.tertiaryContainer, colorScheme.tertiary];

  List<Color> get removeGradientColors => [colorScheme.errorContainer, colorScheme.error];

  List<Color> get boxesGradientColors => [colorScheme.surfaceContainer, colorScheme.onSurface];

  RadialGradient commonGradient(List<Color> colors) => RadialGradient(center: const Alignment(0, 4.6), radius: 2.5, colors: colors);

  RadialGradient get primaryGradient => commonGradient(primaryGradientColors);

  RadialGradient get secondaryGradient => commonGradient(secondaryGradientColors);

  RadialGradient get deleteGradient => commonGradient(deleteGradientColors);

  RadialGradient get appliedGradient => commonGradient(appliedGradientColors);

  RadialGradient get removeGradient => commonGradient(removeGradientColors);

  RadialGradient get boxesGradient => commonGradient(boxesGradientColors);

  BoxDecoration splashDecoration() {
    return BoxDecoration(
      gradient: RadialGradient(center: const Alignment(1.00, 1.00), radius: 1.43, colors: [colorScheme.primaryContainer, colorScheme.primary]),
    );
  }

  BoxDecoration scaffoldDecoration() {
    return BoxDecoration(
      gradient: RadialGradient(center: const Alignment(1.00, 1.00), radius: 1.43, colors: [colorScheme.primaryContainer, colorScheme.primary]),
    );
  }
}
