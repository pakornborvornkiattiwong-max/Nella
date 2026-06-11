import 'package:flutter/material.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตัดต่อวิดีโอ'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.black,
              child: const Center(
                child: Icon(Icons.play_arrow, size: 64, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('พื้นที่ตัดต่อ'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('บันทึกและกลับ'),
            ),
          ],
        ),
      ),
    );
  }
}
