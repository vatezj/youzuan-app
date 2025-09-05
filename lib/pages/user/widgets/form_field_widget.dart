import 'package:flutter/material.dart';

/// 通用表单字段组件
class FormFieldWidget extends StatelessWidget {
  final String label;
  final Widget child;
  final double? labelWidth;

  const FormFieldWidget({
    Key? key,
    required this.label,
    required this.child,
    this.labelWidth = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: labelWidth,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                letterSpacing: 0.3,
                shadows: [
                  Shadow(
                    color: Colors.black38,
                    offset: Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}
