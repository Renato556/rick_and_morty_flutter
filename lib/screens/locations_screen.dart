import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/location.dart';
import '../repositories/api_repository.dart';
import '../widgets/location_card.dart';
import 'location_detail_screen.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Location> _locations = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiRepository = Provider.of<ApiRepository>(context, listen: false);
      final newLocations = await apiRepository.getLocations(page: _page);

      setState(() {
        _locations.addAll(newLocations);
        _isLoading = false;
        _hasMore = newLocations.isNotEmpty;
        _page++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao carregar locais: $e')));
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        _loadLocations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locais')),
      body:
          _locations.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                controller: _scrollController,
                itemCount: _locations.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _locations.length) {
                    final location = _locations[index];
                    return LocationCard(
                      location: location,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LocationDetailScreen(
                                  locationId: location.id,
                                ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
    );
  }
}
