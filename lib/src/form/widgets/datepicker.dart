import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../helpers.dart';
import '../../validators/base_validator.dart';

class DatePicker extends StatelessWidget {
  final String name;
  final DateTime value;
  final DateTime startDate;
  final DateTime endDate;
  final DateFormat format;
  final List<BaseValidator> validators;
  final FormFieldSetter<DateTime> onSaved;

  DatePicker({
    @required this.name,
    this.value,
    this.startDate,
    this.endDate,
    this.format,
    this.validators,
    this.onSaved
  });

  @override
  Widget build(BuildContext context) {
    FormFieldValidator<DateTime> validator;
    if (this.validators != null) {
      validator = (DateTime value) => validates(context, value, this.name, this.validators);
    }

    return new FormField<DateTime>(
      initialValue: this.value,
      onSaved: this.onSaved,
      validator: validator,
      builder: (FormFieldState<DateTime> field) {
        return new InkWell(
          child: new InputDecorator(
            decoration: new InputDecoration(
              labelText: trans(context, 'attribute.${this.name}'),
              errorText: field.errorText
            ),
            child: this._getValueText(field.value)
          ),
          onTap: () async {
            DateTime value = await showDatePicker(
              context: context,
              initialDate: field.value,
              firstDate: this.startDate,
              lastDate: this.endDate
            );

            if (value != null) {
              field.didChange(value);
            }
          },
        );
      },
    );
  }

  Text _getValueText(DateTime value) {
    if (value == null) {
      return null;
    }

    return new Text(
      this.format != null ? this.format.format(value) : value.toString()
    );
  }
}