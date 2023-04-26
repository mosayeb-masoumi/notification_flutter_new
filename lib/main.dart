import 'package:flutter/material.dart';
import 'package:flutter_notifications/home_page.dart';
import 'package:flutter_notifications/notification_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationManager().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

