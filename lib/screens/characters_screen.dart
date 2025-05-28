import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/character.dart';
import '../repositories/api_repository.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Character> _characters = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCharacters() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiRepository = Provider.of<ApiRepository>(context, listen: false);
      final newCharacters = await apiRepository.getCharacters(page: _page);

      setState(() {
        _characters.addAll(newCharacters);
        _isLoading = false;
        _hasMore = newCharacters.isNotEmpty;
        _page++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar personagens: $e')),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        _loadCharacters();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personagens')),
      body:
          _characters.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                controller: _scrollController,
                itemCount: _characters.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _characters.length) {
                    final character = _characters[index];
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
