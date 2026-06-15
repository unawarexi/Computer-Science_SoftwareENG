import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_dart_course/services/customApiservices/user_services.dart'; // <-- shared User model
import 'package:flutter_dart_course/services/customApiservices/auth_services.dart';
import 'chat_screen.dart';
import 'call_history_screen.dart';

class OverviewUsers extends StatefulWidget {
  const OverviewUsers({
    super.key,
  });

  @override
  State<OverviewUsers> createState() => _OverviewUsersState();
}

class _OverviewUsersState extends State<OverviewUsers> with SingleTickerProviderStateMixin {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  bool _isSelectionMode = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _isLoggedIn = false;
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    
    // Check login status then load users
    _checkLoginStatusAndLoadUsers();
    
    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        if (!_showScrollToTop) {
          setState(() {
            _showScrollToTop = true;
          });
        }
      } else {
        if (_showScrollToTop) {
          setState(() {
            _showScrollToTop = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Check login status
  Future<void> _checkLoginStatusAndLoadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if the user is logged in
      _isLoggedIn = await AuthService.isLoggedIn();
      
      if (!_isLoggedIn) {
        // Not logged in - show error
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You need to login first to access messages'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // User is logged in, load users
      await _loadUsers();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await UserService.getAllUsers();
      
      // Generate random last messages and timestamps for demonstration
      for (final user in users) {
        user.lastMessage = _generateRandomLastMessage(user);
        user.lastMessageTime = _generateRandomTime();
      }
      
      // Sort by last message time (most recent first)
      users.sort((a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!));
      
      if (mounted) {
        setState(() {
          _users = users.cast<User>();
          _applySearch();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading messages: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'RETRY',
              onPressed: _loadUsers,
            ),
          ),
        );
      }
    }
  }

  String _generateRandomLastMessage(User user) {
    final messages = [
      'Hey, how are you doing?',
      'Do you want to meet up later?',
      'I sent you the documents you asked for',
      'Have you seen the news today?',
      'Thanks for your help yesterday!',
      'Let me know when you\'re free',
      'What time is the meeting tomorrow?',
      'Did you get my email?',
      '👍',
      '😊',
      'See you soon!',
      'Call me when you can',
    ];
    
    // Use index of user in the list to get consistent results
    final messageIndex = int.parse(user.id.substring(0, 1), radix: 36) % messages.length;
    return messages[messageIndex];
  }

  DateTime _generateRandomTime() {
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch % 13;
    return now.subtract(Duration(hours: random));
  }
  
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = List.from(_users);
    } else {
      _filteredUsers = _users.where((user) {
        final fullName = user.fullName.toLowerCase();
        final email = user.email.toLowerCase();
        final query = _searchQuery.toLowerCase();
        
        return fullName.contains(query) || email.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 18,
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.black, size: 18),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera access requested')),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 18,
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.black, size: 18),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create new message')),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _applySearch();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _applySearch();
                    });
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Chats'),
                  Tab(text: 'Active'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Chats tab
                _filteredUsers.isEmpty
                    ? _buildEmptyState()
                    : _buildChatsList(),
                
                // Active tab
                _buildActiveUsers(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            // Navigate to CallHistoryScreen when Discover is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallHistoryScreen(),
              ),
            );
          } else if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This tab is not implemented in this demo')),
            );
          }
        },
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton(
              mini: true,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No chats matching "$_searchQuery"',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _applySearch();
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Clear Search'),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No chats found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUsers,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildChatsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return _buildChatListTile(user);
      },
    );
  }

  Widget _buildChatListTile(User user) {
    return InkWell(
      onTap: () => _openChatScreen(user),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            // Profile picture with active status indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: user.profilePicture != null
                      ? NetworkImage(user.profilePicture!)
                      : null,
                  child: user.profilePicture == null
                      ? Text(
                          user.fullName.isNotEmpty
                              ? user.fullName.substring(0, 1).toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                // Active status indicator
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _isUserActive(user) ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                // Unread messages indicator
                if (!user.isRead)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: user.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (_isMessageFromMe(user))
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.done_all,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          user.lastMessage ?? '',
                          style: TextStyle(
                            color: user.isRead ? Colors.grey : Colors.black87,
                            fontWeight: user.isRead ? FontWeight.normal : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Timestamp and options
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatLastMessageTime(user.lastMessageTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: user.isRead ? Colors.grey : Colors.blue,
                    fontWeight: user.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  onPressed: () => _showChatOptions(user),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveUsers() {
    // For simplicity, let's show the first 10 users as active
    final activeUsers = _users.take(10).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Active Now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: activeUsers.length,
            itemBuilder: (context, index) {
              final user = activeUsers[index];
              return _buildActiveUserItem(user);
            },
          ),
        ),
        const Divider(),
        Expanded(
          flex: 4,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'See who\'s active at the moment',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'When friends are active, you\'ll see them here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveUserItem(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => _openChatScreen(user),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: user.profilePicture != null
                      ? NetworkImage(user.profilePicture!)
                      : null,
                  child: user.profilePicture == null
                      ? Text(
                          user.fullName.isNotEmpty
                              ? user.fullName.substring(0, 1).toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              user.firstName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openChatScreen(User user) {
    // Mark as read when opening chat
    setState(() {
      user.isRead = true;
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(user: user),
      ),
    );
  }

  void _showChatOptions(User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: user.profilePicture != null
                      ? NetworkImage(user.profilePicture!)
                      : null,
                  child: user.profilePicture == null
                      ? Text(
                          user.fullName.isNotEmpty
                              ? user.fullName.substring(0, 1).toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                title: Text(
                  user.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _isUserActive(user) ? 'Active now' : 'Inactive',
                  style: TextStyle(
                    color: _isUserActive(user) ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.chat_bubble, color: Colors.white),
                ),
                title: const Text('Open chat'),
                onTap: () {
                  Navigator.pop(context);
                  _openChatScreen(user);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.call, color: Colors.white),
                ),
                title: const Text('Voice call'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${user.fullName}...')),
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.videocam, color: Colors.white),
                ),
                title: const Text('Video call'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Video calling ${user.fullName}...')),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(
                    user.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                    color: Colors.black,
                  ),
                ),
                title: Text(user.isRead ? 'Mark as unread' : 'Mark as read'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    user.isRead = !user.isRead;
                  });
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.block, color: Colors.white),
                ),
                title: const Text('Block'),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockUserDialog(user);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Delete chat', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  final shouldDelete = await _showDeleteConfirmation(user);
                  if (shouldDelete == true) {
                    _deleteUser(user);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmation(User user) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text('Delete your conversation with ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBlockUserDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Block ${user.firstName}?'),
        content: Text(
          '${user.firstName} won\'t be able to call you or send you messages. They won\'t be notified that you\'ve blocked them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.fullName} blocked')),
              );
            },
            child: const Text('BLOCK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(User user) async {
    try {
      await UserService.deleteUser(user.id);
      setState(() {
        _users.removeWhere((u) => u.id == user.id);
        _applySearch();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chat with ${user.fullName} deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // In a real app, you'd restore the chat
                // This is just for UI demonstration
                setState(() {
                  _users.add(user);
                  _applySearch();
                });
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting chat: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _isUserActive(User user) {
    // For demo purposes, let's say users with even id are active
    return int.parse(user.id.substring(0, 1), radix: 36) % 2 == 0;
  }

  bool _isMessageFromMe(User user) {
    // For demo purposes, let's say messages with user id divisible by 3 are from me
    return int.parse(user.id.substring(0, 1), radix: 36) % 3 == 0;
  }

  String _formatLastMessageTime(DateTime? time) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 7) {
      return '${time.month}/${time.day}/${time.year.toString().substring(2)}';
    } else if (difference.inDays > 0) {
      // Just show day of week for messages within the last week
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[time.weekday - 1];
    } else {
      // Format time for today's messages
      final hour = time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    }
  }
}