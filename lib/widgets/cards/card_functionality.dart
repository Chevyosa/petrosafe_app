import 'package:flutter/material.dart';

enum Functionality { berfungsi, tidakBerfungsi }

class FunctionalityCard extends StatefulWidget {
  final String title;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final Functionality? initial;

  const FunctionalityCard({
    super.key,
    this.title = 'Sudah Berfungsi?',
    this.onChanged,
    this.initial,
  });

  @override
  State<FunctionalityCard> createState() => _FunctionalityCardState();
}

class _FunctionalityCardState extends State<FunctionalityCard> {
  Functionality? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  void _set(Functionality value) {
    setState(() => _selected = value);
    widget.onChanged?.call({"status": value.name});
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
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final Functionality value;
  final Functionality? group;
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
