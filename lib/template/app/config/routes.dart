import 'package:construct/core.dart';

import '../controllers/home.dart';

Router configureRoutes() {
  var router = Router();
  router.add('/', (_) => HomeController(HtmlView()).index());
  router.add(
      '/hello/:name', (params) => HomeController(HtmlView()).sayHello(params));
  router.add('/json/:member',
      (params) => HomeController(JsonView()).sayHelloJson(params));

  // Add more routes as needed
  return router;
}
