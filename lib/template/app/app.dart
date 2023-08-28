import 'package:construct/core.dart';

import 'config/routes.dart';

class App {
  final Router router;

  App() : router = configureRoutes();
}
