import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_camera.dart';
import 'package:petrosafe_app/widgets/forms/form_catatan.dart';

enum Conformity { sesuai, tidakSesuai }

class ConformityCard extends StatefulWidget {
  final String title;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final Conformity? initial;

  const ConformityCard({
    super.key,
    this.title = 'Sudah Sesuai?',
    this.onChanged,
    this.initial,
  });

  @override
  State<ConformityCard> createState() => _ConformityCardState();
}

class _ConformityCardState extends State<ConformityCard> {
  Conformity? _selected;
  final TextEditingController _messageController = TextEditingController();
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    _messageController.addListener(() {
      if (_selected != null && _selected == Conformity.tidakSesuai) {
        _setNote(_messageController.text);
      }
    });
  }

  void _set(Conformity v) {
    setState(() => _selected = v);
    widget.onChanged?.call({
      "status": v.name,
      "note": _messageController.text,
      "photoPath": _photoPath,
    });
  }

  void _setPhoto(String path) {
    setState(() => _photoPath = path);

    if (_selected != null) {
      widget.onChanged?.call({
        "status": _selected!.name,
        "note": _messageController.text,
        "photoPath": path,
      });
    }
  }

  void _setNote(String text) {
    if (_selected != null) {
      widget.onChanged?.call({
        "status": _selected!.name,
        "note": text,
        "photoPath": _photoPath,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF295C99),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                _Option(
                  label: 'Sesuai',
                  value: Conformity.sesuai,
                  group: _selected,
                  onTap: () => _set(Conformity.sesuai),
                ),
                const SizedBox(width: 20),
                _Option(
                  label: 'Tidak Sesuai',
                  value: Conformity.tidakSesuai,
                  group: _selected,
                  onTap: () => _set(Conformity.tidakSesuai),
                ),
              ],
            ),
          ),
        ),

        if (_selected == Conformity.tidakSesuai) ...[
          const SizedBox(height: 12),
          CameraCard(
            targetFoto: "Foto Kelengkapan",
            sisiFoto: "Kelengkapan",
            tujuanFoto: "Tidak Sesuai",
            onCaptured: (path) => _setPhoto(path),
          ),
          const SizedBox(height: 8),
          const Text("Catatan"),
          NoteForm(
            hintText: "Masukkan Keterangan atau Catatan",
            messageController: _messageController,
            onChanged: (text) => _setNote(text),
          ),
        ],
      ],
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final Conformity value;
  final Conformity? group;
  final VoidCallback onTap;

  const _Option({
    required this.label,
    required this.value,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Transform.scale(
            scale: 1.0,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(unselectedWidgetColor: Colors.white),
              child: Radio<Conformity>(
                value: value,
                groupValue: group,
                onChanged: (_) => onTap(),
                fillColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
