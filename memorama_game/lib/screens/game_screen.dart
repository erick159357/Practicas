import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:async';
import 'dart:math';
import '../database/database_helper.dart';
import '../models/game_card.dart';
import '../utils/sound_manager.dart';

class GameScreen extends StatefulWidget {
  final int pairs;
  
  const GameScreen({Key? key, required this.pairs}) : super(key: key);
  
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<GameCard> cards = [];
  List<GlobalKey<FlipCardState>> cardKeys = [];
  GameCard? firstCard;
  GameCard? secondCard;
  bool canFlip = true;
  int movements = 0;
  int matchedPairs = 0;
  Timer? _timer;
  int seconds = 0;
  DatabaseHelper dbHelper = DatabaseHelper();
  SoundManager soundManager = SoundManager();
  
  List<String> emojis = [
    '🍎', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🥝',      //los emojis para las cartas
    '🍒', '🍑', '🥥', '🥑', '🌽', '🥕', '🥔', '🍄'
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
  }

  void _initializeGame() {
    cards.clear();
    cardKeys.clear();
    
    List<String> gameEmojis = emojis.take(widget.pairs).toList();
    List<GameCard> gameCards = [];
    
    for (int i = 0; i < widget.pairs; i++) {                      //se crean los pares para cada emoji
      gameCards.add(GameCard(id: i * 2, emoji: gameEmojis[i]));
      gameCards.add(GameCard(id: i * 2 + 1, emoji: gameEmojis[i]));
    }
    
    gameCards.shuffle(Random());                                  //se mezclan las cartas aleatoriamente
    cards = gameCards;
    
    for (int i = 0; i < cards.length; i++) {
      cardKeys.add(GlobalKey<FlipCardState>());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {      //para contar el tiempo de la partida
      setState(() {
        seconds++;
      });
    });
  }

  String _formatTime(int seconds) {             
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _onCardFlip(int index) {   //Logica para el volteo de cartas.
    if (!canFlip || cards[index].isFlipped || cards[index].isMatched) return;  
    //evitar bugs en el juego
    if (firstCard != null && cards[index].id == firstCard!.id) return; //evitar que el usuario eliga la misma carta dos veces
    if (secondCard != null && cards[index].id == secondCard!.id) return; //lo mismo para la segunda carta, si el usuario le vuelve a dar click rapido en ese tiempo de delay
    
    setState(() {
      cards[index].isFlipped = true;
      movements++;
    });
    
    if (firstCard == null) {
      soundManager.playFlip(); // se reproduce el efecto de sonido al voltear la primera carta de un par.
      firstCard = cards[index];
    } else if (secondCard == null) {
      secondCard = cards[index];
      canFlip = false;
      _checkMatch();           //se verifica si coinciden
    }
  }

  void _checkMatch() {          //para verificar coincidencias
    if (firstCard!.emoji == secondCard!.emoji) {
      soundManager.playSuccess();   //si coinciden, se ejecuta un efecto de sonido
      setState(() {
        firstCard!.isMatched = true;
        secondCard!.isMatched = true;
        matchedPairs++;
      });
      
      if (matchedPairs == widget.pairs) {  
        _gameComplete();
      }
      
      _resetSelection();
    } else {
      soundManager.playError(); // Reproducir sonido de error cuando no coinciden
      Timer(Duration(milliseconds: 1000), () {
        cardKeys[cards.indexOf(firstCard!)].currentState?.toggleCard();
        cardKeys[cards.indexOf(secondCard!)].currentState?.toggleCard();
        
        setState(() {
          firstCard!.isFlipped = false;
          secondCard!.isFlipped = false;
        });
        
        _resetSelection();
      });
    }
  }

  void _resetSelection() {  //se podra voltear la carta cuando todavia no se le ha encontrado el par correspondiente.
    firstCard = null;
    secondCard = null;
    canFlip = true;
  }

  void _gameComplete() {    //cuando se completa el juego, detiene el contador del tiempo, se ejecuta un efecto de sonido y se guardan los datos.
    _timer?.cancel();
    soundManager.playWin();
    
    dbHelper.insertRecord({
      'level': widget.pairs,
      'time': seconds,
      'movements': movements,
      'date': DateTime.now().toIso8601String(),
    });
    
    showDialog(              //se muestra el mensaje que le hace saber al usuario que ha completado el juego.
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('¡Felicidades! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Has completado el juego'),
            SizedBox(height: 10),
            Text('Tiempo: ${_formatTime(seconds)}'),
            Text('Movimientos: $movements'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Menú'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: Text('Jugar de Nuevo'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      movements = 0;
      matchedPairs = 0;
      seconds = 0;
      firstCard = null;
      secondCard = null;
      canFlip = true;
    });
    _initializeGame();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = widget.pairs == 8 ? 4 : (widget.pairs == 10 ? 5 : 4);
    
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: AppBar(
        title: Text('Juego de Memoria'),
        backgroundColor: Colors.cyan,
        actions: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(
                _formatTime(seconds),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.cyan,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Aciertos', style: TextStyle(color: Colors.white)),
                    Text('$matchedPairs/${widget.pairs}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text('Movimientos', style: TextStyle(color: Colors.white)),
                    Text('$movements',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return FlipCard(
                    key: cardKeys[index],
                    flipOnTouch: !cards[index].isMatched && canFlip &&
                    (firstCard == null || cards[index].id != firstCard!.id) && //evitar que se vuelva a voltear una carta en caso de darle click dos veces.
                    (secondCard == null || cards[index].id != secondCard!.id), //para la segunda carta
                    onFlip: () => _onCardFlip(index),
                    direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      decoration: BoxDecoration(
                        color: cards[index].isMatched ? Colors.green : Colors.cyan,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 3,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.help_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    back: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: cards[index].isMatched ? Colors.green : Colors.cyan,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cards[index].emoji,
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}