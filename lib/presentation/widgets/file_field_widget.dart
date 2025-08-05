import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';
import 'package:flutter_dynamic_form/presentation/direction_helper.dart';

class FileFieldWidget extends StatefulWidget {
  final FileInputField field;
  final void Function(File?) onChanged;

  const FileFieldWidget({
    required this.field,
    required this.onChanged,
    super.key,
  });

  @override
  State<FileFieldWidget> createState() => _FileFieldWidgetState();
}

class _FileFieldWidgetState extends State<FileFieldWidget> {
  PlatformFile? _picked;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        widget.field.fileValidation.format.toLowerCase().replaceAll('.', ''),
      ],
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    if (file.path == null) return;

    setState(() {
      _picked = file;
    });
    widget.onChanged.call(File(file.path!));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getDirection(widget.field.title),
      child: FormField<PlatformFile>(
        onSaved: (_) => widget.onChanged(File(_picked!.path!)),
        validator: (value) {
          if (widget.field.isRequired && (value == null)) {
            return 'Required';
          }
          return null;
        },
        builder: (state) {
          final current = state.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.field.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _pickFile();
                      state.didChange(_picked);
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Choose file'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      current?.name ?? 'No file selected',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(state.errorText ?? ''),
                ),
            ],
          );
        },
      ),
    );
  }
}
