// category_selector.dart
import 'package:flutter/material.dart';

import '../data/categories.dart';

class CategorySelector extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategorySelector({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: categories.map((category) {
        bool isSelected = selectedCategory == category;
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              selectedCategory = selected ? category : null;
            });
            widget.onCategorySelected(selectedCategory!);
          },
          selectedColor: Colors.greenAccent,
          backgroundColor: Colors.grey.shade200,
        );
      }).toList(),
    );
  }
}
