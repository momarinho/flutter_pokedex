import 'package:flutter/material.dart';
import 'package:flutter_pokedex/utils/capitalize.dart';

import 'pokemon_color.dart';
import 'pokemon_details.dart';

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
