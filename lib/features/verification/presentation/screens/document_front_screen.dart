
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class DocumentFrontScreen extends ConsumerStatefulWidget {
  const DocumentFrontScreen({super.key});
  @override
  ConsumerState<DocumentFrontScreen> createState() => _DocumentFrontScreenState();
}
class _DocumentFrontScreenState extends ConsumerState<DocumentFrontScreen> {
  XFile? _image;
  bool _loading = false;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final img = await picker.pickImage(source: source, maxWidth: 1920, maxHeight: 1920);
    if (img != null) setState(() => _image = img);
  }

  Future<void> _submit() async {
    if (_image == null) return;
    setState(() => _loading = true);
    final state = ref.read(authStateProvider).value;
    if (state?.user == null) { setState(() => _loading = false); return; }
    // Upload would happen here via verification provider
    if (mounted) context.push(RouteName.faceCapture);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(appBar: AppBar(title: const Text('Upload Document Front')),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        const Text('Take a clear photo of the front side of your document', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        if (_image != null) GestureDetector(onTap: () => setState(() => _image = null), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(_image!.path), height: 200, fit: BoxFit.cover))),
        if (_loading) const LoadingShimmer(itemCount: 1),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: FilledButton.icon(onPressed: () => _pickImage(ImageSource.camera), icon: const Icon(Icons.camera_alt), label: const Text('Camera'))),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.photo_library), label: const Text('Gallery'))),
        ]),
        const Spacer(),
        FilledButton(onPressed: _image == null || _loading ? null : _submit, child: const Text('Continue to Face Capture')),
      ]))));
  }
}
