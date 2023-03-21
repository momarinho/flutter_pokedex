import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({Key? key, required this.pokemonUrl})
      : super(key: key);

  final String pokemonUrl;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Map<String, dynamic> _pokemonData;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadPokemonData();
  }

  Future<void> _loadPokemonData() async {
    try {
      final response = await http.get(Uri.parse(widget.pokemonUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _pokemonData = data;
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
        title: Text(_isLoading ? 'Loading...' : _pokemonData['name']),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildPokemonDetails(),
      ),
    );
  }

  Widget _buildPokemonDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_pokemonData['sprites']['front_default']),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name: ${_pokemonData['name']}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Height: ${_pokemonData['height']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Weight: ${_pokemonData['weight']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Abilities:',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _pokemonData['abilities'].length,
            itemBuilder: (BuildContext context, int index) {
              final ability = _pokemonData['abilities'][index]['ability'];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 4.0,
                child: Center(
                  child: Text(
                    ability['name'],
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
