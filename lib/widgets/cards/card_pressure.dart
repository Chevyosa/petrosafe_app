import 'package:flutter/material.dart';

enum Pressure { hijau, orange, merah }

class PressureCard extends StatefulWidget {
  final String title;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final Pressure? initial;

  const PressureCard({
    super.key,
    this.title = 'Pressure Level?',
    this.onChanged,
    this.initial,
  });

  @override
  State<PressureCard> createState() => _PressureCardState();
}

class _PressureCardState extends State<PressureCard> {
  Pressure? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  String _getPressureLabel(Pressure value) {
    switch (value) {
      case Pressure.hijau:
        return "Hijau";
      case Pressure.orange:
        return "Orange";
      case Pressure.merah:
        return "Merah";
    }
  }

  void _set(Pressure value) {
    setState(() => _selected = value);
    widget.onChanged?.call({"value": _getPressureLabel(value)});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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
              label: 'Hijau',
              value: Pressure.hijau,
              group: _selected,
              onTap: () => _set(Pressure.hijau),
            ),
            const SizedBox(width: 20),
            _Option(
              label: 'Orange',
              value: Pressure.orange,
              group: _selected,
              onTap: () => _set(Pressure.orange),
            ),
            const SizedBox(width: 20),
            _Option(
              label: 'Merah',
              value: Pressure.merah,
              group: _selected,
              onTap: () => _set(Pressure.merah),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final Pressure value;
  final Pressure? group;
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
              child: Radio<Pressure>(
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
