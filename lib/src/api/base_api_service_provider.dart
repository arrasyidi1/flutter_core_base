import 'dart:async';

import 'package:magic/src/foundation/magic.dart';

import '../config/magic_config.dart';
import '../contracts/support/service_provider.dart';
import 'api_client.dart';

class BaseApiServiceProvider extends ServiceProvider {
  Map<String, dynamic> config = new Map<String, dynamic>();

  @override
  Future<void> boot(Magic magic) {
    return new Future.value();
  }

  @override
  void register(Magic magic) {
    // Set config
    this.config.forEach((String key, dynamic value) =>
        magic.make<MagicConfig>().set('api.$key', value));

    // Singleton auth instance
    magic.singleton<ApiClient>((Magic magic) => new ApiClient());
  }
}
