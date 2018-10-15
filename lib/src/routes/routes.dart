import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import '../wallet/wallet_component.template.dart' as wallet_template;
import '../settings/settings_component.template.dart' as settings_template;

export 'route_paths.dart';

class Routes {
  static final wallet = RouteDefinition(
    routePath: RoutePaths.wallet,
    component: wallet_template.WalletComponentNgFactory,
  );

  static final settings = RouteDefinition(
    routePath: RoutePaths.settings,
    component: settings_template.SettingsComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    wallet,
    settings,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.wallet.toUrl(),
    ),
  ];
}