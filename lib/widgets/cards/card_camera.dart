import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraCard extends StatefulWidget {
  final String targetFoto;
  final String sisiFoto;
  final String tujuanFoto;

  final ValueChanged<String>? onCaptured;

  const CameraCard({
    super.key,
    required this.targetFoto,
    required this.sisiFoto,
    required this.tujuanFoto,
    this.onCaptured,
  });

  @override
  State<CameraCard> createState() => _CameraCardState();
}

class _CameraCardState extends State<CameraCard> {
  XFile? _capturedImage;

  Future<void> _openCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() => _capturedImage = image);

      widget.onCaptured?.call(image.path);
    }
  }

  void _showImagePreview(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.black.withOpacity(0.9),
          child: Center(
            child: Hero(
              tag: "preview_${widget.targetFoto}",
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.file(imageFile),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openCamera(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.red[800],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_capturedImage == null) ...[
                  const Icon(
                    FeatherIcons.camera,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ambil ${widget.targetFoto}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Foto Bagian ${widget.sisiFoto} Yang ${widget.tujuanFoto}",
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  GestureDetector(
                    onTap: () =>
                        _showImagePreview(context, File(_capturedImage!.path)),
                    child: Hero(
                      tag: "preview_${widget.targetFoto}",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_capturedImage!.path),
                          fit: BoxFit.cover,
                          height: 180,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Foto ${widget.targetFoto} berhasil diambil",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton.icon(
                    onPressed: () => _openCamera(context),
                    icon: const Icon(
                      FeatherIcons.refreshCw,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text(
                      "Ambil Ulang",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
