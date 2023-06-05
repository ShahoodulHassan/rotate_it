import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin GenericFunctions {
  logIfDebug(Object? object) {
    if (kDebugMode) {
      debugPrint('$runtimeType\t$object');
      // dev.log('$object', name: '$runtimeType '
      //   '${getFormattedNow(seconds: true)}'/*, error: '$object'*/);
    }
  }

  /// It is basically used to check if a nullable bool is true or not, in a null
  /// safe way.
  /// It takes in a nullable bool and returns a non-null bool
  bool isNullSafeTrue(bool? aBool) => aBool ?? false;

  /// This method simply finds out the current focus, checks if it has the
  /// primary focus or not:
  /// If no => take the focus away (hide keyboard)
  /// If yes => do nothing because if we call unfocus() when the node has
  /// primary focus, an exception is thrown.
  /// See https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
  void hideKeyboardG(BuildContext context) {
    FocusScopeNode currentNode = FocusScope.of(context);
    if (!currentNode.hasPrimaryFocus) currentNode.unfocus();
  }

  showSnackBar(BuildContext context, String text,
      {String? actionLabel, Function()? onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: actionLabel != null && onPressed != null
            ? SnackBarAction(label: actionLabel, onPressed: onPressed)
            : null,
      ),
    );
  }

  Color getColorFromHexCode(String hexCode) =>
      Color(int.parse(hexCode.replaceFirst('#', '0xFF')));

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  bool get isDebug => kDebugMode;

  int currentTimeMillis() => DateTime.now().millisecondsSinceEpoch;

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }

  // Generic method for all needs
  String applyCommaAndRound(double value, int places, bool applyComma,
      bool trailingZeroes) {
    String formatter = applyComma ? '#,##0' : '##0';
    String trail = trailingZeroes ? '0' : '#';

    if (places < 0) {
      places = 0;
    } else if (places > 0) {
      if (places > 3) places = 3;
      formatter = '$formatter.';
      for (int i = 0; i < places; i++) {
        formatter = '$formatter$trail';
      }
    }

    return NumberFormat(formatter, 'en_US').format(value);
  }

  String durationToMinSec(Duration dur) {
    var splits = dur.toString().split(':');
    String minutes = splits[1].padLeft(2, '0');
    String seconds = splits[2].split('.')[0].padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // No zero values or trailing decimal zeroes
  String applyCommaAndRoundNoZeroes(double value, int places, bool applyComma,
      {String? replacement}) {
    var result = applyCommaAndRound(value, places, applyComma, false);
    return result == '0' ? replacement ?? '-' : result;
  }
}

extension StringCasingExtension on String {
  String toProperCase() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ')
          .split(' ')
          .map((str) => str.toProperCase())
          .join(' ');
}

extension Contextual on BuildContext {
  unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}
