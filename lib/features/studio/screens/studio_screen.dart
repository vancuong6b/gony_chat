import 'package:flutter/material.dart';

class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phòng làm việc'),
      ),
      body: const Center(
        child: Text('Màn hình Studio (Tạo mới)'),
      ),
    );
  }
}
