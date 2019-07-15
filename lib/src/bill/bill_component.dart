import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'bill.dart';
import 'bill_service.dart';
import '../routes/route_paths.dart';

@Component(
  selector: 'bill-component',
  templateUrl: 'bill_component.html',
  styleUrls: ['bill_component.css'],
  directives: [coreDirectives, formDirectives],
)
class BillComponent implements OnActivate {
  Bill bill;
  final BillService _billService;
  final Location _location;

  BillComponent(this._billService, this._location);

  @override
  void onActivate(_, RouterState current) async {
    final nominal = getNominal(current.parameters);
    if (nominal != null) bill = await (_billService.get(nominal));
  }

  Future<void> save() async {
    await _billService.update(bill);
    goBack();
  }

  void goBack() => _location.back();
}