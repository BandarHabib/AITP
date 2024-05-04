import 'package:flutter/material.dart';
import '../../../services/attraction_service.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PreferencesForm();
  }
}

class _PreferencesForm extends StatefulWidget {
  @override
  __PreferencesFormState createState() => __PreferencesFormState();
}

class __PreferencesFormState extends State<_PreferencesForm> {
  String? selectedCity;
  List<String> selectedCategories = [];

  final List<String> categories = [
    'Culture',
    'Entertainment and Recreation',
    'Food and Drink',
    'Health and Wellness',
    'Places of Worship',
    'Shopping',
    'Sports',
    'Nature',
  ];

  final AttractionService _attractionService =
      AttractionService('http://10.0.2.2:5000');

  void _submitPreferences() async {
    if (selectedCity == null || selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a city and at least one category')),
      );
      return;
    }

    try {
      var matches = await _attractionService.getAttractions(
          selectedCity!, selectedCategories);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Matches Found'),
            content: Text(matches
                .toString()), // Display the results in a simple way, adjust as needed
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showMultiSelect(BuildContext context) async {
    final List<String> tempSelectedCategories = List.from(selectedCategories);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Select Categories'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: categories.map((String category) {
                    return CheckboxListTile(
                      value: tempSelectedCategories.contains(category),
                      title: Text(category),
                      onChanged: (bool? value) {
                        if (value != null) {
                          setDialogState(() {
                            // This now refers to the StateSetter of StatefulBuilder
                            if (value) {
                              tempSelectedCategories.add(category);
                            } else {
                              tempSelectedCategories
                                  .removeWhere((String c) => c == category);
                            }
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    // Update the main widget's state when the dialog is closed with 'OK'
                    setState(() {
                      // This refers to the setState of the main widget
                      selectedCategories = tempSelectedCategories;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Drop Down Menu for selecting city
            DropdownButtonFormField<String>(
              value: selectedCity,
              onChanged: (newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
              items: ['Jeddah', 'Riyadh', 'Makkah', 'Dammam'].map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Select City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            // Second Drop Down Menu for selecting categories
            ListTile(
              title: const Text('Select Categories'),
              subtitle: Text(selectedCategories.join(', ')),
              onTap: () => _showMultiSelect(context),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            const SizedBox(height: 16.0),
            // Button to submit preferences
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: _submitPreferences,
                  child: const Text('Generate Plan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
