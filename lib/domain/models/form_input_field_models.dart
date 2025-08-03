import 'package:flutter_dynamic_form/domain/models/input_content.dart';
import 'package:flutter_dynamic_form/domain/models/input_validations.dart';

abstract class InputField {
  final int id;
  final String title;
  final bool isRequired;

  const InputField({
    required this.id,
    required this.title,
    required this.isRequired,
  });
}

class TextInputField extends InputField {
  final TextContent content;
  final TextValidation inputValidation;

  TextInputField(
    this.content,
    this.inputValidation, {
    required super.id,
    required super.title,
    required super.isRequired,
  });
}

class SelectableInputField extends InputField {
  final SelectableContent content;

  SelectableInputField(
    this.content, {
    required super.id,
    required super.title,
    required super.isRequired,
  });
}

class FileInputField extends InputField {
  final FileContent content;
  final FileValidation fileValidation;

  FileInputField(
    this.content,
    this.fileValidation, {
    required super.id,
    required super.title,
    required super.isRequired,
  });
}
