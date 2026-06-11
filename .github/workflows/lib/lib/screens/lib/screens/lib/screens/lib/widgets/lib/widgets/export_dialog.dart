import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';

class ExportDialog extends StatefulWidget {
  final VideoEditorController controller;
  
  const ExportDialog({
    super.key,
    required this.controller,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String _selectedResolution = '1080p';
  String _selectedFps = '30';
  String _selectedCodec = 'H.264';
  String _selectedBitrate = 'ปกติ';
  bool _isExporting = false;
  double _exportProgress = 0.0;
  
  final List<Map<String, String>> _resolutions = [
    {'label': '480p (SD)', 'value': '480p', 'width': '854', 'height': '480'},
    {'label': '720p (HD)', 'value': '720p', 'width': '1280', 'height': '720'},
    {'label': '1080p (FHD)', 'value': '1080p', 'width': '1920', 'height': '1080'},
    {'label': '2K (QHD)', 'value': '2K', 'width': '2560', 'height': '1440'},
    {'label': '4K (UHD)', 'value': '4K', 'width': '3840', 'height': '2160'},
  ];
  
  final List<String> _fpsOptions = ['24', '25', '30', '50', '60'];
  final List<String> _codecOptions = ['H.264', 'H.265', 'ProRes'];
  final List<String> _bitrateOptions = ['ต่ำ', 'ปกติ', 'สูง', 'กำหนดเอง'];
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: _isExporting ? _buildExportProgress() : _buildExportOptions(),
      ),
    );
  }
  
  Widget _buildExportOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // หัวข้อ
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.download, color: Colors.green),
            ),
            const SizedBox(width: 12),
            const Text(
              'ส่งออกวิดีโอ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        const Divider(),
        
        // ความละเอียด
        const Text('ความละเอียด', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _resolutions.map((res) {
            return FilterChip(
              label: Text(res['label']!),
              selected: _selectedResolution == res['value'],
              onSelected: (selected) {
                setState(() {
                  _selectedResolution = res['value']!;
                });
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // FPS
        const Text('เฟรมเรท (FPS)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _fpsOptions.map((fps) {
            return FilterChip(
              label: Text('$fps fps'),
              selected: _selectedFps == fps,
              onSelected: (selected) {
                setState(() {
                  _selectedFps = fps;
                });
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Codec
        const Text('ตัวแปลงสัญญาณ', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: _codecOptions.map((codec) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCodec = codec;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedCodec == codec
                        ? (isDark ? Colors.blue.shade900 : Colors.blue.shade50)
                        : null,
                    side: BorderSide(
                      color: _selectedCodec == codec
                          ? Colors.blue
                          : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                    ),
                  ),
                  child: Text(codec),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // Bitrate
        const Text('คุณภาพ (Bitrate)', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: _bitrateOptions.map((bitrate) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedBitrate = bitrate;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedBitrate == bitrate
                        ? (isDark ? Colors.blue.shade900 : Colors.blue.shade50)
                        : null,
                  ),
                  child: Text(bitrate),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 24),
        
        // ปุ่มยกเลิกและส่งออก
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _startExport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('ส่งออก'),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // ข้อมูลขนาดไฟล์โดยประมาณ
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getEstimatedSize(),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildExportProgress() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.hourglass_top, size: 48, color: Colors.green),
        const SizedBox(height: 16),
        const Text(
          'กำลังส่งออกวิดีโอ...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'กรุณารอสักครู่',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: _exportProgress,
          backgroundColor: Colors.grey.shade300,
          color: Colors.green,
        ),
        const SizedBox(height: 8),
        Text('${(_exportProgress * 100).toInt()}%'),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ยกเลิก'),
        ),
      ],
    );
  }
  
  void _startExport() async {
    setState(() {
      _isExporting = true;
    });
    
    // จำลองการส่งออก (ในแอปจริงจะเรียก FFmpeg หรือ export function จริง)
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          _exportProgress = i / 100;
        });
      }
    }
    
    // ส่งออกเสร็จ
    if (mounted) {
      setState(() {
        _isExporting = false;
      });
      
      // แสดง success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('ส่งออกสำเร็จ'),
            ],
          ),
          content: const Text('วิดีโอของคุณถูกบันทึกไว้ในอัลบั้มแล้ว'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด success dialog
                Navigator.pop(context); // ปิด export dialog
              },
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
    }
  }
  
  String _getEstimatedSize() {
    // คำนวณขนาดไฟล์โดยประมาณ (MB)
    double duration = 60; // สมมติวิดีโอ 60 วินาที
    
    Map<String, double> bitrateMap = {
      'ต่ำ': 1.0,
      'ปกติ': 2.5,
      'สูง': 5.0,
      'กำหนดเอง': 4.0,
    };
    
    double bitrate = bitrateMap[_selectedBitrate] ?? 2.5;
    double estimatedMB = duration * bitrate / 8;
    
    if (estimatedMB > 1024) {
      return 'ขนาดโดยประมาณ: ${(estimatedMB / 1024).toStringAsFixed(1)} GB';
    }
    return 'ขนาดโดยประมาณ: ${estimatedMB.toStringAsFixed(0)} MB';
  }
}
