import 'dart:async';

import '../config/magic_config.dart';
import '../contracts/auth/guard.dart';
import '../foundation/magic.dart';

class Auth {
  final Magic _magic;
  Guard _guard;

  Auth(this._magic);

  Guard get guard {
    if (this._guard == null) {
      this._guard = this
          .availableGuards[this._magic.make<MagicConfig>().get('auth.default')];
    }

    return this._guard;
  }

  Guard makeGuard(String key) {
    return this.availableGuards[key];
  }

  Map<String, Guard> get availableGuards {
    return this._magic.make<MagicConfig>().get('auth.guards');
  }

  bool check() {
    return this.guard.check();
  }

  bool guest() {
    return !this.check();
  }

  dynamic user() {
    return this.guard.user();
  }

  Future<String> getBearerToken() {
    return this.guard.getBearerToken();
  }
}
