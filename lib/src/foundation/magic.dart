import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/magic_config.dart';
import '../contracts/support/service_provider.dart';
import '../lang/lang_delegate.dart';
import '../routing/base_routes.dart';

typedef Object MagicConcreteCallback(Magic magic);

class Magic {
  /// The current globally available magic (if any).
  static Magic _instance;

  /// Set the globally available instance of the magic.
  static Magic getInstance() {
    if (Magic._instance == null) {
      Magic._instance = new Magic();
    }

    return _instance;
  }

  /// The magic's bindings.
  Map<Type, Object> _bindings = new Map<Type, Object>();

  /// Current magic's environment.
  String _environment = 'local';

  /// All of the registered service providers.
  List<ServiceProvider> _serviceProviders = new List<ServiceProvider>();

  /// Indicates if the magic has "booted".
  bool _booted = false;

  /// Create a new magic application instance.
  Magic() {
    // Set the instance
    Magic._instance = this;

    this._registerCoreBindings();
  }

  /// Register a shared binding in the magic.
  void singleton<T>(MagicConcreteCallback concrete) {
    this._bindings[T] = concrete(this);
  }

  /// Resolve the given type from the magic.
  T make<T>() {
    return this._bindings[T];
  }

  /// Get or check the current application environment.
  String environment() {
    return this._environment;
  }

  /// Register a service provider with the application.
  void register(ServiceProvider serviceProvider) {
    serviceProvider.register(this);

    if (this._booted) {
      this._bootRegisterProvider(serviceProvider);
    }

    this._serviceProviders.add(serviceProvider);
  }

  /// Boot the magic's service providers.
  Future<void> boot({Map<String, dynamic> config, Map<String, dynamic> environment}) async {
    if (this._booted) {
      return new Future.value();
    }

    // Set the configurations of app
    config.forEach((String key, dynamic value) => this._setConfigIfNotNull('app.$key', value));

    // Register the application providers.
    List<ServiceProvider> providers = this.make<MagicConfig>().get('app.providers');
    if (providers != null) {
      providers.forEach((ServiceProvider serviceProvider) => this.register(serviceProvider));
    }

    // Let's set the environment configurations
    if (environment != null) {
      environment.forEach((String key, dynamic value) => this._setConfigIfNotNull(key, value));
    }

    // Set application environment from config
    setEnvironment(this.make<MagicConfig>().get('app.env'));

    // Set the routes
    List<BaseRoutes> routes = this.make<MagicConfig>().get('route.routes');
    if (routes != null) {
      this.registerRoutes(routes);
    }

    // Boot the registered providers.
    for (ServiceProvider serviceProvider in this._serviceProviders) {
      await this._bootRegisterProvider(serviceProvider);
    }

    // Set application orientations
    SystemChrome.setPreferredOrientations(this.make<MagicConfig>().get('app.orientations'));

    // Run the app!
    runApp(new MaterialApp(
        title: this.make<MagicConfig>().get('app.name'),
        locale: this.make<MagicConfig>().get('app.locale'),
        onGenerateRoute: this.make<Router>().generator,
        supportedLocales: this.make<MagicConfig>().get('app.supportedLocales'),
        localeResolutionCallback: this._localizationCallback,
        theme: this.make<MagicConfig>().get('app.theme'),
        localizationsDelegates: [
          const LangDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ]));
  }

  /// Set the magic's environment.
  void setEnvironment(String environment) {
    _environment = environment;
  }

  /// The helper for router.
  Router get router {
    return this.make<Router>();
  }

  /// Register the base routes.
  void registerRoutes(List<BaseRoutes> routes) {
    routes.forEach((BaseRoutes routes) {
      routes.register(this.router);
    });
  }

  /// Boot the given service provider.
  Future<void> _bootRegisterProvider(ServiceProvider serviceProvider) {
    return serviceProvider.boot(this);
  }

  /// Register the core bindings in the magic.
  void _registerCoreBindings() {
    this.singleton<MagicConfig>((_) => new MagicConfig());
    this.singleton<Router>((_) => new Router());
    this.singleton<FlutterSecureStorage>((_) => new FlutterSecureStorage());
  }

  /// Set the config variable if the value is not null.
  void _setConfigIfNotNull(String key, dynamic value) {
    if (value != null) {
      this.make<MagicConfig>().set(key, value);
    }
  }

  /// Localization callback for application
  Locale _localizationCallback(Locale locale,
      Iterable<Locale> supportedLocales) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode ||
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }

    return supportedLocales.first;
  }
}
