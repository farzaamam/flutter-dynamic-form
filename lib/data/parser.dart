import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/domain/models/input_content.dart';
import 'package:flutter_dynamic_form/domain/models/input_validations.dart';

class FormParser {
  List<InputField> parseFromJsonString(String jsonStr) {
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    return parseFromMap(decoded);
  }

  List<InputField> parseFromMap(Map<String, dynamic> map) {
    final fieldsJson = (map['fields'] as List<dynamic>?) ?? [];
    final List<InputField> fields = [];

    for (final raw in fieldsJson) {
      if (raw is! Map<String, dynamic>) continue;
      try {
        final field = _parseField(raw);
        fields.add(field);
      } catch (e, st) {
        debugPrint('Failed to parse field: $e\n$st');
      }
    }

    return fields;
  }

  InputField _parseField(Map<String, dynamic> field) {
    final type = (field['type'] as String?)?.toLowerCase() ?? '';
    final isRequired = field['isRequired'] as bool? ?? false;
    final id = field['id'] as int? ?? 0;
    final title = field['title'] as String? ?? '';
    final contentMap = (field['content'] as Map<String, dynamic>?) ?? {};
    final validationMap = (field['validation'] as Map<String, dynamic>?) ?? {};

    switch (type) {
      case 'text':
        return _createTextInputField(
          id: id,
          title: title,
          isRequired: isRequired,
          contentMap: contentMap,
          validationMap: validationMap,
        );
      case 'select':
        return _createSelectableInputField(
          id: id,
          title: title,
          isRequired: isRequired,
          contentMap: contentMap,
        );
      case 'file':
        return _createFileInputField(
          id: id,
          title: title,
          isRequired: isRequired,
          contentMap: contentMap,
          validationMap: validationMap,
        );
      default:
        throw Exception('Unsupported field type: $type');
    }
  }

  TextInputField _createTextInputField({
    required int id,
    required String title,
    required bool isRequired,
    required Map<String, dynamic> contentMap,
    required Map<String, dynamic> validationMap,
  }) {
    final hint = contentMap['hint'] as String;
    final int? minLen =
        validationMap['minLen'] != null
            ? (validationMap['minLen'] as num).toInt()
            : null;
    final int? maxLen =
        validationMap['maxLen'] != null
            ? (validationMap['maxLen'] as num).toInt()
            : null;
    final rawType = (validationMap['type'] as String) ;
    final validationType = _mapTextValidationType(rawType);

    return TextInputField(
      TextContent(hint: hint),
      TextValidation(minLen, maxLen, validationType),
      id: id,
      title: title,
      isRequired: isRequired,
    );
  }

  SelectableInputField _createSelectableInputField({
    required int id,
    required String title,
    required bool isRequired,
    required Map<String, dynamic> contentMap,
  }) {
    final hint = contentMap['hint'] as String;
    final itemsRaw = (contentMap['items'] as List<dynamic>) ;

    final items =
        itemsRaw.whereType<Map<String, dynamic>>().map((it) {
          final itemId = it['id'] as int;
          final label = it['label'] as String;
          return SelectableItem(id: itemId, item: label);
        }).toList();

    return SelectableInputField(
      SelectableContent(items, hint: hint),
      id: id,
      title: title,
      isRequired: isRequired,
    );
  }

  FileInputField _createFileInputField({
    required int id,
    required String title,
    required bool isRequired,
    required Map<String, dynamic> contentMap,
    required Map<String, dynamic> validationMap,
  }) {
    final hint = contentMap['hint'] as String;
    final double maxSize =
        validationMap['maxSizeMB'] != null
            ? (validationMap['maxSizeMB'] as num).toDouble()
            : 0.0;

    return FileInputField(
      FileContent(hint: hint),
      FileValidation(maxSize: maxSize),
      id: id,
      title: title,
      isRequired: isRequired,
    );
  }

  TextInputValidationType _mapTextValidationType(String raw) {
    switch (raw.toLowerCase()) {
      case 'number':
        return TextInputValidationType.number;
      case 'email':
        return TextInputValidationType.email;
      case 'phone':
        return TextInputValidationType.phone;
      default:
        return TextInputValidationType.plain;
    }
  }
}
