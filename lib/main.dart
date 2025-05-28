import 'package:flutter/material.dart';
import 'package:rick_and_morty/repositories/api_repository.dart';
import 'package:rick_and_morty/repositories/favorites_repository.dart';
import 'package:rick_and_morty/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favoritesRepository = FavoritesRepository();
  await favoritesRepository.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiRepository>(create: (_) => ApiRepository()),
        ChangeNotifierProvider<FavoritesRepository>(
          create: (_) => favoritesRepository,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guia Rick and Morty',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
