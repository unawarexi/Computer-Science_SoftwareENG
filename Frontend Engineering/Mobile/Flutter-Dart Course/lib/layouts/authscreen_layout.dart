import 'package:flutter/material.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              TabBar(
                indicatorColor: Colors.green, // Green underline indicator
                indicatorWeight: 3.0, // Thickness of the underline
                labelColor: Colors.black, // Tab label color
                unselectedLabelColor: Colors.grey, // Color of unselected tabs
                tabs: [
                  Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: Text("Left Tab"),
                  ),
                  Align(
                    alignment: Alignment.centerRight, // Align text to the right
                    child: Text("Right Tab"),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text("Content for Left Tab")),
                    Center(child: Text("Content for Right Tab")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
