import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';

class CameraCard extends StatelessWidget {
  final String targetFoto;
  final String sisiFoto;
  final String tujuanFoto;
  final Function(XFile?)? onImageTaken;

  const CameraCard({
    super.key,
    required this.targetFoto,
    required this.sisiFoto,
    required this.tujuanFoto,
    this.onImageTaken,
  });

  Future<void> _openCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (onImageTaken != null) {
      onImageTaken!(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    const cameraIcon = Icon(FeatherIcons.camera, color: Colors.white);
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openCamera(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          color: Colors.red[800],
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                cameraIcon,
                SizedBox(height: 10),
                Text(
                  "Ambil $targetFoto",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Foto Bagian $sisiFoto Yang $tujuanFoto",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
