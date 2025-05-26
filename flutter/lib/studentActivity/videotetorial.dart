import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _volume = 1.0;
  bool _isMaximized = true;
  double _playbackSpeed = 1.0;
  late AnimationController _animationController;
  bool _showControls = true;
  final List<String> _playlist = [
    'assets/videos/mathc1p1.mp4',
    'assets/videos/mathc1p2.mp4',
    'assets/videos/mathc1p3.mp4',
  ];
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeVideoController();
  }

  void _initializeVideoController() {
    _controller = VideoPlayerController.asset(_playlist[_currentVideoIndex])
      ..initialize().then((_) {
        setState(() {});
        if (_isPlaying) _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
        _animationController.reverse();
      } else {
        _controller.play();
        _isPlaying = true;
        _animationController.forward();
      }
    });
  }

  void _seekBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 20);
    _controller.seekTo(newPosition);
  }

  void _seekForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 20);
    _controller.seekTo(newPosition);
  }

  void _seekToFirst() {
    _controller.seekTo(Duration.zero);
    setState(() {});
  }

  void _playNextVideo() {
    setState(() {
      _controller.pause();
      _controller.dispose();
      _currentVideoIndex = (_currentVideoIndex + 1) % _playlist.length;
      _initializeVideoController();
    });
  }

  void _playVideoAtIndex(int index) {
    setState(() {
      _controller.pause();
      _controller.dispose();
      _currentVideoIndex = index;
      _initializeVideoController();
    });
  }

  void _updateVolume(double value) {
    setState(() {
      _volume = value;
      _controller.setVolume(value);
    });
  }

  void _toggleMaximizeMinimize() {
    setState(() {
      _isMaximized = !_isMaximized;
    });
  }

  void _setPlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _controller.setPlaybackSpeed(speed);
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double screenWidth = 1;
  @override
  Widget build(BuildContext context) {
    setState(() {
      screenWidth = MediaQuery.of(context).size.width;
    });
    final videoWidth = _isMaximized ? screenWidth : screenWidth * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Player - ${_playlist[_currentVideoIndex].split('/').last}',
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: screenWidth * 0.8,
            padding: EdgeInsets.only(left: screenWidth * 0.15),
            child:
                _controller.value.isInitialized
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _toggleControls,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: videoWidth),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  ),
                                  Positioned.fill(
                                    child: AnimatedOpacity(
                                      opacity: _showControls ? 1.0 : 0.0,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: IconButton(
                                            iconSize: 48,
                                            icon: AnimatedIcon(
                                              icon: AnimatedIcons.play_pause,
                                              progress: _animationController,
                                              color: Colors.white,
                                            ),
                                            onPressed: _togglePlayPause,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedOpacity(
                          opacity: _showControls ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                  colors: const VideoProgressColors(
                                    playedColor: Colors.blue,
                                    bufferedColor: Colors.white30,
                                    backgroundColor: Colors.white12,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatDuration(_controller.value.position),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Text(
                                    ' / ',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  Text(
                                    _formatDuration(_controller.value.duration),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildControlButton(
                                    icon: Icons.skip_previous,
                                    onPressed: _seekToFirst,
                                    tooltip: 'Back to Start',
                                  ),
                                  const SizedBox(width: 8),
                                  _buildControlButton(
                                    icon: Icons.replay_10,
                                    onPressed: _seekBackward,
                                    tooltip: 'Rewind 20 seconds',
                                  ),
                                  const SizedBox(width: 8),
                                  _buildControlButton(
                                    icon:
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                    onPressed: _togglePlayPause,
                                    tooltip: _isPlaying ? 'Pause' : 'Play',
                                  ),
                                  const SizedBox(width: 8),
                                  _buildControlButton(
                                    icon: Icons.forward_10,
                                    onPressed: _seekForward,
                                    tooltip: 'Forward 20 seconds',
                                  ),
                                  const SizedBox(width: 8),
                                  _buildControlButton(
                                    icon: Icons.skip_next,
                                    onPressed: _playNextVideo,
                                    tooltip: 'Next Video',
                                  ),
                                  const SizedBox(width: 8),
                                  _buildControlButton(
                                    icon:
                                        _isMaximized
                                            ? Icons.fullscreen_exit
                                            : Icons.fullscreen,
                                    onPressed: _toggleMaximizeMinimize,
                                    tooltip:
                                        _isMaximized ? 'Minimize' : 'Maximize',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.volume_up, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Slider(
                                        value: _volume,
                                        onChanged: _updateVolume,
                                        min: 0.0,
                                        max: 1.0,
                                        activeColor: Colors.blue,
                                        inactiveColor: Colors.white12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    DropdownButton<double>(
                                      value: _playbackSpeed,
                                      dropdownColor: Colors.black87,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 0.5,
                                          child: Text('0.5x'),
                                        ),
                                        DropdownMenuItem(
                                          value: 1.0,
                                          child: Text('1.0x'),
                                        ),
                                        DropdownMenuItem(
                                          value: 1.5,
                                          child: Text('1.5x'),
                                        ),
                                        DropdownMenuItem(
                                          value: 2.0,
                                          child: Text('2.0x'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null)
                                          _setPlaybackSpeed(value);
                                      },
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Playlist',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _playlist.length,
                          itemBuilder: (context, index) {
                            final videoName = _playlist[index].split('/').last;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    _currentVideoIndex == index
                                        ? Colors.blue
                                        : Colors.green,
                                child: const Icon(
                                  Icons.video_call,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                videoName,
                                style: TextStyle(
                                  color:
                                      _currentVideoIndex == index
                                          ? Colors.blue
                                          : Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                'Video ${index + 1}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              onTap: () => _playVideoAtIndex(index),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: screenWidth * 1.2,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Explore more content below the video player. This area is scrollable both vertically and horizontally to accommodate additional information or controls.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    )
                    : const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }
}
