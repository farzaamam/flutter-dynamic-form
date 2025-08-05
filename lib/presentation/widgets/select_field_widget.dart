import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/presentation/direction_helper.dart';

class SelectFieldWidget extends StatelessWidget {
  final SelectableInputField field;
  final void Function(String?)? onChanged;

  const SelectFieldWidget({required this.field, this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getDirection(field.title),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: field.title,
          hintText: field.content.hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
        validator: (v) {
          if (field.isRequired && (v == null || v.isEmpty)) {
            return 'Required';
          }
          return null;
        },
        onChanged: (v) {
          if (onChanged != null) onChanged!(v);
        },
        items:
            field.content.items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item.item,
                    child: Text(item.item),
                  ),
                )
                .toList(),
      ),
    );
  }
}
