import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../helpers.dart';
import '../../validators/base_validator.dart';

class SelectBox<T> extends StatelessWidget {
  final String name;
  final Map<T, String> items;
  final T value;
  final List<BaseValidator> validators;
  final FormFieldSetter<T> onSaved;

  SelectBox({@required this.name, @required this.items, this.value, this.validators, this.onSaved});

  @override
  Widget build(BuildContext context) {
    FormFieldValidator<T> validator;
    if (this.validators != null) {
      validator = (T value) => validates(context, value, this.name, this.validators);
    }

    return new FormField<T>(
      initialValue: this.value,
      onSaved: this.onSaved,
      validator: validator,
      builder: (FormFieldState<T> field) {
        return new InkWell(
          child: new InputDecorator(
            decoration: new InputDecoration(
              labelText: trans(context, 'attribute.${this.name}'),
              errorText: field.errorText
            ),
            child: field.value != null ? new Text(this.items[field.value]) : null
          ),
          onTap: () {
            showDialog(context: context, builder: (BuildContext context) {
              return new SimpleDialog(
                children: this._listItems(context, field),
              );
            });
          },
        );
      },
    );
  }

  List<Widget> _listItems(BuildContext context, FormFieldState<T> field) {
    List<Widget> children = [];

    this.items.forEach((T item, String label) {
      children.add(new ListTile(
        title: new Text(label),
        onTap: () {
          field.didChange(item);
          Navigator.pop(context);
        },
      ));
    });

    return children;
  }
}