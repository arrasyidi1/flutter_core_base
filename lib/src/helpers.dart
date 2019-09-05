import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:progress_hud/progress_hud.dart';

import 'api/api_client.dart';
import 'auth/auth.dart';
import 'config/magic_config.dart';
import 'contracts/auth/guard.dart';
import 'data/base_data_receiver.dart';
import 'foundation/magic.dart';
import 'lang/lang.dart';
import 'validators/base_validator.dart';
import 'data/model.dart';

typedef dynamic FetchModelMapCallback(dynamic data);

/// The cache keys.
final authUserCacheKey = 'auth.user';
final authBearerTokenCacheKey = 'auth.token';

/// The loader is showing?
bool _loaderShowing = false;

/// Resolve the given type from the magic.
T make<T>() {
  return Magic.getInstance().make<T>();
}

/// Get the specified configuration value.
dynamic config(String key) {
  return make<MagicConfig>().get(key);
}

/// Get the active auth guard.
Guard guard() {
  return make<Auth>().guard;
}

/// Get the active auth instance.
Auth auth() {
  return make<Auth>();
}

/// Get the current user model.
Model user() {
  if (auth().check()) {
    return auth().user();
  }

  return null;
}

/// Get the base data receiver instance.
BaseDataReceiver dataReceiver() {
  return make<BaseDataReceiver>();
}

/// Get the current api client instance.
ApiClient apiClient() {
  return make<ApiClient>();
}

/// Fetch the models by the given queries.
Future<List<T>> fetchModels<T>(FetchModelMapCallback mapCallback,
  {Map<String, dynamic> queries}) async {
  final List<T> models = new List<T>();

  (await fetchItems(mapCallback(null).resourceKey(), queries: queries))
    .forEach((dynamic data) {
    models.add(
      mapCallback(data)
    );
  });

  return models;
}

/// Fetch the data from the given resource key.
Future<List<dynamic>> fetchItems(String resourceKey,
  {Map<String, dynamic> queries}) async {
  return await dataReceiver().index(resourceKey, queries: queries);
}

/// Translate the given key from the localization
String trans(BuildContext context, String key, {Map<String, String> replaces}) {
  return Lang.of(context).trans(key, replaces: replaces);
}

/// Let's validate!
String validates(BuildContext context, Object value, String attribute,
  List<BaseValidator> validators) {
  String result;

  validators.takeWhile((BaseValidator validator) {
    return result == null;
  }).forEach((BaseValidator validator) {
    result = validator.validate(context, value, attribute);
  });

  return result;
}

/// Get instance of the secure storage.
FlutterSecureStorage secureStorage() {
  return make<FlutterSecureStorage>();
}

/// Get instance of the router.
Router router() {
  return make<Router>();
}

/// Get cache variable.
Future<String> cache(String key) {
  return secureStorage().read(key: key);
}

/// Set cache variable.
Future<void> cacheSet(String key, String value) {
  return secureStorage().write(key: key, value: value);
}

/// Delete cache variable.
Future<void> cacheDelete(String key) {
  return secureStorage().delete(key: key);
}

/// Let's start to show the loader
void showLoader(BuildContext context) {
  _loaderShowing = true;

  showDialog(context: context,
    builder: (BuildContext context) => getLoaderWidget(context));
}

/// Get the loader widget
Widget getLoaderWidget(BuildContext context, {bool withScaffold: false}) {
  if (withScaffold) {
    return new Scaffold(
      body: getLoaderWidget(context),
    );
  }

  return new ProgressHUD(
    color: Colors.white,
    containerColor: Theme
      .of(context)
      .primaryColor,
  );
}

/// Hide the loader.
void hideLoader(BuildContext context) {
  if (_loaderShowing) {
    _loaderShowing = false;

    Navigator.pop(context);
  }
}

// Show snackBar
void showSnackBar(BuildContext context, Widget title,
  {Widget content, List<Widget> actions}) {
  showDialog(context: context, builder: (BuildContext context) =>
  new AlertDialog(
    title: title,
    content: content,
    actions: actions,
  )
  );
}

/// Show error
void showError(BuildContext context,
  String content,
  {
    WidgetBuilder onClicked
  }) {
  hideLoader(context);

  showResultAlert(
    context,
    trans(context, 'error'),
    content,
    Theme
      .of(context)
      .errorColor,
    onClicked: onClicked
  );
}


/// Show error
void showSuccess(BuildContext context,
  String content,
  {
    WidgetBuilder onClicked
  }) {
  hideLoader(context);

  showResultAlert(
    context,
    trans(context, 'success'),
    content,
    Theme
      .of(context)
      .primaryColor,
    onClicked: onClicked
  );
}

/// Show result alert
void showResultAlert(BuildContext context,
  String title,
  String content,
  Color color,
  {
    WidgetBuilder onClicked
  }) {
  hideLoader(context);

  showSnackBar(
    context,
    new Text(
      title,
      style: new TextStyle(color: color),
    ),
    content: new SingleChildScrollView(
      child: new Text(content)
    ),
    actions: <Widget>[
      new FlatButton(
        child: new Text(
          Lang.of(context).trans('ok'),
          style: new TextStyle(
            color: Colors.white
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();

          if (onClicked != null) {
            onClicked(context);
          }
        },
        color: color,
      ),
    ]
  );
}

/// Pop all routes and replace
void replaceTo(BuildContext context, String routeName,
  {TransitionType transition = TransitionType.native}) {
  while (Navigator.of(context).canPop()) {
    Navigator.pop(context);
  }

  router().navigateTo(
    context, routeName, replace: true, transition: transition);
}

/// Redirect to current page
void redirectTo(BuildContext context, String routeName,
  {TransitionType transition = TransitionType.native}) {
  router().navigateTo(
    context, routeName, replace: false, transition: transition);
}