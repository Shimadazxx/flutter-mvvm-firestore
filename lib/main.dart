import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // File hasil generate FlutterFire
import 'viewmodels/task_viewmodels.dart'; // Import viewmodel
import 'views/task_screen.dart'; // Import view (UI)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pastikan Anda memanggil DefaultFirebaseOptions.currentPlatform
  // yang berasal dari file firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter MVVM Provider Firestore',
        theme: ThemeData(primarySwatch: Colors.teal),
        home: const TaskScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}