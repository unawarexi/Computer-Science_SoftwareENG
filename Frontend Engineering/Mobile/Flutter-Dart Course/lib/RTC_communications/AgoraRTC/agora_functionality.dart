import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dart_course/RTC_communications/AgoraRTC/agora_history_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter_dart_course/services/network_service.dart'; // Add this import
import 'package:get/get.dart';

class AgoraManager {
  // Singleton instance
  static final AgoraManager _instance = AgoraManager._internal();
  factory AgoraManager() => _instance;
  AgoraManager._internal();

  // Your Agora App ID - replace with your actual App ID
  final String appId = "09d685e1fb314167bd586ba38b45d4ea";
  
  // Agora engine instance
  RtcEngine? _engine;
  
  // Channel name for the current call
  String? _currentChannelName;
  
  // Call related information
  String? _currentCallId;
  int? _localUid;
  List<int> _remoteUids = [];
  bool _isInCall = false;
  bool _isVideoEnabled = true;
  bool _isAudioEnabled = true;
  bool _isSpeakerEnabled = true;
  CallType _currentCallType = CallType.video;
  CallRole _callRole = CallRole.caller;
  String? _remoteUserId;
  DateTime? _callStartTime;
  
  // History service for storing call logs
  final HistoryService _historyService = HistoryService();
  
  // Stream controllers for call events
  final _onCallEndedController = StreamController<void>.broadcast();
  final _onRemoteUserJoinedController = StreamController<int>.broadcast();
  final _onRemoteUserLeftController = StreamController<int>.broadcast();
  final _onLocalUserJoinedController = StreamController<int>.broadcast();
  final _onCallStateChangedController = StreamController<CallState>.broadcast();

  // Add a subscription to listen to network changes
  StreamSubscription? _networkSubscription;

  // Getters for streams
  Stream<void> get onCallEnded => _onCallEndedController.stream;
  Stream<int> get onRemoteUserJoined => _onRemoteUserJoinedController.stream;
  Stream<int> get onRemoteUserLeft => _onRemoteUserLeftController.stream;
  Stream<int> get onLocalUserJoined => _onLocalUserJoinedController.stream;
  Stream<CallState> get onCallStateChanged => _onCallStateChangedController.stream;
  
  // Getters for call information
  bool get isInCall => _isInCall;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isSpeakerEnabled => _isSpeakerEnabled;
  String? get currentChannelName => _currentChannelName;
  String? get currentCallId => _currentCallId;
  List<int> get remoteUids => _remoteUids;
  int? get localUid => _localUid;
  CallType get currentCallType => _currentCallType;

