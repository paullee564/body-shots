import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weight_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeightProvider()),
      ],
      child: MaterialApp(
          title: 'bodyShots',
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
      )
    );
  }
}
