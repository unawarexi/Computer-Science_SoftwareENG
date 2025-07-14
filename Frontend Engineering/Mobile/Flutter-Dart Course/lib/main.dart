import 'package:flutter/material.dart';

import 'package:flutter_dart_course/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables and firebase
    await dotenv.load(fileName: ".env");
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
  

    // Wrap the app with GlobalRefreshWrapper for app-wide pull-to-refresh
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error during app initialization: $e');
  }
}
