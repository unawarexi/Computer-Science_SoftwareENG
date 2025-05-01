import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_dart_course/services/customApiservices/user_services.dart'; // <-- shared User model
import 'package:flutter_dart_course/RTC_communications/AgoraRTC/agora_functionality.dart'; // <-- Add this import
import 'package:flutter_dart_course/screens/RTC_communications/call_screen.dart'; // <-- Add this import

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _showAttachmentOptions = false;

  @override
  void initState() {
    super.initState();
    _loadDummyMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDummyMessages() {
    // Generate some dummy messages for demonstration
    final random = Random();
    final now = DateTime.now();
    
    // Add 10-15 dummy messages
    for (int i = 0; i < random.nextInt(6) + 10; i++) {
      final isMe = random.nextBool();
      final messageTime = now.subtract(Duration(minutes: (15 - i) * 10));
      
      _messages.add(Message(
        text: _getDummyMessageText(isMe, i),
        isMe: isMe,
        timestamp: messageTime,
        isRead: true,
      ));
    }
    
    // Add the last message as unread if from the other person
    _messages.add(Message(
      text: 'Hey, are you there?',
      isMe: false,
      timestamp: now.subtract(const Duration(minutes: 2)),
      isRead: false,
    ));
    
    // Sort messages by timestamp
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    // Scroll to bottom after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getDummyMessageText(bool isMe, int index) {
    final myMessages = [
      'Hey! How are you doing?',
      'Did you see that new movie that came out last weekend?',
      'I was thinking about going out for lunch today.',
      'What are you up to this weekend?',
      'Have you finished that project yet?',
      'I just got a new puppy! 🐶',
      'The weather is so nice today!',
      'Can we meet up next week?'
    ];
    
    final theirMessages = [
      'I\'m good, thanks for asking!',
      'Not yet, is it good?',
      'Sounds good! Where are you thinking?',
      'Nothing much, probably just relaxing.',
      'Almost done! Just need to finish a few things.',
      'Aww! Send pictures!',
      'It is! Perfect day for a walk.',
      'Sure, what day works for you?'
    ];
    
    final list = isMe ? myMessages : theirMessages;
    return list[index % list.length];
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add(Message(
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
        isRead: false,
      ));
      _messageController.clear();
    });
    
    // Scroll to bottom after message is sent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleAttachmentOptions() {
    setState(() {
      _showAttachmentOptions = !_showAttachmentOptions;
    });
  }

  // Helper to navigate to CallScreen
  void _navigateToCallScreen(CallType callType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallScreen(
          remoteUserId: widget.user.id.toString(),
          callType: callType,
          isIncoming: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              backgroundImage: widget.user.profilePicture != null
                  ? NetworkImage(widget.user.profilePicture!)
                  : null,
              child: widget.user.profilePicture == null
                  ? Text(
                      widget.user.fullName.isNotEmpty
                          ? widget.user.fullName.substring(0, 1).toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Active now',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              _navigateToCallScreen(CallType.audio);
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              _navigateToCallScreen(CallType.video);
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conversation info')),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final showTimestamp = index == 0 || 
                      _messages[index].timestamp.difference(_messages[index - 1].timestamp).inMinutes > 15;
                      
                  return Column(
                    children: [
                      if (showTimestamp)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            _formatTimestamp(message.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      MessageBubble(message: message),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // Attachment options panel
          if (_showAttachmentOptions)
            Container(
              height: 100,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildAttachmentOption(Icons.image, Colors.green, 'Photos'),
                  _buildAttachmentOption(Icons.camera_alt, Colors.purple, 'Camera'),
                  _buildAttachmentOption(Icons.mic, Colors.orange, 'Audio'),
                  _buildAttachmentOption(Icons.insert_drive_file, Colors.blue, 'Files'),
                  _buildAttachmentOption(Icons.location_on, Colors.red, 'Location'),
                  _buildAttachmentOption(Icons.person, Colors.teal, 'Contact'),
                ],
              ),
            ),
          
          // Message input area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showAttachmentOptions ? Icons.close : Icons.add,
                    color: Colors.blue,
                  ),
                  onPressed: _toggleAttachmentOptions,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera access requested')),
                    );
                  },
                ),
                // Message text field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Aa',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.thumb_up,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _messages.add(Message(
                        text: '👍',
                        isMe: true,
                        timestamp: DateTime.now(),
                        isRead: false,
                      ));
                    });
                    
                    // Scroll to bottom after thumbs up is sent
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, Color color, String label) {
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 365) {
      return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
    } else if (difference.inDays > 7) {
      return '${timestamp.month}/${timestamp.day}';
    } else if (difference.inDays > 0) {
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return weekdays[timestamp.weekday - 1];
    } else {
      final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour == 0 ? 12 : timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = timestamp.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            if (message.isMe)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(
                        color: message.isMe ? Colors.white70 : Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      message.isRead ? Icons.done_all : Icons.done,
                      size: 12,
                      color: message.isMe ? Colors.white70 : Colors.black54,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.isRead,
  });
}