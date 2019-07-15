import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/routes/routes.dart';
import 'src/bill/bill_service.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [routerDirectives],
  providers: [ClassProvider(BillService)],
  exports: [RoutePaths, Routes],
)
class AppComponent {
  final title = 'ATM';
}
