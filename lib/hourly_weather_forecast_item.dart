import 'package:flutter/material.dart';

// A StatelessWidget to represent a weather forecast item for a specific hour.
class HourlyForeCastItem extends StatelessWidget {
  final String time; // The time of the forecast.
  final IconData icon; // Icon representing the weather condition.
  final String temperature; // The temperature value to display.

  // Constructor requiring time, icon, and temperature as parameters.
  const HourlyForeCastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    // Builds the widget's UI.
    return Card(
      elevation: 8, // Adds a shadow effect to the card.
      child: Container(
        width: 100, // Fixed width for the forecast item.
        padding: const EdgeInsets.all(8), // Padding inside the container.
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(12), // Rounds the corners of the container.
        ),
        child: Column(
          children: [
            // Displays the time with specific text styling.
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1, // Limits text to one line.
              overflow:
                  TextOverflow.ellipsis, // Displays ellipsis for overflow.
            ),
            const SizedBox(height: 8), // Space between time and icon.
            // Displays the weather icon.
            Icon(
              icon,
              size: 32, // Size of the icon.
            ),
            const SizedBox(height: 8), // Space between icon and temperature.
            // Displays the temperature with specific text styling.
            Text(
              temperature,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
