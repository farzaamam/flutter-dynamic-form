import 'package:flutter_dynamic_form/domain/form_repository.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/domain/models/input_content.dart';
import 'package:flutter_dynamic_form/domain/models/input_validations.dart';
import 'package:flutter_dynamic_form/presentation/form_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';

import 'form_controller_test.mocks.dart';

@GenerateMocks([FormRepository])
void main() {
  late MockFormRepository mockRepository;
  late FormController controller;

  setUp(() {
    mockRepository = MockFormRepository();
    controller = FormController(mockRepository);
  });

  test('loads forms successfully', () async {
    final mockFields = [
      TextInputField(
        id: 2,
        title: "dwedw",
        isRequired: false,
        TextContent(hint: "asf"),
        TextValidation(1, 3, TextInputValidationType.plain),
      ),
    ];

    when(mockRepository.getForms()).thenAnswer((_) async => mockFields);

    await controller.reload();

    expect(controller.state.fields.hasValue, true);
    expect(controller.state.fields.value, mockFields);
  });

  test('handles load error', () async {
    when(mockRepository.getForms()).thenThrow(Exception('Failed'));

    await controller.reload();

    expect(controller.state.fields.hasError, true);
  });

  test('submit updates isSubmitting state correctly', () async {
    when(mockRepository.getForms()).thenAnswer((_) async => []);
    when(mockRepository.submitForm(any, any)).thenAnswer((_) async {});

    await controller.reload();
    controller.updateFieldValue('Name', 'Farzam');

    final future = controller.submit();

    expect(controller.state.isSubmitting, true);

    await future;

    expect(controller.state.isSubmitting, false);
    verify(mockRepository.submitForm(any, any)).called(1);
  });
}
