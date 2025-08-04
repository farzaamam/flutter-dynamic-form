import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/domain/models/input_validations.dart';

class TextFieldWidget extends StatefulWidget {
  final TextInputField field;
  final void Function(String?) onSaved;

  const TextFieldWidget({
    required this.field,
    required this.onSaved,
    super.key,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  TextInputType _getKeyboardType() {
    switch (widget.field.inputValidation.type) {
      case TextInputValidationType.number:
        return TextInputType.number;
      case TextInputValidationType.email:
        return TextInputType.emailAddress;
      case TextInputValidationType.phone:
        return TextInputType.phone;
      case TextInputValidationType.plain:
        return TextInputType.text;
    }
  }

  String? _validator(String? rawValue) {
    final value = rawValue?.trim() ?? '';
    final validation = widget.field.inputValidation;

    if (widget.field.isRequired && value.isEmpty) {
      return 'Required';
    }
    if (validation.minLen != null && value.length < validation.minLen!) {
      return 'Minimum length is ${validation.minLen}';
    }
    if (validation.maxLen != null && value.length > validation.maxLen!) {
      return 'Maximum length is ${validation.maxLen}';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.field.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.field.content.hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          keyboardType: _getKeyboardType(),
          validator: _validator,
          onChanged: (text) => widget.onSaved(_controller.text),
          onSaved: (_) => widget.onSaved(_controller.text),
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
