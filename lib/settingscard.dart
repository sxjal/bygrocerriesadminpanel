import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard(
      {required this.cardIcon,
      required this.text,
      required this.color,
      required this.onTap,
      super.key});

  final IconData cardIcon;
  final String text;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {onTap()},
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.45,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            // color: color,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              cardIcon,
              size: 40,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(174, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
