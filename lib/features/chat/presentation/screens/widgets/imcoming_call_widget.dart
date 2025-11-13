import 'dart:ui';
import 'package:flutter/material.dart';
class IncomingCallWidget extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final String callerName;
  final String? callerAvatar;

  const IncomingCallWidget({
    super.key,
    required this.onAccept,
    required this.onReject,
    required this.callerName,
    this.callerAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: callerAvatar != null
                    ? NetworkImage(callerAvatar!)
                    : null,
                child: callerAvatar == null ? Icon(Icons.person, size: 40) : null,
              ),
              const SizedBox(height: 12),
              Text(
                '$callerName đang gọi bạn',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'reject',
                    backgroundColor: Colors.red,
                    onPressed: onReject,
                    child: const Icon(Icons.call_end),
                  ),
                  FloatingActionButton(
                    heroTag: 'accept',
                    backgroundColor: Colors.green,
                    onPressed: onAccept,
                    child: const Icon(Icons.call),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
