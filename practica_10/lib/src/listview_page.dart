import 'package:flutter/material.dart';

class ListaPage extends StatelessWidget {
  final List<String> _clasesPokemon = [
    'Normal',
    'Fighting',
    'Flying',
    'Poison',
    'Ground',
    'Rock',
    'Bug',
    'Ghost',
    'Steel',
    'Fire',
    'Water',
    'Grass',
    'Electric',
    'Psychic',
    'Ice',
    'Dragon',
    'Dark',
    'Fairy',
    'Unknown',
    'Shadow',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practica 10 - Pokedex'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _clasesPokemon.length,
        itemBuilder: (context, index) {
          final pokemon = _clasesPokemon[index];
          return ListTile(
            leading: Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
            title: Text(pokemon),
            subtitle: const Text('Tipo: Pokemon'),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Has seleccionado a $pokemon'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
