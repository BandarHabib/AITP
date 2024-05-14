import 'package:flutter/material.dart';
import '../../../services/attraction_service.dart';
import 'package:tp_app/screens/plan_trip/views/attraction_results_screen.dart';
import 'package:user_repository/user_repository.dart'; // Ensure this import points to your FirebaseUserRepo

class PreferencesScreen extends StatelessWidget {
  final UserRepository userRepo;
  final String userId;

  const PreferencesScreen(
      {Key? key, required this.userRepo, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PreferencesForm(userRepo: userRepo, userId: userId);
  }
}

class _PreferencesForm extends StatefulWidget {
  final UserRepository userRepo;
  final String userId;

  const _PreferencesForm({required this.userRepo, required this.userId});

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
          selectedCity!, selectedCategories, widget.userId);
      if (matches.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttractionResultsScreen(
                  attractions: matches, userRepo: widget.userRepo),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No matches found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching attractions: $e')),
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
                            if (value) {
                              tempSelectedCategories.add(category);
                            } else {
                              tempSelectedCategories
                                  .removeWhere((c) => c == category);
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
                    setState(() {
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
