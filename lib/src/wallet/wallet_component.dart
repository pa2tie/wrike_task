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
    {'n': 1, 'c': 1},
    {'n': 5, 'c': 1},
    {'n': 10, 'c': 1}
  ];

  var capacity = 10;

  dynamic cashout(bills, capacity) {

    List<dynamic> memo = [];

    getLast() {
      var lastRow = memo[memo.length - 1];
      return lastRow[lastRow - 1];
    }

    getSolution(row, cap) {
      print('getSol: ');
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



      var lastCount = lastSolution['count'];
      var lastSubCount = lastSubSolution['count'];
      var lastCurrentRowCount = lastSolutionCurrentRow['count'];

      var lastAmount = lastSolution['amount'];
      var lastSubAmount = lastSubSolution['amount'];
      var lastCurrentRowAmount = lastSolutionCurrentRow['amount'];
      
      var newCount = lastSubCount + lastItem['c'];
      var newCurrentRowCount = lastCurrentRowCount + lastItem['c'];
      
      var newAmount = lastSubAmount + lastItem['n'];
      var newCurrentRowAmount = lastCurrentRowAmount + lastItem['n'];

      List<dynamic> lastSolutions = [lastSubSolution, lastSolutionCurrentRow];
      lastSolutions.sort((a, b) {
        if (a['subset'].length == b['subset'].length) {
          return (a['count'] < b['count']) ? -1 : 1;
        } else {
          return (a['subset'].length > b['subset'].length) ? -1 : 1;
        }
      });

      lastSolutions = lastSolutions.where((a) => a['n'] == cap).toList();

      
      if (newAmount == cap) {
        var _lastSubSet = List.of(lastSubSolution['subset'].map((el) => new Map.from(el)));
        var subset = _lastSubSet.length > 0 ? _lastSubSet.firstWhere((el) => el['n'] == lastItem['n'], orElse: () => []) : _lastSubSet;

        if (subset.length > 0) {
          subset['c']++;
          return { 'amount': newAmount, 'count': newCount, 'subset': _lastSubSet};
        } else {
          _lastSubSet.add(new Map.from(lastItem));
          return { 'amount': newAmount, 'count': newCount, 'subset': _lastSubSet};
        }

      } else if (newCurrentRowAmount == cap) {
        var _lastCurRowSet = List.of(lastSolutionCurrentRow['subset'].map((el) => new Map.from(el)));
        var subset = _lastCurRowSet.length > 0 ? _lastCurRowSet.firstWhere((el) => el['n'] == lastItem['n'], orElse: () => {}) : _lastCurRowSet;

        if (subset.length > 0) {
          subset['c']++;
          return { 'amount': newCurrentRowAmount, 'count': newCurrentRowCount, 'subset': _lastCurRowSet};
        } else {
          _lastCurRowSet.add(new Map.from(lastItem));
          return { 'amount': newCurrentRowAmount, 'count': newCurrentRowCount, 'subset': _lastCurRowSet};
        }

      } else {
        return lastSolution;
      }

    }

    for(var i = 0; i < bills.length; i++) {
      List<dynamic> row = [];
      memo.add(row);
      for(var cap = 1; cap <= capacity; cap++) {
        memo[i].add(getSolution(i, cap));
        print(memo[i][cap - 1]);
      }
    }

    print(memo[0]);
    return memo;
    
  }

  @override
  void ngOnInit() async {
    storageBills = (await _billService.getAll()).toList();
  }


}