  // Initialize Agora Engine
  Future<void> initialize() async {
    if (_engine != null) return;
    
    // Create RTC engine instance
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // Register event handlers
    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: _onJoinChannelSuccess,
      onUserJoined: _onUserJoined,
      onUserOffline: _onUserOffline,
      onLeaveChannel: _onLeaveChannel,
      onError: _onError,
      onConnectionStateChanged: _onConnectionStateChanged,
      onRtcStats: _onRtcStats,
      onFirstRemoteVideoFrame: _onFirstRemoteVideoFrame,
    ));

    // Listen to network status changes
    _networkSubscription ??= Get.find<NetworkService>().networkStatus.listen((status) {
      _handleNetworkStatusChange(status);
    });
  }

  // Clean up resources
  Future<void> dispose() async {
    await _onCallEndedController.close();
    await _onRemoteUserJoinedController.close();
    await _onRemoteUserLeftController.close();
    await _onLocalUserJoinedController.close();
    await _onCallStateChangedController.close();
    
    await leaveCall();
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;

    await _networkSubscription?.cancel(); // Cancel network subscription
    _networkSubscription = null;
  }

  // Request necessary permissions for call
  Future<bool> _requestPermissions(CallType callType) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      if (callType == CallType.video) Permission.camera,
    ].request();
    
    return statuses.values.every((status) => status.isGranted);
  }

  // Start a call
  Future<bool> startCall({
    required String remoteUserId,
    required CallType callType,
    String? specificChannelName,
  }) async {
    if (_isInCall) return false;
    
    // Request needed permissions
    if (!await _requestPermissions(callType)) {
      return false;
    }
    
    await initialize();
    
    // Generate unique channel name if not provided
    _currentChannelName = specificChannelName ?? _generateChannelName(remoteUserId);
    _currentCallId = const Uuid().v4();
    _currentCallType = callType;
    _callRole = CallRole.caller;
    _remoteUserId = remoteUserId;
    _callStartTime = DateTime.now();
    
    // Set media options based on call type
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableAudio();
    
    if (callType == CallType.video) {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } else {
      await _engine!.disableVideo();
    }
    
    // Join channel
    await _engine!.joinChannel(
      token: "", // Use token server in production
      channelId: _currentChannelName!,
      uid: 0, // 0 means auto-assign
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
    
    _isInCall = true;
    _onCallStateChangedController.add(CallState.connecting);
    
    return true;
  }

  // Answer an incoming call
  Future<bool> answerCall({
    required String channelName,
    required String callerId,
    required CallType callType,
    required String callId,
  }) async {
    if (_isInCall) return false;
    
    // Request needed permissions
    if (!await _requestPermissions(callType)) {
      return false;
    }
    
    await initialize();
    
    _currentChannelName = channelName;
    _currentCallId = callId;
    _currentCallType = callType;
    _callRole = CallRole.receiver;
    _remoteUserId = callerId;
    _callStartTime = DateTime.now();
    
    // Set media options based on call type
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableAudio();
    
    if (callType == CallType.video) {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } else {
      await _engine!.disableVideo();
    }
    
    // Join channel
    await _engine!.joinChannel(
      token: "", // Use token server in production
      channelId: _currentChannelName!,
      uid: 0, // 0 means auto-assign
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
    
    _isInCall = true;
    _onCallStateChangedController.add(CallState.connecting);
    
    return true;
  }
  
  // Leave the current call
  Future<void> leaveCall({CallStatus status = CallStatus.completed}) async {
    if (!_isInCall) return;
    
    // Record call history
    if (_currentCallId != null && _callStartTime != null) {
      final callHistory = CallHistory(
        id: _currentCallId!,
        remoteUserId: _remoteUserId ?? 'unknown',
        startTime: _callStartTime!,
        endTime: DateTime.now(),
        duration: DateTime.now().difference(_callStartTime!).inSeconds,
        type: _currentCallType,
        status: status,
        isOutgoing: _callRole == CallRole.caller,
      );
      
      await _historyService.saveCallHistory(callHistory);
    }
    
    // Stop preview and leave channel
    if (_currentCallType == CallType.video) {
      await _engine?.stopPreview();
    }
    
    await _engine?.leaveChannel();
    
    // Reset call state
    _isInCall = false;
    _remoteUids.clear();
    _currentChannelName = null;
    _currentCallId = null;
    _localUid = null;
    _remoteUserId = null;
    _callStartTime = null;
    
    _onCallEndedController.add(null);
    _onCallStateChangedController.add(CallState.disconnected);
  }
  
  // Reject incoming call (before answering)
  Future<void> rejectCall({required String callId}) async {
    // Simply save the rejection in history
    final callHistory = CallHistory(
      id: callId,
      remoteUserId: _remoteUserId ?? 'unknown',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      duration: 0,
      type: _currentCallType,
      status: CallStatus.rejected,
      isOutgoing: false,
    );
    
    await _historyService.saveCallHistory(callHistory);
  }

  // Toggle video on/off
  Future<void> toggleVideo() async {
    if (!_isInCall) return;
    
    _isVideoEnabled = !_isVideoEnabled;
    
    if (_isVideoEnabled) {
      await _engine!.enableVideo();
      await _engine!.startPreview();
    } else {
      await _engine!.disableVideo();
      await _engine!.stopPreview();
    }
  }

  // Toggle audio on/off (mute/unmute)
  Future<void> toggleAudio() async {
    if (!_isInCall) return;
    
    _isAudioEnabled = !_isAudioEnabled;
    await _engine!.muteLocalAudioStream(!_isAudioEnabled);
  }

  // Toggle speaker on/off
  Future<void> toggleSpeaker() async {
    if (!_isInCall) return;
    
    _isSpeakerEnabled = !_isSpeakerEnabled;
    await _engine!.setEnableSpeakerphone(_isSpeakerEnabled);
  }

  // Switch between front and back camera
  Future<void> switchCamera() async {
    if (!_isInCall || _currentCallType != CallType.video) return;
    
    await _engine!.switchCamera();
  }

  // Get call history
  Future<List<CallHistory>> getCallHistory() async {
    return await _historyService.getCallHistory();
  }

  // Delete a call from history
  Future<void> deleteCallHistory(String callId) async {
    await _historyService.deleteCallHistory(callId);
  }

  // Delete all call history
  Future<void> clearCallHistory() async {
    await _historyService.clearCallHistory();
  }

  // Event handler implementations
  void _onJoinChannelSuccess(RtcConnection connection, int elapsed) {
    _localUid = connection.localUid;
    if (connection.localUid != null) {
      _onLocalUserJoinedController.add(connection.localUid!);
    }
    _onCallStateChangedController.add(CallState.connected);
  }

  void _onUserJoined(RtcConnection connection, int remoteUid, int elapsed) {
    if (!_remoteUids.contains(remoteUid)) {
      _remoteUids.add(remoteUid);
      _onRemoteUserJoinedController.add(remoteUid);
    }
  }

  void _onUserOffline(RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
    _remoteUids.remove(remoteUid);
    _onRemoteUserLeftController.add(remoteUid);
    
    // If all remote users left, end the call
    if (_remoteUids.isEmpty) {
      leaveCall(status: CallStatus.completed);
    }
  }

  void _onLeaveChannel(RtcConnection connection, RtcStats stats) {
    _remoteUids.clear();
    _isInCall = false;
  }

  void _onError(ErrorCodeType err, String msg) {
    print("Agora error: code $err, message: $msg");
    _onCallStateChangedController.add(CallState.error);
  }
  
  void _onConnectionStateChanged(RtcConnection connection, ConnectionStateType state, ConnectionChangedReasonType reason) {
    switch (state) {
      case ConnectionStateType.connectionStateConnecting:
        _onCallStateChangedController.add(CallState.connecting);
        break;
      case ConnectionStateType.connectionStateConnected:
        _onCallStateChangedController.add(CallState.connected);
        break;
      case ConnectionStateType.connectionStateDisconnected:
      case ConnectionStateType.connectionStateFailed:
        _onCallStateChangedController.add(CallState.disconnected);
        break;
      default:
        break;
    }
  }
  
  void _onRtcStats(RtcConnection connection, RtcStats stats) {
    // Useful for monitoring call quality and duration
  }
  
  void _onFirstRemoteVideoFrame(RtcConnection connection, int remoteUid, int width, int height, int elapsed) {
    // First video frame received
  }

  // Add a handler for custom network status changes
  void _handleNetworkStatusChange(NetworkStatus status) {
    if (!_isInCall) return;
    if (status == NetworkStatus.offline || status == NetworkStatus.unstable) {
      // Optionally, you can leave the call or notify the user
      leaveCall(status: CallStatus.missed);
      // Optionally, notify UI or show a dialog/toast
    }
    // Optionally, handle slow/online status as needed
  }

  // Helper method to generate channel name
  String _generateChannelName(String remoteUserId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'call_${const Uuid().v4()}_$timestamp';
  }
  
  // Method to create a Widget for local video view
  Widget getLocalVideoView() {
    if (!_isInCall || !_isVideoEnabled) {
      return Container(color: Colors.black);
    }
    
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }
  
  // Method to create a Widget for remote video view
  Widget getRemoteVideoView(int remoteUid) {
    if (!_isInCall || !_remoteUids.contains(remoteUid)) {
      return Container(color: Colors.black);
    }
    
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: _currentChannelName!),
      ),
    );
  }

  // Conference call specific methods
  Future<bool> startConferenceCall({
    required String conferenceId,
    required List<String> participantIds,
    required CallType callType,
  }) async {
    // A conference call is just a call with multiple participants
    return await startCall(
      remoteUserId: conferenceId,
      callType: callType,
      specificChannelName: 'conference_$conferenceId',
    );
  }
  
  // Method to invite additional users to an ongoing call
  Future<bool> inviteToCall({required String userId}) async {
    if (!_isInCall) return false;
    
    // In a real app, you would trigger a push notification or signal to the user
    // This is just a placeholder for the implementation
    
    return true;
  }
}

