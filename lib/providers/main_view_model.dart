import 'package:flutter/material.dart';
import 'dart:math' as math;

class MainViewModel extends ChangeNotifier {

  int _pageNum = 1;

  List<Item> data = [];


  int get pageNum => _pageNum;

  setPageNum(int value) async {
    _pageNum = value;
    notifyListeners();
  }

  generateData() async {
    data = List.generate(
        200,
        (index) => Item(
              index,
              'Item # ${index + 1}',
              getRandomColor(),
            ),
        growable: false);
    notifyListeners();
  }

  getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }
}

class Item {

  final int index;

  final String text;

  final Color color;

  Item(this.index, this.text, this.color);
}
