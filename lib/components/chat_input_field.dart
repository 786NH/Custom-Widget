import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final bool isActive;
  final TextEditingController controller;
  final VoidCallback onMicTap;
  final VoidCallback onSendTap;

  const ChatInputField({
    super.key,
    required this.isActive,
    required this.controller,
    required this.onMicTap,
    required this.onSendTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          /// MIC BUTTON
          GestureDetector(
            onTap: onMicTap,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child:  Icon(Icons.mic, color: isActive
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,),
            ),
          ),

          const SizedBox(width: 12),

          /// INPUT FIELD and  SEND BUTTON
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  /// TEXT FIELD
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'enter your text here.....',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      enabled: isActive,
                    ),
                  ),

                  /// SEND BUTTON
                  GestureDetector(
                    onTap: isActive ? onSendTap : null,
                    child: Icon(
                      Icons.send,
                      size: 26,
                      color: isActive
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
