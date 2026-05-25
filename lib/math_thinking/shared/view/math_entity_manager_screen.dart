import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:location_app/l10n/app_localizations.dart';

import '../data/repository/math_entity_repository.dart';
import '../model/math_entity_type.dart';
import 'math_entity_image_widget.dart';

class MathEntityManagerScreen extends StatefulWidget {
  const MathEntityManagerScreen({super.key});

  @override
  State<MathEntityManagerScreen> createState() =>
      _MathEntityManagerScreenState();
}

class _MathEntityManagerScreenState extends State<MathEntityManagerScreen> {
  static const int _maxImageDimension = 768;
  static const int _jpegQuality = 82;
  final MathEntityRepository _repository = MathEntityRepository();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  MathEntityImageKind _selectedImageKind = MathEntityImageKind.base64;
  String _selectedVector = 'circle';
  String _pickedBase64 = '';
  bool _loading = true;
  List<MathEntityType> _entities = <MathEntityType>[];

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    setState(() {
      _loading = true;
    });
    final List<MathEntityType> items = await _repository.getAll();
    if (!mounted) {
      return;
    }
    setState(() {
      _entities = items;
      _loading = false;
    });
  }

  Future<void> _addEntity() async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.mathEntitySnackNameRequired)),
      );
      return;
    }
    if (_selectedImageKind == MathEntityImageKind.base64 &&
        _pickedBase64.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.mathEntitySnackPickImage)),
      );
      return;
    }
    if (_selectedImageKind == MathEntityImageKind.url &&
        _urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.mathEntitySnackUrlRequired)),
      );
      return;
    }
    final String imageValue = _selectedImageKind == MathEntityImageKind.vector
        ? _selectedVector
        : (_selectedImageKind == MathEntityImageKind.base64
            ? _pickedBase64
            : _urlController.text.trim());
    try {
      await _repository.addEntity(
        name: name,
        imageKind: _selectedImageKind,
        imageValue: imageValue,
      );
      _nameController.clear();
      _urlController.clear();
      _pickedBase64 = '';
      _selectedImageKind = MathEntityImageKind.base64;
      _selectedVector = 'circle';
      await _loadEntities();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.mathEntitySnackAdded)),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.mathEntityAddFailed('$e'))),
      );
    }
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
    });
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

  Future<void> _confirmAndDeleteEntity(
    BuildContext context,
    MathEntityType item,
  ) async {
    final AppLocalizations l = AppLocalizations.of(context)!;
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(l.mathEntityDeleteConfirmTitle),
        content: Text(l.mathEntityDeleteConfirmBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.mathEntityDeleteCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.mathEntityDeleteConfirmAction),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) {
      return;
    }
    await _repository.delete(item.id);
    await _loadEntities();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.mathEntityManagerTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l.mathEntityNameLabel,
                  hintText: l.mathEntityNameHint,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<MathEntityImageKind>(
                initialValue: _selectedImageKind,
                decoration: InputDecoration(
                    labelText: l.mathEntityImageSourceLabel),
                items: <DropdownMenuItem<MathEntityImageKind>>[
                  DropdownMenuItem<MathEntityImageKind>(
                    value: MathEntityImageKind.base64,
                    child: Text(l.mathEntitySourceBase64),
                  ),
                  DropdownMenuItem<MathEntityImageKind>(
                    value: MathEntityImageKind.url,
                    child: Text(l.mathEntitySourceUrl),
                  ),
                  DropdownMenuItem<MathEntityImageKind>(
                    value: MathEntityImageKind.vector,
                    child: Text(l.mathEntitySourceVector),
                  ),
                ],
                onChanged: (MathEntityImageKind? value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedImageKind = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (_selectedImageKind == MathEntityImageKind.url)
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: l.mathEntityUrlLabel,
                    hintText: l.mathEntityUrlHint,
                  ),
                ),
              if (_selectedImageKind == MathEntityImageKind.base64)
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: _pickImageFromDevice,
                        child: Text(l.mathEntityPickFromDevice),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_pickedBase64.isNotEmpty)
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.green),
                  ],
                ),
              if (_selectedImageKind == MathEntityImageKind.vector)
                DropdownButtonFormField<String>(
                  initialValue: _selectedVector,
                  decoration: InputDecoration(
                      labelText: l.mathEntityVectorShapeLabel),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                        value: 'circle', child: Text(l.mathEntityShapeCircle)),
                    DropdownMenuItem<String>(
                        value: 'square', child: Text(l.mathEntityShapeSquare)),
                    DropdownMenuItem<String>(
                        value: 'rectangle',
                        child: Text(l.mathEntityShapeRectangle)),
                    DropdownMenuItem<String>(
                        value: 'triangle',
                        child: Text(l.mathEntityShapeTriangle)),
                    DropdownMenuItem<String>(
                        value: 'star', child: Text(l.mathEntityShapeStar)),
                  ],
                  onChanged: (String? value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedVector = value;
                    });
                  },
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _addEntity,
                  child: Text(l.mathEntityAddButton),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _entities.length,
                        itemBuilder: (BuildContext context, int index) {
                          final MathEntityType item = _entities[index];
                          return Card(
                            child: ListTile(
                              leading: MathEntityImageWidget(
                                entity: item,
                                size: 44,
                              ),
                              title: Text(item.name),
                              subtitle: Text(
                                  item.imageKind == MathEntityImageKind.vector
                                      ? l.mathEntitySubtitleVector(
                                          item.imageValue)
                                      : (item.imageKind ==
                                              MathEntityImageKind.base64
                                          ? l.mathEntitySubtitleBase64
                                          : item.imageValue),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Switch(
                                    value: item.isActive,
                                    onChanged: (bool value) async {
                                      await _repository.setActive(
                                          id: item.id, isActive: value);
                                      await _loadEntities();
                                    },
                                  ),
                                  IconButton(
                                    tooltip: l.mathEntityDeleteTooltip,
                                    onPressed: () => unawaited(
                                      _confirmAndDeleteEntity(context, item),
                                    ),
                                    icon: const Icon(
                                        Icons.delete_outline_rounded),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
