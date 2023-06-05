import 'package:flutter/material.dart';

class AppLifecycleViewModel extends ChangeNotifier {


  AppLifecycleState _appState = AppLifecycleState.detached;





  AppLifecycleState get appState => _appState;

  set appState(AppLifecycleState value) {
    _appState = value;
    notifyListeners();
  }


}