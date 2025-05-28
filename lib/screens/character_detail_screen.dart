import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../repositories/api_repository.dart';
import '../repositories/favorites_repository.dart';

class CharacterDetailScreen extends StatelessWidget {
  final int characterId;

  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Personagem'),
        actions: [
          Consumer<FavoritesRepository>(
            builder: (context, repo, child) {
              final isFavorite = repo.isFavorite(characterId);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () async {
                  final apiRepository = Provider.of<ApiRepository>(
                    context,
                    listen: false,
                  );
                  final character = await apiRepository.getCharacter(
                    characterId,
                  );

                  if (isFavorite) {
                    await repo.removeFavorite(characterId);
                  } else {
                    await repo.addFavorite(character);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Character>(
        future: Provider.of<ApiRepository>(context).getCharacter(characterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Personagem não encontrado'));
          }

          final character = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    character.image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  character.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Status', character.status),
                _buildInfoRow('Espécie', character.species),
                if (character.type.isNotEmpty)
                  _buildInfoRow('Tipo', character.type),
                _buildInfoRow('Gênero', character.gender),
                _buildInfoRow('Origem', character.origin),
                _buildInfoRow('Localização', character.location),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value.isEmpty ? 'Desconhecido' : value)),
        ],
      ),
    );
  }
}
