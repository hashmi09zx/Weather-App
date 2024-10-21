import 'package:flutter/material.dart';

// StatelessWidget that displays an icon, a label, and a value vertically.
class AdditionalInfoItem extends StatelessWidget {
  final IconData icon; // Icon for the information.
  final String label; // Description of the value.
  final String value; // The actual value to display.

  // Constructor requiring icon, label, and value.
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Constructs the widget's UI using a Column to arrange elements.
    return Column(
      children: [
        Icon(icon, size: 32), // Displays the icon.
        const SizedBox(height: 12), // Adds space between icon and label.
        Text(label), // Displays the label.
        const SizedBox(height: 15), // Adds space between label and value.
        Text(value) // Displays the value.
      ],
    );
  }
}
