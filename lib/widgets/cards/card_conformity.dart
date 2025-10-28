import 'package:flutter/material.dart';

enum Conformity { sesuai, tidakSesuai }

class ConformityCard extends StatefulWidget {
  final String title;
  final ValueChanged<Conformity>? onChanged;
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
  late Conformity _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial ?? Conformity.sesuai;
  }

  void _set(Conformity v) {
    setState(() => _selected = v);
    widget.onChanged?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF295C99), // biru seperti contoh
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
    );
  }
}

class _Option extends StatelessWidget {
  final String label;
  final Conformity value;
  final Conformity group;
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
              child: Radio<Conformity>(
                value: value,
                groupValue: group,
                onChanged: (_) => onTap(),
                fillColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.white;
                }),
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
