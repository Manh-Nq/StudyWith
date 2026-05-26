import 'package:flutter/material.dart';

import 'kid_friendly_colors.dart';

/// Màu nền / AppBar theo [Theme.of] (sáng hoặc tối).
extension KidFriendlyAdaptive on BuildContext {
  Brightness get _brightness => Theme.of(this).brightness;

  Color kidScreenBackground(Color lightTint, {double amount = 0.55}) {
    return KidFriendlyColors.screenBackground(
      lightTint,
      brightness: _brightness,
      amount: amount,
    );
  }

  Color kidBarBackground(Color lightTint) {
    return KidFriendlyColors.barBackground(lightTint, brightness: _brightness);
  }

  Color kidTintSurface(Color lightTint, {double amount = 0.92}) {
    return KidFriendlyColors.tintSurface(
      lightTint,
      brightness: _brightness,
      amount: amount,
    );
  }

  Color kidSubjectCardBackground(Color lightTint) {
    return KidFriendlyColors.subjectCardBackground(
      lightTint,
      brightness: _brightness,
    );
  }
}
