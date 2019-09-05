import 'dart:async';

import 'authenticatable.dart';

abstract class Guard {
  /// Determine if the current user is authenticated.
  bool check();

  /// Get the currently authenticated user.
  dynamic user();

  /// Get the ID for the currently authenticated user.
  dynamic id() {
    Authenticatable user = this.user();
    return user?.getAuthIdentifier();
  }

  /// Get the bearer token for using the http requests.
  Future<String> getBearerToken();

  /// Attempt to authenticate a user using the given credentials.
  Future<bool> attempt(Map<String, dynamic> credentials);

  /// Attempt to register a new user using the given credentials.
  Future<bool> register(Map<String, dynamic> credentials);

  /// Log the user out of the application.
  void logout();

  /// Set the current user.
  void setCurrentUser(dynamic data);

  /// Set the bearer token.
  void setBearerToken(String token);
}