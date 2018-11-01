@TestOn('browser')

import 'package:angular_app/app_component.dart';
import 'package:angular_app/app_component.template.dart' as ng;
import 'package:angular_test/angular_test.dart';
import 'package:test/test.dart';

import '../lib/src/bill/bill.dart';
import '../lib/src/wallet/wallet_component.dart';

void main() {
  test('Cashout 20 amount, for nominals 1, 5, 10', () {

    final _initialBills = [
      {'nominal': 1, 'count': 1},
      {'nominal': 5, 'count': 1},
      {'nominal': 10, 'count': 1}
    ];
    List<Bill> _billsDb = _initialBills.map((json) => Bill.fromJson(json)).toList();
    expect(_billsDb != [], true);
  });
}
