import 'package:flutter/material.dart';

class TogglePill extends StatefulWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const TogglePill({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  State<TogglePill> createState() => _TogglePillState();
}

class _TogglePillState extends State<TogglePill> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;
  }

  @override
  void didUpdateWidget(TogglePill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _isOn = widget.value;
    }
  }

  void _toggle() {
    setState(() {
      _isOn = !_isOn;
    });
    widget.onChanged(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${widget.title}:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 32,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _isOn ? Colors.green : Colors.red,
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
