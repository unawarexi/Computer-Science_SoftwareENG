# Communications Module

This module is dedicated to handling all communication-related functionalities in our Flutter-Dart application using ZEGOCLOUD. Below is a description of the files and their purposes within this folder.

## File Descriptions

### 1. `chat_service.dart`
This file contains the implementation of the chat service using ZEGOCLOUD. It handles sending and receiving messages, managing chat rooms, and other chat-related functionalities.

### 2. `video_call_service.dart`
This file is responsible for managing video call functionalities. It includes methods for initiating, joining, and ending video calls using ZEGOCLOUD's API.

### 3. `voice_call_service.dart`
Similar to the video call service, this file manages voice call functionalities. It includes methods for initiating, joining, and ending voice calls using ZEGOCLOUD.

### 4. `notification_service.dart`
This file handles the implementation of notifications for incoming messages and calls. It ensures that users are notified in real-time about any communication events.

### 5. `user_presence_service.dart`
This file manages user presence status, such as online, offline, and do not disturb. It uses ZEGOCLOUD to track and update the presence status of users.

## Getting Started

To get started with the communications module, ensure you have the ZEGOCLOUD SDK integrated into your Flutter project. Follow the steps below:

1. Add the ZEGOCLOUD SDK to your `pubspec.yaml` file.
2. Initialize the ZEGOCLOUD SDK in your main application file.
3. Use the services provided in this module to implement communication features in your app.

## Additional Resources

- [ZEGOCLOUD Documentation](https://docs.zegocloud.com)
- [Flutter Documentation](https://flutter.dev/docs)

For any issues or contributions, please refer to the project's main repository.
