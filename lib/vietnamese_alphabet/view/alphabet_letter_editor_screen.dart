import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:location_app/l10n/app_localizations.dart';

import '../data/alphabet_override_repository.dart';
import '../model/alphabet_card_view_data.dart';
import '../model/alphabet_letter_override_row.dart';
import '../model/alphabet_override_image_kind.dart';
import 'alphabet_illustration.dart';

class AlphabetLetterEditorScreen extends StatefulWidget {
  const AlphabetLetterEditorScreen({
    super.key,
    required this.viewData,
  });
  final AlphabetCardViewData viewData;

  @override
  State<AlphabetLetterEditorScreen> createState() =>
      _AlphabetLetterEditorScreenState();
}

class _AlphabetLetterEditorScreenState extends State<AlphabetLetterEditorScreen> {
  static const int _maxImageDimension = 768;
  static const int _jpegQuality = 82;
  final AlphabetOverrideRepository _repository = AlphabetOverrideRepository();
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _exampleViController;
  late final TextEditingController _exampleEnController;
  late final TextEditingController _spellController;
  late final TextEditingController _urlController;
  late AlphabetOverrideImageKind _imageKind;
  late String _pickedBase64;

  @override
  void initState() {
    super.initState();
    final AlphabetCardViewData d = widget.viewData;
    _exampleViController = TextEditingController(text: d.exampleVi);
    _exampleEnController = TextEditingController(text: d.exampleEn);
    _spellController = TextEditingController(text: d.spellSyllableVi);
    _urlController = TextEditingController(
      text: d.imageKind == AlphabetOverrideImageKind.url ? d.imageValue : '',
    );
    _imageKind = d.imageKind;
    _pickedBase64 =
        d.imageKind == AlphabetOverrideImageKind.base64 ? d.imageValue : '';
  }

  @override
  void dispose() {
    _exampleViController.dispose();
    _exampleEnController.dispose();
    _spellController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  List<int> _downsizeImageBytes(List<int> rawBytes) {
    final img.Image? decoded = img.decodeImage(Uint8List.fromList(rawBytes));
    if (decoded == null) {
      return rawBytes;
    }
    final int srcWidth = decoded.width;
    final int srcHeight = decoded.height;
    final int longest = srcWidth > srcHeight ? srcWidth : srcHeight;
    if (longest <= _maxImageDimension) {
      return img.encodeJpg(decoded, quality: _jpegQuality);
    }
    final double scale = _maxImageDimension / longest;
    final int targetWidth = (srcWidth * scale).round();
    final int targetHeight = (srcHeight * scale).round();
    final img.Image resized = img.copyResize(
      decoded,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.average,
    );
    return img.encodeJpg(resized, quality: _jpegQuality);
  }

  Future<void> _pickImageFromDevice() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (file == null) {
      return;
    }
    final List<int> originalBytes = await file.readAsBytes();
    final List<int> processedBytes = _downsizeImageBytes(originalBytes);
    setState(() {
      _pickedBase64 = base64Encode(processedBytes);
      _imageKind = AlphabetOverrideImageKind.base64;
    });
  }

  bool _validate(AppLocalizations l) {
    if (_exampleViController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.alphabetEditorValidationExample)),
      );
      return false;
    }
    if (_spellController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.alphabetEditorValidationSpell)),
      );
      return false;
    }
    if (_imageKind == AlphabetOverrideImageKind.url &&
        _urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.alphabetEditorValidationUrl)),
      );
      return false;
    }
    if (_imageKind == AlphabetOverrideImageKind.base64 &&
        _pickedBase64.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.alphabetEditorValidationImage)),
      );
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    if (!_validate(l)) {
      return;
    }
    final String imageValue = _imageKind == AlphabetOverrideImageKind.icon
        ? ''
        : (_imageKind == AlphabetOverrideImageKind.base64
            ? _pickedBase64
            : _urlController.text.trim());
    final AlphabetLetterOverrideRow row = AlphabetLetterOverrideRow(
      letterKey: widget.viewData.base.letterDisplay,
      exampleVi: _exampleViController.text.trim(),
      exampleEn: _exampleEnController.text.trim(),
      spellSyllableVi: _spellController.text.trim(),
      imageKind: _imageKind,
      imageValue: imageValue,
    );
    await _repository.upsert(row);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.alphabetEditorSaved)),
    );
    Navigator.of(context).pop(true);
  }

  Future<void> _confirmReset() async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l.alphabetEditorResetTitle),
        content: Text(l.alphabetEditorResetBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.mathEntityDeleteCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.alphabetEditorReset),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) {
      return;
    }
    await _repository.delete(widget.viewData.base.letterDisplay);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final AlphabetCardViewData previewData = AlphabetCardViewData(
      base: widget.viewData.base,
      exampleVi: _exampleViController.text,
      exampleEn: _exampleEnController.text,
      spellSyllableVi: _spellController.text,
      imageKind: _imageKind,
      imageValue: _imageKind == AlphabetOverrideImageKind.icon
          ? ''
          : (_imageKind == AlphabetOverrideImageKind.base64
              ? _pickedBase64
              : _urlController.text),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l.alphabetEditorTitle(widget.viewData.base.letterDisplay)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: <Widget>[
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: widget.viewData.base.illustrationBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: AlphabetIllustration(data: previewData, size: 56),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _exampleViController,
              decoration: InputDecoration(
                labelText: l.alphabetEditorExampleVi,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _exampleEnController,
              decoration: InputDecoration(
                labelText: l.alphabetEditorExampleEn,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _spellController,
              decoration: InputDecoration(
                labelText: l.alphabetEditorSpell,
                hintText: l.alphabetEditorSpellHint,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            Text(
              l.alphabetEditorImageSection,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<AlphabetOverrideImageKind>(
              segments: <ButtonSegment<AlphabetOverrideImageKind>>[
                ButtonSegment<AlphabetOverrideImageKind>(
                  value: AlphabetOverrideImageKind.icon,
                  label: Text(l.alphabetEditorImageIcon),
                  icon: const Icon(Icons.widgets_outlined),
                ),
                ButtonSegment<AlphabetOverrideImageKind>(
                  value: AlphabetOverrideImageKind.base64,
                  label: Text(l.alphabetEditorImageDevice),
                  icon: const Icon(Icons.photo_library_outlined),
                ),
                ButtonSegment<AlphabetOverrideImageKind>(
                  value: AlphabetOverrideImageKind.url,
                  label: Text(l.alphabetEditorImageUrl),
                  icon: const Icon(Icons.link_rounded),
                ),
              ],
              selected: <AlphabetOverrideImageKind>{_imageKind},
              onSelectionChanged: (Set<AlphabetOverrideImageKind> next) {
                setState(() {
                  _imageKind = next.first;
                });
              },
            ),
            if (_imageKind == AlphabetOverrideImageKind.url) ...<Widget>[
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: l.alphabetEditorImageUrl,
                  hintText: l.alphabetEditorUrlHint,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
            if (_imageKind == AlphabetOverrideImageKind.base64) ...<Widget>[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  onPressed: () => unawaited(_pickImageFromDevice()),
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: Text(l.alphabetEditorPickImage),
                ),
              ),
            ],
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => unawaited(_save()),
              child: Text(l.alphabetEditorSave),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => unawaited(_confirmReset()),
              child: Text(l.alphabetEditorReset),
            ),
          ],
        ),
      ),
    );
  }
}
