import 'package:flutter/material.dart';
import '../models/location.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onTap;

  const LocationCard({super.key, required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Tipo: ${location.type}'),
              Text('Dimensão: ${location.dimension}'),
              const SizedBox(height: 8),
              Text(
                'Residentes: ${location.residents.length}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
