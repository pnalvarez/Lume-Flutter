import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

void showAuthSnackBar(
  BuildContext context,
  String message, {
  bool isError = true,
}) {
  final cs = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: typ.body4Light.copyWith(
          color: isError ? cs.onError : cs.onInverseSurface,
        ),
      ),
      backgroundColor: isError ? cs.error : cs.inverseSurface,
    ),
  );
}
