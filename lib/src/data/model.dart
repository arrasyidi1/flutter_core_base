import 'dart:async';

import '../helpers.dart';

abstract class Model {
  /// Get the primary key for the model.
  String primaryKey();

  /// The key of the resource for data access.
  String resourceKey();

  /// Indicates if the model exists.
  bool exists = false;

  /// The model's attributes.
  final Map<String, dynamic> _attributes = new Map<String, dynamic>();

  /// The model attribute's original state.
  final Map<String, dynamic> _original = new Map<String, dynamic>();

  /// The attributes that are mass assignable.
  List<String> fillable;

  /// Make the model by the given data.
  Model make(Map<String, dynamic> attributes, {bool exists: true}) {
    if (attributes != null) {
      this._setAttributesAndOriginal(attributes);
      this.exists = exists;
    }

    return this;
  }

  /// Find the model by the given primary key.
  Future<Model> find(String primaryKey) async {
    this.make(await dataReceiver().get(this.resourceKey(), primaryKey));

    return this;
  }

  /// Refresh the current model.
  Future<Model> refresh() async {
    return this.find(this.getPrimaryKey());
  }

  /// Determine if the model or given attribute(s) have been modified.
  bool isDirty() {
    bool isDirty = false;

    this._attributes.forEach((String key, dynamic value) {
      if (!this._original.containsKey(key) || this._original[key] != value) {
        isDirty = true;
      }
    });

    return isDirty;
  }

  /// Get all of the current attributes on the model.
  Map<String, dynamic> getAttributes() {
    return this._attributes;
  }

  /// Get an attribute from the model.
  dynamic get(String key) {
    if (this.has(key)) {
      return this._attributes[key];
    }

    return null;
  }

  /// The given attribute is exists.
  bool has(String key) {
    return this._attributes.containsKey(key);
  }

  /// The given attribute is not exists.
  bool hasNot(String key) {
    return this.has(key) == false;
  }

  /// The given attribute is null or not exists.
  bool isNull(String key) {
    return this.hasNot(key) || this._attributes[key] == null;
  }

  /// The given attribute is not null and exists.
  bool isNotNull(String key) {
    return this.isNull(key) == false;
  }

  /// Set a given attribute on the model.
  Model set(String key, dynamic value) {
    if (this._canFill(key)) {
      this._attributes[key] = value;
    }

    return this;
  }

  /// Set the array of model attributes.
  Model setRaw(Map<String, dynamic> attributes) {
    attributes.forEach((String key, dynamic value) => this.set(key, value));

    return this;
  }

  /// Save the model to the database.
  Future<bool> save() async {
    if (this.isDirty() || !this.exists) {
      Map<String, dynamic> result;

      if (this.exists) {
        result = await dataReceiver().update(
            this.resourceKey(), this.getPrimaryKey().toString(), this._toData);
      } else {
        result = await dataReceiver().create(this.resourceKey(), this._toData);
      }

      this._setAttributesAndOriginal(result);
      return true;
    }

    return new Future.value(false);
  }

  /// Get the value of the model's primary key.
  dynamic getPrimaryKey() {
    return this.get(this.primaryKey());
  }

  /// Set attributes and original values by the given.
  void _setAttributesAndOriginal(Map<String, dynamic> attributes) {
    attributes.forEach((String key, dynamic value) {
      this._attributes[key] = value;
      this._original[key] = value;
    });
  }

  /// The attribute can fill by the method.
  bool _canFill(String key) {
    if (this.fillable != null && this.fillable.contains(key)) {
      return false;
    }

    return true;
  }

  Map<String, dynamic> get _toData {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    this._attributes.forEach((String key, dynamic value) {
      if (value != null) {
        data[key] = value is String ? value : value.toString();
      }
    });

    return data;
  }

  @override
  String toString() {
    return 'Model{resourceKey: ${this.resourceKey()}, exists: $exists, _attributes: $_attributes, _original: $_original}';
  }
}
