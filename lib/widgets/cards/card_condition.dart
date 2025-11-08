import 'package:flutter/material.dart';

enum Condition { baik, rusak }

class ConditionCard extends StatefulWidget {
  final String title;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final Condition? initial;

  const ConditionCard({
    super.key,
    this.title = 'Kondisi Baik?',
    this.onChanged,
    this.initial,
  });

  @override
  State<ConditionCard> createState() => _ConditionCardState();
}

class _ConditionCardState extends State<ConditionCard> {
  Condition? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  void _set(Condition value) {
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
              label: 'Baik',
              value: Condition.baik,
              group: _selected,
              onTap: () => _set(Condition.baik),
            ),
            const SizedBox(width: 20),
            _Option(
              label: 'Rusak',
              value: Condition.rusak,
              group: _selected,
              onTap: () => _set(Condition.rusak),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final Condition value;
  final Condition? group;
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
              child: Radio<Condition>(
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
