import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_camera.dart';
import 'package:petrosafe_app/widgets/forms/form_catatan.dart';

enum Functionality { berfungsi, tidakBerfungsi }

class FuncitonalityCard extends StatefulWidget {
  final String title;
  final ValueChanged<Functionality>? onChanged;
  final Functionality? initial;

  const FuncitonalityCard({
    super.key,
    this.title = 'Berfungsi?',
    this.onChanged,
    this.initial,
  });

  @override
  State<FuncitonalityCard> createState() => _ConformityCardState();
}

class _ConformityCardState extends State<FuncitonalityCard> {
  late Functionality _selected;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.initial ?? Functionality.berfungsi;
  }

  void _set(Functionality v) {
    setState(() => _selected = v);
    widget.onChanged?.call(v);
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
                  label: 'Berfungsi',
                  value: Functionality.berfungsi,
                  group: _selected,
                  onTap: () => _set(Functionality.berfungsi),
                ),
                const SizedBox(width: 20),
                _Option(
                  label: 'Tidak Berfungsi',
                  value: Functionality.tidakBerfungsi,
                  group: _selected,
                  onTap: () => _set(Functionality.tidakBerfungsi),
                ),
              ],
            ),
          ),
        ),

        if (_selected == Functionality.tidakBerfungsi) ...[
          const SizedBox(height: 12),
          const CameraCard(
            targetFoto: "Foto Kelengkapan",
            sisiFoto: "Kelengkapan",
            tujuanFoto: "Tidak Sesuai",
          ),
          const SizedBox(height: 8),
          const Text("Catatan"),
          NoteForm(
            hintText: "Masukkan Keterangan atau Catatan",
            messageController: _messageController,
          ),
        ],
      ],
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final Functionality value;
  final Functionality group;
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Transform.scale(
            scale: 1.0,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(unselectedWidgetColor: Colors.white),
              child: Radio<Functionality>(
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
