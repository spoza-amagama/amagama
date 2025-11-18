// 📄 lib/routes/route_helpers.dart
//
// 🧭 Nav — tiny helpers for named routes.
// Keeps Navigator boilerplate out of widgets.
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'app_routes.dart';

class Nav {
  static void toHome(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.home);

  static void toPlay(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.play);

  static void toGrownups(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.grownups);

  static void replaceWithHome(BuildContext context) =>
      Navigator.pushReplacementNamed(context, AppRoutes.home);

  static void back(BuildContext context) => Navigator.pop(context);
}
