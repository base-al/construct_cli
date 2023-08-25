import 'package:construct/core.dart';

class HomeController extends Controller {
  HomeController(view) : super(view);
  @override
  String index() {
    return view.render('home/index.html'); // Render the index.html view
  }

  String sayHello(Map<String, dynamic> params) {
    return view.render('home/name.html',
        params: params); // Render the index.html view
  }

  String sayHelloJson(Map<String, dynamic> params) {
    return view.render('', params: params); // Render the json view
  }
}
