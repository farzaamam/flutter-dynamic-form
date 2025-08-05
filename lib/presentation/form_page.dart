import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/presentation/form_controller.dart';
import 'package:flutter_dynamic_form/presentation/widgets/file_field_widget.dart';
import 'package:flutter_dynamic_form/presentation/widgets/select_field_widget.dart';
import 'package:flutter_dynamic_form/presentation/widgets/text_field_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormPage extends ConsumerStatefulWidget {
  const FormPage({super.key});

  @override
  ConsumerState<FormPage> createState() => _FormPageState();
}

class _FormPageState extends ConsumerState<FormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(formControllerProvider);
    final controller = ref.read(formControllerProvider.notifier);
    final isSubmitting = formState.isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: formState.fields.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _buildErrorState(e, controller),
          data: (fields) => _buildForm(fields, controller, isSubmitting),
        ),
      ),
    );
  }

  Widget _buildForm(
    List<InputField> fields,
    FormController controller,
    bool isSubmitting,
  ) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ...fields.map(
              (field) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildFieldWidget(field, controller),
              ),
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(controller, isSubmitting),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(FormController controller, bool isSubmitting) {
    return ElevatedButton(
      onPressed:
          isSubmitting
              ? null
              : () async {
                if (!_formKey.currentState!.validate()) return;
                _formKey.currentState!.save();

                try {
                  await controller.submit();
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Submitted successfully')),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Submit failed: $e')));
                }
              },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          isSubmitting
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : const Text('Submit'),
    );
  }

  Widget _buildFieldWidget(InputField field, FormController controller) {
    if (field is TextInputField) {
      return TextFieldWidget(
        field: field,
        onSaved: (value) => controller.updateFieldValue(field.title, value),
      );
    }

    if (field is SelectableInputField) {
      return SelectFieldWidget(
        field: field,
        onChanged: (value) => controller.updateFieldValue(field.title, value),
      );
    }

    if (field is FileInputField) {
      return FileFieldWidget(
        field: field,
        onChanged:
            (uploadedFile) =>
                controller.updateUploadingFile(field.title, uploadedFile),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState(Object error, FormController controller) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          Text('Failed to load form: $error'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: controller.reload(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
