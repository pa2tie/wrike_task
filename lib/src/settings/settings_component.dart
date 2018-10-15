import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../bill/bill.dart';
import '../bill/bill_service.dart';
import '../routes/route_paths.dart';

@Component(
  selector: 'settings-component',
  templateUrl: 'settings_component.html',
  styleUrls: ['settings_component.css'],
  directives: [coreDirectives, routerDirectives],
)
class SettingsComponent implements OnInit {
  List<Bill> billsStorage;

  final BillService _billService;

  SettingsComponent(this._billService);

  @override
  void ngOnInit() async {
    billsStorage = (await _billService.getAll()).skip(1).take(4).toList();
  }
}