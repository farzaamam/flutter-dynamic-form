import 'package:flutter_dynamic_form/domain/models/input_content.dart';
import 'package:flutter_dynamic_form/domain/models/input_validations.dart';

enum InputType { text, select, file }

abstract class InputField {
  final String title;
  final bool isRequired;
  final InputType inputType;

  const InputField({
    required this.title,
    required this.isRequired,
    required this.inputType,
  });
}

class TextInputField extends InputField {
  final TextContent content;
  final TextValidation inputValidation;

  TextInputField(
    this.content,
    this.inputValidation, {
    required super.title,
    required super.isRequired,
    required super.inputType,
  });
}

class SelectableInputField extends InputField {
  final SelectableContent content;

  SelectableInputField(
    this.content, {
    required super.title,
    required super.isRequired,
    required super.inputType,
  });
}

class FileInputField extends InputField {
  final FileContent content;
  final FileInputField inputField;

  FileInputField(
    this.content,
    this.inputField, {
    required super.title,
    required super.isRequired,
    required super.inputType,
  });
}
