import 'package:angular_router/angular_router.dart';

const nominalParam = 'nominal';

class RoutePaths {
  static final settings = RoutePath(path: 'settings');
  static final wallet = RoutePath(path: 'wallet');

  static final bill = RoutePath(path: '${settings.path}/:$nominalParam');
}

int getNominal(Map<String, String> parameters) {
  final nominal = parameters[nominalParam];
  return nominal == null ? null : int.tryParse(nominal);
}