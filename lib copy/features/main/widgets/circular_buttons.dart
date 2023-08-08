import 'package:flutter/material.dart';
import 'package:courtfinder/theme/pallete.dart';

class CircularCenteredButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CircularCenteredButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      // color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 垂直方向居中
          children: [
            InkResponse(
              onTap: onPressed,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  // color: Colors.black,
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20),
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Pallete.blackColor)),
          ],
        ),
      ),
    );
  }
}
