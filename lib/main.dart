
import 'package:flutter/material.dart';
import 'bantwara_screen.dart';

void main() {
  runApp(const DraftSevaApp());
}

class DraftSevaApp extends StatelessWidget {
  const DraftSevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draft Seva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const BantwaraScreen(),
    );
  }
