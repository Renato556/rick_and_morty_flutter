import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/favorites_repository.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesRepository = Provider.of<FavoritesRepository>(context);
    final favorites = favoritesRepository.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Personagens Favoritos')),
      body:
          favorites.isEmpty
              ? const Center(
                child: Text('Nenhum personagem adicionado aos favoritos.'),
              )
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final character = favorites[index];
                  return CharacterCard(
                    character: character,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CharacterDetailScreen(
                                characterId: character.id,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
