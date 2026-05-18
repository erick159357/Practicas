import 'package:flutter/material.dart';

class ListaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practica 09 - Pokédex'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Normal'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Fighting'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Flying'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Poison'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Ground'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Rock'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Bug'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Ghost'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Steel'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Fire'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Water'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Grass'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Electric'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Psychic'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Ice'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Dragon'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Dark'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Fairy'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Unknown'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
          
          ListTile(
            contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0.0),
            title: Text('Shadow'),
            leading: CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png'
              ),
            ),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}