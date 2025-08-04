import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/domain/models/form_input_field_models.dart';

class UploadedFile {
  final String fieldName;
  final String filename;
  final Uint8List bytes;

  UploadedFile({
    required this.fieldName,
    required this.filename,
    required this.bytes,
  });
}

class FileFieldWidget extends StatefulWidget {
  final FileInputField field;
  final void Function(UploadedFile?) onSaved;
  final void Function(UploadedFile?)? onChanged;

  final UploadedFile? initialFile;

  const FileFieldWidget({
    required this.field,
    required this.onSaved,
    this.onChanged,
    this.initialFile,
    super.key,
  });

  @override
  State<FileFieldWidget> createState() => _FileFieldWidgetState();
}

class _FileFieldWidgetState extends State<FileFieldWidget> {
  UploadedFile? _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.initialFile;
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
    if (file.bytes == null) return;
    final uploaded = UploadedFile(
      fieldName: widget.field.title,
      filename: file.name,
      bytes: file.bytes!,
    );
    setState(() {
      _picked = uploaded;
    });
    widget.onChanged?.call(_picked);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<UploadedFile?>(
      initialValue: _picked,
      onSaved: (_) => widget.onSaved(_picked),
      validator: (value) {
        if (widget.field.isRequired && (value == null)) {
          return 'Required';
        }
        return null;
      },
      builder: (state) {
        final current = state.value ?? _picked;
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
                    current?.filename ?? 'No file selected',
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
    );
  }
}
