import 'package:flutter/material.dart';

class PixelSelectionGrid extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onItemSelected;
  final String heading;

  const PixelSelectionGrid({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.selectedItem,
    required this.heading
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat,
              color: Colors.white,
            ),
          ),
        SizedBox(width: 10,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withOpacity(0.6),
              border: Border(left: BorderSide.none),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),

            child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                children: [
                  Text(
                    heading,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: items.map((item) {
                      final isSelected = item == selectedItem;

                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 120) / 2,
                        child: _PixelOptionChip(
                          label: item,
                          isSelected: isSelected,
                          onTap: () => onItemSelected(item),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PixelOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PixelOptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F0FE) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
