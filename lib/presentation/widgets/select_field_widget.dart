import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';

class SelectFieldWidget extends StatelessWidget {
  final SelectableInputField field;
  final void Function(String?)? onChanged;

  const SelectFieldWidget({required this.field, this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: field.title,
        hintText: field.content.hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
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
    );
  }
}
