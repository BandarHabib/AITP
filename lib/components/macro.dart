import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyMacroWidget extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  const MyMacroWidget(
      {required this.title,
      required this.value,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                offset: const Offset(2, 2),
                blurRadius: 5)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 10)),
            FaIcon(
              icon,
              color: Colors.blue[900],
            ),
            const SizedBox(height: 4),
            Text(
              title == "Price"
                  ? '\$$value'
                  : title == "Capacity"
                      ? '$value +'
                      : '$value',
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    ));
  }
}
