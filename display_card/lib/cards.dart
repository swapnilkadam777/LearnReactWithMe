import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  // Define lists for dropdown options
  final List<String> _cardSigns = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];
  final List<String> _colors = ['Red', 'Black'];
  final List<String> _numbers = [
    'A',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'J',
    'Q',
    'K'
  ];

  // Define state variables for selected values
  String? _selectedCardSign;
  String? _selectedColor;
  String? _selectedNumber;

  // Filtered list of card signs based on color
  List<String> get _filteredCardSigns {
    if (_selectedColor == 'Black') {
      return ['Clubs', 'Spades'];
    } else if (_selectedColor == 'Red') {
      return ['Hearts', 'Diamonds'];
    } else {
      return _cardSigns;
    }
  }

  // Map card signs to icons
  IconData _getCardIcon(String sign) {
    switch (sign) {
      case 'Hearts':
        return Icons.favorite;
      case 'Diamonds':
        return Icons.diamond;
      case 'Clubs':
        return Icons.ac_unit; // Placeholder for Clubs
      case 'Spades':
        return Icons.spa; // Placeholder for Spades
      default:
        return Icons.help; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Card Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for Color
            DropdownButton<String>(
              value: _selectedColor,
              hint: const Text('Select Color'),
              items: _colors.map((String color) {
                return DropdownMenuItem<String>(
                  value: color,
                  child: Text(color),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedColor = newValue;
                  // Reset the selected card sign when color changes
                  _selectedCardSign = null;
                });
              },
            ),
            SizedBox(height: 16.0), // Spacer between dropdowns

            // Dropdown for Card Sign
            DropdownButton<String>(
              value: _selectedCardSign,
              hint: const Text('Select Card Sign'),
              items: _filteredCardSigns.map((String sign) {
                return DropdownMenuItem<String>(
                  value: sign,
                  child: Row(
                    children: [
                      Icon(_getCardIcon(sign), color: Colors.black),
                      SizedBox(width: 8.0),
                      Text(sign),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCardSign = newValue;
                });
              },
            ),
            SizedBox(height: 16.0), // Spacer between dropdowns

            // Dropdown for Number
            DropdownButton<String>(
              value: _selectedNumber,
              hint: const Text('Select Number'),
              items: _numbers.map((String number) {
                return DropdownMenuItem<String>(
                  value: number,
                  child: Text(number),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedNumber = newValue;
                });
              },
            ),
            SizedBox(height: 32.0), // Spacer before card display

            // Display the selected card
            if (_selectedColor != null &&
                _selectedCardSign != null &&
                _selectedNumber != null)
              CardDisplay(
                color: _selectedColor!,
                sign: _selectedCardSign!,
                number: _selectedNumber!,
              ),
          ],
        ),
      ),
    );
  }
}

//Display the card template
class CardDisplay extends StatelessWidget {
  final String color;
  final String sign;
  final String number;

  const CardDisplay({
    required this.color,
    required this.sign,
    required this.number,
  });

  // Map card signs to icons
  IconData _getCardIcon(String sign) {
    switch (sign) {
      case 'Hearts':
        return Icons.favorite;
      case 'Diamonds':
        return Icons.diamond;
      case 'Clubs':
        return Icons.ac_unit; // Placeholder for Clubs
      case 'Spades':
        return Icons.spa; // Placeholder for Spades
      default:
        return Icons.help; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    // Convert the number to an integer to handle multiple icons
    int iconCount = int.tryParse(number) ?? 0;
    if (iconCount == 0 &&
        (number == 'A' || number == 'K' || number == 'Q' || number == 'J'))
      iconCount = 1;

    // Determine the number of columns based on the number of icons
    int columnCount = iconCount > 3 ? 3 : iconCount;

    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
            color: color == 'Red' ? Colors.red : Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          // Center the icons and use GridView to manage the columns
          Center(
            child: SizedBox(
              width: 95, // 70% of the card's width (150 * 0.70)
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: iconCount,
                itemBuilder: (context, index) {
                  return Icon(
                    _getCardIcon(sign),
                    size: 24,
                    color: color == 'Red' ? Colors.red : Colors.black,
                  );
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ),
          // Number at the top-left corner with icon below
          Positioned(
            top: 8.0,
            left: 8.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color == 'Red' ? Colors.red : Colors.black,
                  ),
                ),
                Icon(
                  _getCardIcon(sign),
                  size: 24,
                  color: color == 'Red' ? Colors.red : Colors.black,
                ),
              ],
            ),
          ),
          // Number at the bottom-right corner with icon above
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  _getCardIcon(sign),
                  size: 24,
                  color: color == 'Red' ? Colors.red : Colors.black,
                ),
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color == 'Red' ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
