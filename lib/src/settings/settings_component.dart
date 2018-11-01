import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../bill/bill.dart';
import '../bill/bill_component.dart';
import '../bill/bill_service.dart';
import '../routes/route_paths.dart';

@Component(
  selector: 'settings-component',
  templateUrl: 'settings_component.html',
  styleUrls: ['settings_component.css'],
  directives: [coreDirectives, BillComponent],
  pipes: [commonPipes]
)
class SettingsComponent implements OnInit {
  List<Bill> billsStorage;
  Bill selected;
  // final Router _router;
  final BillService _billService;

  SettingsComponent(this._billService);

  Future<void> add(nominal) async {
    nominal = nominal.trim();
    if (nominal.isEmpty) return null;
    nominal = int.parse(nominal);
    billsStorage.add(await _billService.create(nominal));
    selected = null;
  }

  Future<void> delete(Bill bill) async {
    await _billService.delete(bill.nominal);
    billsStorage.remove(bill);
    if (selected == bill) selected = null;
  }

  @override
  void ngOnInit() async {
    billsStorage = (await _billService.getAll()).toList();
  }

  void onSelect(Bill bill) => selected = bill;
}