import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/timeline_widget.dart';
import '../widgets/export_dialog.dart';

class EditorScreen extends StatefulWidget {
  final String projectName;
  const EditorScreen({super.key, required this.projectName});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late VideoEditorController _controller;
  String _selectedTool = 'clip'; // clip, text, audio, effect, color
  List<String> _videoClips = [];
  List<TextLayer> _textLayers = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoEditorController.file(
      FilePicker.platform.getFilePath() ?? '',
      durationMin: const Duration(seconds: 1),
      durationMax: const Duration(minutes: 30),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _importVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _videoClips.addAll(result.paths.map((e) => e!));
      });
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => ExportDialog(controller: _controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
            tooltip: 'บันทึก',
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {},
            tooltip: 'เลิกทำ',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: () {},
            tooltip: 'ทำซ้ำ',
          ),
        ],
      ),
      body: Column(
        children: [
          // พรีวิววิดีโอ
          Container(
            height: 220,
            color: Colors.black,
            child: Center(
              child: _videoClips.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 48,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ยังไม่มีคลิป',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _importVideo,
                          child: const Text('นำเข้าวิดีโอ'),
                        ),
                      ],
                    )
                  : const Icon(
                      Icons.play_arrow,
                      size: 64,
                      color: Colors.white,
                    ),
            ),
          ),
          
          // Timeline
          TimelineWidget(videoClips: _videoClips),
          
          // แถบเครื่องมือตัดต่อ
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildToolButton('clip', Icons.cut, 'ตัดต่อ'),
                _buildToolButton('text', Icons.text_fields, 'ข้อความ'),
                _buildToolButton('audio', Icons.audiotrack, 'เสียง'),
                _buildToolButton('effect', Icons.auto_awesome, 'เอฟเฟกต์'),
                _buildToolButton('color', Icons.color_lens, 'สี'),
                _buildToolButton('speed', Icons.speed, 'ความเร็ว'),
                _buildToolButton('crop', Icons.crop, 'ครอบ'),
                _buildToolButton('rotate', Icons.rotate_right, 'หมุน'),
                _buildToolButton('sticker', Icons.emoji_emotions, 'สติกเกอร์'),
                _buildToolButton('filter', Icons.filter, 'ฟิลเตอร์'),
              ],
            ),
          ),
          
          // แผงควบคุมตามเครื่องมือที่เลือก
          Container(
            height: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: _buildControlPanel(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {},
              tooltip: 'เล่น',
            ),
            IconButton(
              icon: const Icon(Icons.split),
              onPressed: () {},
              tooltip: 'แบ่งคลิป',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {},
              tooltip: 'ลบ',
            ),
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () {},
              tooltip: 'คัดลอก',
            ),
            const VerticalDivider(),
            ElevatedButton.icon(
              onPressed: _showExportDialog,
              icon: const Icon(Icons.download),
              label: const Text('ส่งออก'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(String tool, IconData icon, String label) {
    final isSelected = _selectedTool == tool;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon),
            color: isSelected ? Colors.blue : null,
            onPressed: () => setState(() => _selectedTool = tool),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    switch (_selectedTool) {
      case 'clip':
        return _buildClipPanel();
      case 'text':
        return _buildTextPanel();
      case 'audio':
        return _buildAudioPanel();
      case 'speed':
        return _buildSpeedPanel();
      default:
        return Center(
          child: Text(
            'เลือกเครื่องมือที่ต้องการใช้',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        );
    }
  }

  Widget _buildClipPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ตัดแต่งคลิป', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _importVideo,
                icon: const Icon(Icons.add),
                label: const Text('เพิ่มคลิป'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.trim),
                label: const Text('ตัดหัวท้าย'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextPanel() {
    TextEditingController textController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('เพิ่มข้อความ', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'พิมพ์ข้อความ...',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('เพิ่มข้อความเรียบร้อย')),
                  );
                  textController.clear();
                }
              },
              child: const Text('เพิ่ม'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTextStyleButton('B', FontWeight.bold),
              _buildTextStyleButton('I', null, fontStyle: FontStyle.italic),
              const SizedBox(width: 16),
              const Text('ขนาด:'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: 24,
                items: [16, 20, 24, 32, 40, 48].map((size) {
                  return DropdownMenuItem(value: size, child: Text('$size'));
                }).toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextStyleButton(String text, FontWeight? fontWeight, {FontStyle? fontStyle}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ปรับแต่งเสียง', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('ระดับเสียง:'),
            const SizedBox(width: 12),
            Expanded(
              child: Slider(
                value: 0.8,
                min: 0,
                max: 2,
                divisions: 20,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 8),
            const Text('80%'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.mic),
                label: const Text('อัดเสียงพากย์'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.music_note),
                label: const Text('เพิ่มเพลง'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ปรับความเร็ว', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('0.5x'),
            Expanded(
              child: Slider(
                value: 1.0,
                min: 0.25,
                max: 4,
                divisions: 15,
                onChanged: (value) {},
              ),
            ),
            const Text('4x'),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildSpeedChip('ช้ามาก', 0.25),
            _buildSpeedChip('ช้า', 0.5),
            _buildSpeedChip('ปกติ', 1.0),
            _buildSpeedChip('เร็ว', 1.5),
            _buildSpeedChip('เร็วมาก', 2.0),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeedChip(String label, double speed) {
    return FilterChip(
      label: Text(label),
      selected: false,
      onSelected: (_) {},
    );
  }
}

class TextLayer {
  String text;
  double x, y;
  double fontSize;
  Color color;

  TextLayer({
    required this.text,
    this.x = 0,
    this.y = 0,
    this.fontSize = 24,
    this.color = Colors.white,
  });
}
