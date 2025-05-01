import 'package:flutter/material.dart';
import 'package:flutter_dart_course/RTC_communications/AgoraRTC/agora_functionality.dart';
import 'package:flutter_dart_course/RTC_communications/AgoraRTC/agora_history_service.dart';
import 'package:intl/intl.dart';


class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> with SingleTickerProviderStateMixin {
  final HistoryService _historyService = HistoryService();
  late TabController _tabController;
  List<CallHistory> _allCalls = [];
  List<CallHistory> _filteredCalls = [];
  bool _isLoading = true;
  CallStatistics? _statistics;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadHistory();
  }
  
  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    
    _allCalls = await _historyService.getCallHistory();
    _applyFilters();
    _statistics = await _historyService.getCallStatistics();
    
    setState(() {
      _isLoading = false;
    });
  }
  
  void _applyFilters() {
    if (_searchQuery.isNotEmpty) {
      _filteredCalls = _allCalls.where((call) =>
        call.remoteUserId.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    } else {
      switch (_tabController.index) {
        case 0: // All calls
          _filteredCalls = _allCalls;
          break;
        case 1: // Missed calls
          _filteredCalls = _allCalls.where((call) => call.status == CallStatus.missed).toList();
          break;
        case 2: // Outgoing calls
          _filteredCalls = _allCalls.where((call) => call.isOutgoing).toList();
          break;
        case 3: // Incoming calls
          _filteredCalls = _allCalls.where((call) => !call.isOutgoing && call.status != CallStatus.missed).toList();
          break;
      }
    }
    
    // Sort by date (newest first)
    _filteredCalls.sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showClearHistoryDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) {
            setState(() {
              _applyFilters();
            });
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Missed'),
            Tab(text: 'Outgoing'),
            Tab(text: 'Incoming'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search call history',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                if (_statistics != null) _buildStatisticsCard(),
                Expanded(
                  child: _filteredCalls.isEmpty
                      ? const Center(child: Text('No calls found'))
                      : ListView.builder(
                          itemCount: _filteredCalls.length,
                          itemBuilder: (context, index) {
                            return _buildCallHistoryItem(_filteredCalls[index]);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Calls: ${_statistics!.totalCalls}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Total Duration: ${_statistics!.formattedTotalDuration}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Video', _statistics!.videoCalls),
                _buildStatColumn('Audio', _statistics!.audioCalls),
                _buildStatColumn('Outgoing', _statistics!.outgoingCalls),
                _buildStatColumn('Incoming', _statistics!.incomingCalls),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCallHistoryItem(CallHistory call) {
    final callIcon = call.type == CallType.video 
        ? Icons.videocam 
        : Icons.phone;
    
    final callTypeIcon = call.isOutgoing
        ? Icons.call_made
        : (call.status == CallStatus.missed ? Icons.call_missed : Icons.call_received);
    
    final callTypeColor = call.status == CallStatus.missed
        ? Colors.red
        : (call.isOutgoing ? Colors.green : Colors.blue);
    
    final timeString = DateFormat('MMM d, yyyy • h:mm a').format(call.startTime);
    final durationString = _formatDuration(call.duration);
    
    return Dismissible(
      key: Key(call.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) async {
        await _historyService.deleteCallHistory(call.id);
        setState(() {
          _allCalls.removeWhere((c) => c.id == call.id);
          _applyFilters();
        });
       if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Call removed from history')),
        );
       }
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(callIcon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(call.remoteUserId),
        subtitle: Text('$timeString • $durationString'),
        trailing: Icon(callTypeIcon, color: callTypeColor),
        onTap: () => _showCallDetails(context, call),
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} minutes';
    } else {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return '$hours:${minutes.toString().padLeft(2, '0')} hours';
    }
  }

  void _showCallDetails(BuildContext context, CallHistory call) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              call.remoteUserId,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Type: ${call.type == CallType.video ? 'Video Call' : 'Audio Call'}'),
            Text('Direction: ${call.isOutgoing ? 'Outgoing' : 'Incoming'}'),
            Text('Status: ${call.status.toString().split('.').last}'),
            Text('Start Time: ${DateFormat('MMM d, yyyy • h:mm:ss a').format(call.startTime)}'),
            Text('End Time: ${DateFormat('MMM d, yyyy • h:mm:ss a').format(call.endTime)}'),
            Text('Duration: ${_formatDuration(call.duration)}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(call.type == CallType.video ? Icons.videocam : Icons.phone),
                  label: const Text('Call Again'),
                  onPressed: () {
                    Navigator.pop(context);
                    // Call the user again (implement this based on your app logic)
                    _makeCall(call.remoteUserId, call.type);
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  onPressed: () async {
                    await _historyService.deleteCallHistory(call.id);
                    setState(() {
                      _allCalls.removeWhere((c) => c.id == call.id);
                      _applyFilters();
                    });
                   if(mounted) {
                     Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Call removed from history')),
                    );
                   }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Call History'),
        content: const Text('Are you sure you want to clear all call history? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Clear'),
            onPressed: () async {
              await _historyService.clearCallHistory();
              setState(() {
                _allCalls.clear();
                _filteredCalls.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Call history cleared')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  void _makeCall(String userId, CallType callType) {
    // Implement this method based on how you handle calls in your app
    final AgoraManager agoraManager = AgoraManager();
    agoraManager.startCall(
      remoteUserId: userId,
      callType: callType,
    );
    // Navigate to call screen or handle within your app flow
  }
}