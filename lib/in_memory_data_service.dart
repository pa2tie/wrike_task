import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'src/bill/bill.dart';

class InMemoryDataService extends MockClient {
  static final _initialBills = [
    {'nominal': 1, 'count': 1},
    {'nominal': 5, 'count': 1},
    {'nominal': 10, 'count': 1}
  ];
  static List<Bill> _billsDb;

  static Future<Response> _handler(Request request) async {
    if (_billsDb == null) resetDb();
    var data;
    switch (request.method) {
      case 'GET':
        final nominal = int.tryParse(request.url.pathSegments.last);
        if (nominal != null) {
          data = _billsDb
              .firstWhere((bill) => bill.nominal == nominal);
        } else {
          data = _billsDb.toList();
        }
        break;
      case 'POST':
        var nominal = json.decode(request.body)['nominal'];
        if (_billsDb.firstWhere((bill) => bill.nominal == nominal, orElse: () => null) == null) {
          var newBill = Bill(nominal);
          _billsDb.add(newBill);
          data = newBill;
        } else {
          throw 'Nominal already exists';
        }
        break;
      case 'PUT':
        var billChanges = Bill.fromJson(json.decode(request.body));
        var targetBill = _billsDb.firstWhere((b) => b.nominal == billChanges.nominal);
        if(_billsDb.firstWhere((bill) => bill.nominal == billChanges.nominal) == null) {
          targetBill.nominal = billChanges.nominal;
          data = billChanges;
        } else {
          throw 'Nominal already exists';
        }
        break;
      case 'DELETE':
        var nominal = int.parse(request.url.pathSegments.last);
        _billsDb.removeWhere((bill) => bill.nominal == nominal);
        break;
      default:
        throw 'Unimplemented HTTP method ${request.method}';
    }
    return Response(json.encode({'data': data}), 200,
        headers: {'content-type': 'application/json'});
  }

  static resetDb() {
    _billsDb = _initialBills.map((json) => Bill.fromJson(json)).toList();
  }

  static int lookUpNominal(int nominal) =>
      _billsDb.firstWhere((bill) => bill.nominal == nominal, orElse: null)?.nominal;
  
  InMemoryDataService() : super(_handler);
}