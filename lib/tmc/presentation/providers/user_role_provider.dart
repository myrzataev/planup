import 'package:flutter/material.dart';

class GetUserRoleProvider extends ChangeNotifier {
  bool? isAdmin;
  void changeRole(String? role) {
    if (role == null || role == "Заведующий склада") {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    notifyListeners();
  }
}
