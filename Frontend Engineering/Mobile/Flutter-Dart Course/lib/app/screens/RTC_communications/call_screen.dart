import 'package:flutter/material.dart';
import 'package:flutter_dart_course/RTC_communications/AgoraRTC/agora_functionality.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class CallScreen extends StatefulWidget {
  final String remoteUserId;
  final CallType callType;
  final bool isIncoming;
  final String? channelName;
  final String? callId;

  const CallScreen({
    super.key,
    required this.remoteUserId,
    required this.callType,
    this.isIncoming = false,
    this.channelName,
    this.callId,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraManager _agoraManager = AgoraManager();
  bool _isConnecting = true;
  CallState _callState = CallState.connecting;
  String _callDuration = '00:00';
  int _secondsElapsed = 0;
  bool _isSpeakerOn = true;
  
  @override
  void initState() {
    super.initState();
    _setupCall();
    _setupListeners();
    // Keep screen on during call
   WakelockPlus.enable();
  }
  
  Future<void> _setupCall() async {
    bool callStarted = false;
    
    if (widget.isIncoming && widget.channelName != null && widget.callId != null) {
      // Answer incoming call
      callStarted = await _agoraManager.answerCall(
        channelName: widget.channelName!,
        callerId: widget.remoteUserId,
        callType: widget.callType,
        callId: widget.callId!,
      );
    } else {
      // Start outgoing call
      callStarted = await _agoraManager.startCall(
        remoteUserId: widget.remoteUserId,
        callType: widget.callType,
      );
    }
    
    if (!callStarted) {
      // Handle failure to start call
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start call. Please check permissions.')),
        );
        Navigator.of(context).pop();
      }
    }
  }
  
  void _setupListeners() {
    // Listen for call state changes
    _agoraManager.onCallStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _callState = state;
          _isConnecting = state == CallState.connecting;
        });
      }
    });
    
    // Timer for call duration
    Stream.periodic(const Duration(seconds: 1)).listen((event) {
      if (_callState == CallState.connected && mounted) {
        setState(() {
          _secondsElapsed++;
          _callDuration = _formatDuration(_secondsElapsed);
        });
      }
    });
    
    // Listen for call end
    _agoraManager.onCallEnded.listen((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
  
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    // End call if screen is closed
    _agoraManager.leaveCall();
    // Allow screen to turn off again
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main video view
          widget.callType == CallType.video
              ? _buildVideoCallView()
              : _buildAudioCallView(),
          
          // Call controls overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isConnecting ? 'Connecting...' : _callDuration,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildControlButton(
                        icon: _agoraManager.isAudioEnabled
                            ? Icons.mic
                            : Icons.mic_off,
                        label: _agoraManager.isAudioEnabled ? 'Mute' : 'Unmute',
                        onPressed: () {
                          _agoraManager.toggleAudio();
                          setState(() {});
                        },
                      ),
                      _buildControlButton(
                        icon: Icons.call_end,
                        label: 'End',
                        backgroundColor: Colors.red,
                        onPressed: () {
                          _agoraManager.leaveCall();
                          Navigator.of(context).pop();
                        },
                      ),
                      _buildControlButton(
                        icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                        label: _isSpeakerOn ? 'Speaker' : 'Earpiece',
                        onPressed: () {
                          _agoraManager.toggleSpeaker();
                          setState(() {
                            _isSpeakerOn = !_isSpeakerOn;
                          });
                        },
                      ),
                    ],
                  ),
                  if (widget.callType == CallType.video) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: _agoraManager.isVideoEnabled
                              ? Icons.videocam
                              : Icons.videocam_off,
                          label: _agoraManager.isVideoEnabled ? 'Video' : 'No Video',
                          onPressed: () {
                            _agoraManager.toggleVideo();
                            setState(() {});
                          },
                        ),
                        _buildControlButton(
                          icon: Icons.switch_camera,
                          label: 'Switch',
                          onPressed: () {
                            _agoraManager.switchCamera();
                          },
                        ),
                        // Add more video-specific controls as needed
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // User info at top
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  widget.remoteUserId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getCallStateText(),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getCallStateText() {
    switch (_callState) {
      case CallState.connecting:
        return 'Connecting...';
      case CallState.connected:
        return widget.callType == CallType.video ? 'Video Call' : 'Audio Call';
      case CallState.disconnected:
        return 'Call Ended';
      case CallState.error:
        return 'Call Error';
      default:
        return '';
    }
  }
  
  Widget _buildVideoCallView() {
    return Stack(
      children: [
        // Remote video (full screen)
        if (_agoraManager.remoteUids.isNotEmpty)
          Positioned.fill(
            child: _agoraManager.getRemoteVideoView(_agoraManager.remoteUids.first),
          )
        else
          const Positioned.fill(
            child: Center(
              child: Text(
                'Waiting for other user to join...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        
        // Local video (picture-in-picture)
        if (_agoraManager.isVideoEnabled)
          Positioned(
            right: 20,
            top: 120,
            width: 120,
            height: 180,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _agoraManager.getLocalVideoView(),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildAudioCallView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              widget.remoteUserId[0].toUpperCase(),
              style: TextStyle(
                fontSize: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.remoteUserId,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white24,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RawMaterialButton(
          onPressed: onPressed,
          constraints: const BoxConstraints(minWidth: 60, minHeight: 60),
          shape: const CircleBorder(),
          fillColor: backgroundColor,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}