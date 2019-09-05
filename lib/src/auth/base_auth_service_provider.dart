import 'dart:async';
import 'dart:convert';

import 'package:magic/src/foundation/magic.dart';

import '../config/magic_config.dart';
import '../contracts/auth/guard.dart';
import '../contracts/support/service_provider.dart';
import '../helpers.dart';
import 'auth.dart';

class BaseAuthServiceProvider extends ServiceProvider {
  Map<String, dynamic> config = new Map<String, dynamic>();

  @override
  Future<void> boot(Magic magic) async {
    dynamic user = await cache(authUserCacheKey);
    String token = await cache(authBearerTokenCacheKey);

    if (user != null && token != null) {
      user = json.decode(user);

      auth().availableGuards.forEach((String key, Guard guard) {
        guard.setCurrentUser(user);
        guard.setBearerToken(token);
      });
    }
  }

  @override
  void register(Magic magic) {
    // Set config
    this.config.forEach((String key, dynamic value) =>
        magic.make<MagicConfig>().set('auth.$key', value));

    // Singleton auth instance
    magic.singleton<Auth>((Magic magic) => new Auth(magic));
  }
}
