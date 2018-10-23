import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../bill/bill.dart';
import '../bill/bill_service.dart';
import '../routes/route_paths.dart';

@Component(
  selector: 'wallet-component',
  templateUrl: 'wallet_component.html',
  styleUrls: ['wallet_component.css'],
  directives: [coreDirectives, routerDirectives],
)
class WalletComponent implements OnInit {
  Map<int, int> cashoutBills;
  List<Bill> storageBills;
  int sum;
  final BillService _billService;

  WalletComponent(this._billService);

  var bills = [
    {'n': 5, 'c': 1},
    {'n': 10, 'c': 1},
    {'n': 15, 'c': 1}
  ];

  var capacity = 45;

  dynamic cashout(bills, capacity) {

    List<dynamic> memo = [];

    getLast() {
      var lastRow = memo[memo.length - 1];
      return lastRow[lastRow.length - 1];
    }

    getSolution(row, cap) {
      const NO_SOLUTION = {
        'amount': 0,
        'count': 0, 
        'subset': []
      };

      var col = cap - 1;
      var lastItem = bills[row];

      var remaining = cap - lastItem['n'];

      var lastSolution = new Map.from(row > 0 ? (memo[row - 1][col].length > 0 ? memo[row - 1][col] : NO_SOLUTION) : NO_SOLUTION);

      if (remaining < 0) {
        return lastSolution;
      }

      var lastSubSolution = new Map.from(row > 0 ? ((remaining - 1) >= 0 && (remaining - 1) < capacity ? memo[row - 1][remaining - 1] : NO_SOLUTION) : NO_SOLUTION);

      var lastSolutionCurrentRow = new Map.from(row >= 0 ? ((remaining - 1) >= 0 && (remaining - 1) < cap ? memo[row][remaining - 1] : NO_SOLUTION) : NO_SOLUTION);

      List<dynamic> lastSolutions = [lastSubSolution, lastSolutionCurrentRow];
      lastSolutions = lastSolutions.where((a) => (a['amount'] + lastItem['n']) == cap).toList();

      List<dynamic> newLastSolutions = [];

      lastSolutions = lastSolutions.map((a) {
          var _lastSubSet = List.of(a['subset'].map((el) => new Map.from(el)));
          var subset = _lastSubSet.length > 0 ? _lastSubSet.firstWhere((el) => el['n'] == lastItem['n'], orElse: () => []) : _lastSubSet;

          var newAmount = a['amount'] + lastItem['n'];
          var newCount = a['count'] + lastItem['c'];

          if (subset.length > 0) {
            subset['c']++;
            return { 'amount': newAmount, 'count': newCount, 'subset': _lastSubSet};
          } else {
            _lastSubSet.add(new Map.from(lastItem));
            return { 'amount': newAmount, 'count': newCount, 'subset': _lastSubSet};
          }
      }).toList();

      lastSolutions.sort((a, b) {
        if (a['subset'].length == b['subset'].length) {
          return (a['count'] < b['count']) ? -1 : 1;
        } else {
          return (a['subset'].length > b['subset'].length) ? -1 : 1;
        }
      });

      return (lastSolutions.length > 0 ? lastSolutions[0] : lastSolution);

    }

    for(var i = 0; i < bills.length; i++) {
      List<dynamic> row = [];
      memo.add(row);
      for(var cap = 1; cap <= capacity; cap++) {
        memo[i].add(getSolution(i, cap));
        // print(memo[i][cap - 1]);
      }
    }

    print(getLast());
    return getLast();
    
  }

  @override
  void ngOnInit() async {
    storageBills = (await _billService.getAll()).toList();
  }


}