import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../models/location.dart';
import '../repositories/api_repository.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class LocationDetailScreen extends StatelessWidget {
  final int locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Local')),
      body: FutureBuilder<Location>(
        future: Provider.of<ApiRepository>(context).getLocation(locationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Local não encontrado'));
          }

          final location = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Tipo', location.type),
                _buildInfoRow('Dimensão', location.dimension),
                const SizedBox(height: 24),
                const Text(
                  'Residentes:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildResidentsList(
                  context,
                  location.residents,
                ),
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

  Widget _buildResidentsList(BuildContext context, List<String> residentUrls) {
    if (residentUrls.isEmpty) {
      return const Text('Nenhum residente encontrado.');
    }

    final residentIds =
        residentUrls.map((url) {
          final parts = url.split('/');
          return int.parse(parts.last);
        }).toList();

    return FutureBuilder<List<Character>>(
      future: _fetchResidents(context, residentIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Erro ao carregar residentes: ${snapshot.error}');
        }

        final residents = snapshot.data ?? [];

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: residents.length,
          itemBuilder: (context, index) {
            final resident = residents[index];
            return CharacterCard(
              character: resident,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CharacterDetailScreen(characterId: resident.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<Character>> _fetchResidents(
    BuildContext context,
    List<int> residentIds,
  ) async {
    final apiRepository = Provider.of<ApiRepository>(context, listen: false);
    final residents = <Character>[];

    for (final id in residentIds) {
      try {
        final character = await apiRepository.getCharacter(id);
        residents.add(character);
      } catch (e) {
        // Ignore errors for individual characters
      }
    }

    return residents;
  }
}
