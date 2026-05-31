import 'package:flutter/material.dart';

class IosToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const IosToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ao tocar no componente, inverte o valor atual do toggle.
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: value ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 220),
          curve: Curves.elasticOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: value ? Colors.black : Colors.grey.shade300,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  color: Color(0x22000000),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
