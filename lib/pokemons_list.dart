import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'pokemon_details.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({Key? key}) : super(key: key);

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late List<dynamic> _pokemonList;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadPokemonList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildPokemonList(),
    );
  }

  Widget _buildPokemonList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _pokemonList.length,
        itemBuilder: (BuildContext context, int index) {
          final pokemon = _pokemonList[index];
          return Card(
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PokemonDetailScreen(
                //       pokemonUrl: pokemon['url'],
                //     ),
                //   ),
                // );
              },
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      pokemon['name'],
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
