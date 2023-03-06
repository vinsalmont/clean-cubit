import 'package:flutter/material.dart';

class BadgeIconButton extends StatelessWidget {
  const BadgeIconButton({
    required this.iconData,
    required this.badgeCount,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final int badgeCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          IconButton(
            icon: Icon(iconData),
            onPressed: onPressed,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
}
