import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  character.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Status: ${character.status}'),
                    Text('Espécie: ${character.species}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
