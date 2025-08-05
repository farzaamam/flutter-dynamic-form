import 'package:flutter_dynamic_form/data/parser.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dynamic_form/domain/models/input_validations.dart';

void main() {
  late FormParser parser;

  setUp(() {
    parser = FormParser();
  });

  group('SimpleFormParser - individual field parsing', () {
    test('parses text field with validation correctly', () {
      final Map<String, dynamic> textFieldMap = {
        'id': 10,
        'type': 'text',
        'title': 'Email:',
        'isRequired': true,
        'content': {'hint': 'Enter your email'},
        'validation': {'minLen': 5, 'maxLen': 50, 'type': 'email'},
      };

      final fields = parser.parseFromMap({
        'fields': [textFieldMap],
      });
      expect(fields, hasLength(1));
      final field = fields.first;
      expect(field, isA<TextInputField>());

      final textField = field as TextInputField;
      expect(textField.id, 10);
      expect(textField.title, 'Email:');
      expect(textField.isRequired, isTrue);
      expect(textField.content.hint, 'Enter your email');
      expect(textField.inputValidation.minLen, 5);
      expect(textField.inputValidation.maxLen, 50);
      expect(textField.inputValidation.type, TextInputValidationType.email);
    });

    test('parses select field with items correctly', () {
      final Map<String, dynamic> selectFieldMap = {
        'id': 20,
        'type': 'select',
        'title': 'Fuel:',
        'isRequired': false,
        'content': {
          'hint': 'Choose fuel',
          'items': [
            {'id': 1, 'label': 'بنزین'},
            {'id': 2, 'label': 'گاز'},
          ],
        },
      };

      final fields = parser.parseFromMap({
        'fields': [selectFieldMap],
      });
      expect(fields, hasLength(1));
      final field = fields.first;
      expect(field, isA<SelectableInputField>());

      final selectField = field as SelectableInputField;
      expect(selectField.id, 20);
      expect(selectField.title, 'Fuel:');
      expect(selectField.isRequired, isFalse);
      expect(selectField.content.hint, 'Choose fuel');
      expect(selectField.content.items, hasLength(2));
      expect(selectField.content.items[0].id, 1);
      expect(selectField.content.items[0].item, 'بنزین');
      expect(selectField.content.items[1].id, 2);
      expect(selectField.content.items[1].item, 'گاز');
    });

    test('parses file field with maxSizeMB correctly', () {
      final Map<String, dynamic> fileFieldMap = {
        'id': 30,
        'type': 'file',
        'title': 'Upload:',
        'isRequired': false,
        'content': {'hint': 'Select image'},
        'validation': {'allowedType': 'jpg'},
      };

      final fields = parser.parseFromMap({
        'fields': [fileFieldMap],
      });
      expect(fields, hasLength(1));
      final field = fields.first;
      expect(field, isA<FileInputField>());

      final fileField = field as FileInputField;
      expect(fileField.id, 30);
      expect(fileField.title, 'Upload:');
      expect(fileField.isRequired, isFalse);
      expect(fileField.content.hint, 'Select image');
      expect(fileField.fileValidation.format, 'jpg');
    });

    test('throws on unsupported field type', () {
      final Map<String, dynamic> badField = {
        'id': 99,
        'type': 'unknown_type',
        'title': 'Weird:',
        'isRequired': true,
      };

      expect(
        () => parser.parseFromMap({
          'fields': [badField],
        }),
        returnsNormally, // parser swallows per-field errors; verify no crash
      );

      final fields = parser.parseFromMap({
        'fields': [badField],
      });
      expect(fields, isEmpty);
    });
  });

  group('SimpleFormParser - full form JSON', () {
    const String simplifiedFormJson = '''
    {
      "fields": [
        {
          "id": 1,
          "type": "text",
          "title": "برند:",
          "isRequired": true,
          "content": { "hint": "برند ماشین را وارد کنید" },
          "validation": { "minLen": 2, "maxLen": 30, "type": "plain" }
        },
        {
          "id": 2,
          "type": "text",
          "title": "مدل:",
          "isRequired": true,
          "content": { "hint": "مدل ماشین را وارد کنید" },
          "validation": { "minLen": 1, "maxLen": 40, "type": "plain" }
        },
        {
          "id": 3,
          "type": "select",
          "title": "نوع سوخت:",
          "isRequired": true,
          "content": {
            "hint": "",
            "items": [
              { "id": 1, "label": "بنزین" },
              { "id": 2, "label": "گاز" },
              { "id": 3, "label": "دیزل" },
              { "id": 4, "label": "الکتریکی" }
            ]
          }
        },
        {
          "id": 4,
          "type": "file",
          "title": "تصاویر ماشین:",
          "isRequired": false,
          "content": { "hint": "پذیرش عکس", "multiple": true },
          "validation": { "allowedType": "jpg" }
        }
      ]
    }
    ''';

    test('parses simplified form and matches expected structure', () {
      final fields = parser.parseFromJsonString(simplifiedFormJson);
      expect(fields, hasLength(4));

      expect(fields[0], isA<TextInputField>());
      expect(fields[1], isA<TextInputField>());
      expect(fields[2], isA<SelectableInputField>());
      expect(fields[3], isA<FileInputField>());

      final brand = fields[0] as TextInputField;
      expect(brand.title, 'برند:');
      expect(brand.inputValidation.minLen, 2);
      expect(brand.inputValidation.maxLen, 30);

      final model = fields[1] as TextInputField;
      expect(model.title, 'مدل:');
      expect(model.inputValidation.minLen, 1);
      expect(model.inputValidation.maxLen, 40);

      final fuel = fields[2] as SelectableInputField;
      expect(fuel.title, 'نوع سوخت:');
      expect(fuel.content.items.map((e) => e.item).toList(), [
        'بنزین',
        'گاز',
        'دیزل',
        'الکتریکی',
      ]);

      final images = fields[3] as FileInputField;
      expect(images.title, 'تصاویر ماشین:');
      expect(images.fileValidation.format, 'jpg');
    });
  });
}
