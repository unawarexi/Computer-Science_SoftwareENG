import 'package:flutter/material.dart';
import 'package:flutter_dart_course/apis/api_main_widget.dart';
import 'package:flutter_dart_course/screens/RTC_communications/overview_users.dart';
import 'topics_list.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _getTopicScreen(topics[index]),
                        ),
                      );
                    },
                    child: Text(
                      topics[index],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _getTopicScreen(String topic) {
    switch (topic) {
      case 'Real-Time Communication (RTC)':
        return OverviewUsers();
      case 'API Integration & RESTful Services':
        return ApiMainWidget();
      // Add more cases for other topics...

      default:
        return TopicDetailScreen(topic: topic); // fallback if screen not yet made
    }
  }


// A placeholder screen for Topic details
class TopicDetailScreen extends StatelessWidget {
  final String topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic),
      ),
      body: Center(
        child: Text(
          'Details for $topic',
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
