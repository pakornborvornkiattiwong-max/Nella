import 'package:flutter/material.dart';

class TimelineWidget extends StatefulWidget {
  final List<String> videoClips;
  
  const TimelineWidget({
    super.key,
    required this.videoClips,
  });

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  double _currentPosition = 0.0;
  double _zoomLevel = 1.0;
  int _selectedTrack = 0;
  List<Track> _tracks = [];
  
  @override
  void initState() {
    super.initState();
    // สร้าง Track เริ่มต้น 3 แทร็ก
    _tracks = [
      Track(name: 'V1', type: TrackType.video, clips: []),
      Track(name: 'V2', type: TrackType.video, clips: []),
      Track(name: 'A1', type: TrackType.audio, clips: []),
    ];
    
    // เพิ่มคลิปตัวอย่าง
    for (int i = 0; i < widget.videoClips.length; i++) {
      _tracks[0].clips.add(Clip(
        id: i,
        name: 'คลิป ${i + 1}',
        duration: 5.0,
        startTime: i * 5.0,
      ));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 180,
      color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
      child: Column(
        children: [
          // แถบเครื่องมือ Timeline
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
              ),
            ),
            child: Row(
              children: [
                // ปุ่มซูม
                IconButton(
                  icon: const Icon(Icons.zoom_out, size: 20),
                  onPressed: () {
                    setState(() {
                      if (_zoomLevel > 0.5) _zoomLevel -= 0.1;
                    });
                  },
                  tooltip: 'ซูมออก',
                ),
                Text(
                  '${(_zoomLevel * 100).toInt()}%',
                  style: const TextStyle(fontSize: 12),
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_in, size: 20),
                  onPressed: () {
                    setState(() {
                      if (_zoomLevel < 2.0) _zoomLevel += 0.1;
                    });
                  },
                  tooltip: 'ซูมเข้า',
                ),
                const VerticalDivider(),
                // ปุ่ม Snap
                IconButton(
                  icon: const Icon(Icons.grid_on, size: 20),
                  onPressed: () {},
                  tooltip: 'Snap',
                ),
                // ปุ่ม Magnetic Timeline
                IconButton(
                  icon: const Icon(Icons.magnet, size: 20),
                  onPressed: () {},
                  tooltip: 'Magnetic Timeline',
                ),
                const Spacer(),
                // แสดงเวลาทั้งหมด
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getTotalDuration(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          
          // แถบ Timeline จริง
          Expanded(
            child: ListView.builder(
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                return _buildTrack(_tracks[index], index);
              },
            ),
          ),
          
          // แถบเลื่อนตำแหน่ง
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  _formatTime(_currentPosition),
                  style: const TextStyle(fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    value: _currentPosition,
                    min: 0,
                    max: _getTotalDurationInSeconds(),
                    onChanged: (value) {
                      setState(() {
                        _currentPosition = value;
                      });
                    },
                  ),
                ),
                Text(
                  _formatTime(_getTotalDurationInSeconds()),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrack(Track track, int trackIndex) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedTrack == trackIndex;
    
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        color: isDark 
            ? (isSelected ? Colors.grey.shade800 : Colors.grey.shade850)
            : (isSelected ? Colors.grey.shade300 : Colors.grey.shade200),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // ชื่อ Track
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: track.type == TrackType.video 
                  ? Colors.blue.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              border: Border(
                right: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  track.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: track.type == TrackType.video ? Colors.blue : Colors.green,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 12,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // พื้นที่วางคลิป
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    for (int i = 0; i < track.clips.length; i++)
                      _buildClipItem(track.clips[i], track.type),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildClipItem(Clip clip, TrackType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = clip.duration * 20 * _zoomLevel;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPosition = clip.startTime;
        });
      },
      child: Container(
        width: width.clamp(40.0, 300.0),
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
        decoration: BoxDecoration(
          color: type == TrackType.video
              ? Colors.blue.shade700
              : Colors.green.shade700,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // เนื้อหาคลิป
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    type == TrackType.video ? Icons.videocam : Icons.audiotrack,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      clip.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            
            // แถบเลื่อนตัด (Trim Handle)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 8,
                color: Colors.white.withOpacity(0.5),
                child: const Icon(Icons.chevron_left, size: 8),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 8,
                color: Colors.white.withOpacity(0.5),
                child: const Icon(Icons.chevron_right, size: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  double _getTotalDurationInSeconds() {
    double maxTime = 0;
    for (var track in _tracks) {
      for (var clip in track.clips) {
        maxTime = maxTime > (clip.startTime + clip.duration) 
            ? maxTime 
            : (clip.startTime + clip.duration);
      }
    }
    return maxTime == 0 ? 30.0 : maxTime;
  }
  
  String _getTotalDuration() {
    return _formatTime(_getTotalDurationInSeconds());
  }
  
  String _formatTime(double seconds) {
    final int mins = (seconds / 60).floor();
    final int secs = (seconds % 60).floor();
    final int ms = ((seconds - secs) * 100).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.$ms';
  }
}

// โมเดลข้อมูล
enum TrackType { video, audio }

class Track {
  String name;
  TrackType type;
  List<Clip> clips;
  bool isVisible;
  bool isLocked;
  
  Track({
    required this.name,
    required this.type,
    required this.clips,
    this.isVisible = true,
    this.isLocked = false,
  });
}

class Clip {
  int id;
  String name;
  double duration;
  double startTime;
  String? thumbnailPath;
  
  Clip({
    required this.id,
    required this.name,
    required this.duration,
    required this.startTime,
    this.thumbnailPath,
  });
}
