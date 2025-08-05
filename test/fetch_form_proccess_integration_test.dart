import 'package:flutter_dynamic_form/data/form_data_source.dart';
import 'package:flutter_dynamic_form/data/form_repository_imp.dart';
import 'package:flutter_dynamic_form/di/global_providers.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/domain/models/input_content.dart';
import 'package:flutter_dynamic_form/domain/models/input_validations.dart';
import 'package:flutter_dynamic_form/presentation/form_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'fetch_form_proccess_integration_test.mocks.dart';

@GenerateMocks([FormDataSource])
void main() {
  late ProviderContainer container;
  late MockFormDataSource mockDataSource;

  final mockFields = <InputField>[
    TextInputField(
      id: 2,
      title: "dwedw",
      isRequired: false,
      TextContent(hint: "asf"),
      TextValidation(1, 3, TextInputValidationType.plain),
    ),
  ];

  setUp(() {
    mockDataSource = MockFormDataSource();

    // Override repo with mockDataSource inside container
    container = ProviderContainer(
      overrides: [
        formRepositoryProvider.overrideWithValue(
          FormRepositoryImp(formDataSource: mockDataSource),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('fetches forms successfully and updates state', () async {
    when(mockDataSource.fetchForm()).thenAnswer((_) async => mockFields);

    final controller = container.read(formControllerProvider.notifier);

    await controller.reload();

    final state = container.read(formControllerProvider);

    expect(state.fields, isA<AsyncData<List<InputField>>>());
    final data = (state.fields as AsyncData<List<InputField>>).value;
    expect(data, equals(mockFields));
  });
}
