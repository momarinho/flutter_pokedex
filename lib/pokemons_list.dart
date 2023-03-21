import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/utils/capitalize.dart';
import 'package:http/http.dart' as http;

import 'pokemon_color.dart';
import 'pokemon_details.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({Key? key}) : super(key: key);

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late List<dynamic> _pokemonList;
  late List<dynamic> _filteredPokemonList;
  late bool _isLoading;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadPokemonList();
    _searchController = TextEditingController();
  }

  Future<void> _loadPokemonList() async {
    try {
      const limit = 900;
      final response = await http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _pokemonList = data['results'];
          _filteredPokemonList = _pokemonList;
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPokemonList(String query) {
    List<dynamic> filteredList = _pokemonList.where((pokemon) {
      return pokemon['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredPokemonList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: PokemonSearchDelegate(
                    _filteredPokemonList, _filterPokemonList),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Pokemon',
                    ),
                    onChanged: (query) {
                      _filterPokemonList(query);
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _filteredPokemonList.length,
                    itemBuilder: (context, index) {
                      final pokemon = _filteredPokemonList[index];
                      final name = (pokemon['name']).toString().capitalize();
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PokemonDetailScreen(
                                pokemonUrl: pokemon['url'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: getRandomPokemonBackgroundColor(),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Center(
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class PokemonSearchDelegate extends SearchDelegate<dynamic> {
  final List<dynamic> pokemonList;
  final Function(String) onFilter;

  PokemonSearchDelegate(this.pokemonList, this.onFilter);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          onFilter('');
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, []);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onFilter(query);
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = pokemonList[index];
        final name = (pokemon['name']).toString().capitalize();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetailScreen(
                  pokemonUrl: pokemon['url'],
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: getRandomPokemonBackgroundColor(),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}
