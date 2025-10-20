import 'package:flutter/material.dart';
import 'package:kiorapp/data/models/tag.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const TagChip({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Chip(
        avatar: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
        label: Text(tag.name),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
    );
  }
}
