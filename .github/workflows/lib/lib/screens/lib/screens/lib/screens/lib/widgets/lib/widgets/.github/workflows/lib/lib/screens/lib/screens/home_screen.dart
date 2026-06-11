import 'package:flutter/material.dart';
import 'editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nella Editor'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_library, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('ไม่มีโปรเจกต์'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditorScreen(),
                  ),
                );
              },
              child: const Text('สร้างโปรเจกต์ใหม่'),
            ),
          ],
        ),
      ),
    );
  }
}