// Enums for call state management
enum CallType { audio, video }

enum CallRole { caller, receiver }

enum CallState { connecting, connected, disconnected, error }

enum CallStatus { completed, missed, rejected }

// Call history model
class CallHistory {
  final String id;
  final String remoteUserId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // in seconds
  final CallType type;
  final CallStatus status;
  final bool isOutgoing;

  CallHistory({
    required this.id,
    required this.remoteUserId,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.type,
    required this.status,
    required this.isOutgoing,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remoteUserId': remoteUserId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration,
      'type': type.toString(),
      'status': status.toString(),
      'isOutgoing': isOutgoing,
    };
  }

  // Create from JSON
  factory CallHistory.fromJson(Map<String, dynamic> json) {
    return CallHistory(
      id: json['id'],
      remoteUserId: json['remoteUserId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: json['duration'],
      type: _parseCallType(json['type']),
      status: _parseCallStatus(json['status']),
      isOutgoing: json['isOutgoing'],
    );
  }
  
  // Helper to parse call type from string
  static CallType _parseCallType(String type) {
    if (type.contains('video')) {
      return CallType.video;
    }
    return CallType.audio;
  }
  
  // Helper to parse call status from string
  static CallStatus _parseCallStatus(String status) {
    if (status.contains('missed')) {
      return CallStatus.missed;
    } else if (status.contains('rejected')) {
      return CallStatus.rejected;
    }
    return CallStatus.completed;
  }
}