import 'package:flutter/material.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    // ข้อมูลตัวอย่างโปรเจกต์
    _projects = [
      {'name': 'โปรเจกต์ตัวอย่าง 1', 'date': 'เมื่อวานนี้', 'duration': '00:32'},
      {'name': 'คลิปวันเกิด', 'date': '2 วันที่แล้ว', 'duration': '01:15'},
      {'name': 'Vlog ท่องเที่ยว', 'date': '5 วันที่แล้ว', 'duration': '03:42'},
    ];
    setState(() {});
  }

  void _createNewProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('สร้างโปรเจกต์ใหม่'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'ชื่อโปรเจกต์',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _projects.insert(0, {
                  'name': value,
                  'date': 'เพิ่งสร้าง',
                  'duration': '00:00',
                });
              });
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  void _openProject(Map<String, dynamic> project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorScreen(projectName: project['name']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.white : Colors.black,
              ),
              child: Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Nella Editor',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ปุ่มสร้างโปรเจกต์ใหม่
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _createNewProject,
              icon: const Icon(Icons.add),
              label: const Text('สร้างโปรเจกต์ใหม่'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
              ),
            ),
          ),
          
          // หัวข้อโปรเจกต์ของฉัน
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'โปรเจกต์ของฉัน',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('ดูทั้งหมด'),
                ),
              ],
            ),
          ),
          
          // รายการโปรเจกต์
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _projects.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.video_library_outlined,
                              size: 64,
                              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ยังไม่มีโปรเจกต์',
                              style: TextStyle(
                                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'กดปุ่มด้านบนเพื่อเริ่มต้น',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _projects.length,
                        itemBuilder: (context, index) {
                          final project = _projects[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.video_file, size: 28),
                              ),
                              title: Text(
                                project['name'],
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text('${project['date']} • ${project['duration']}'),
                              trailing: const Icon(Icons.more_vert),
                              onTap: () => _openProject(project),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        selectedItemColor: isDark ? Colors.white : Colors.black,
        unselectedItemColor: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าแรก'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'คลัง'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'โปรไฟล์'),
        ],
      ),
    );
  }
}
