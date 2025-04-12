import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onExit;

  const MainMenu({required this.onStart, required this.onExit, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/menu_background.png',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last Descent',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(width: 150,
                      child: FilledButton(
                        onPressed: onStart, child: Text('Start Game')),),
              
              const SizedBox(height: 10),
              SizedBox(width: 150,
                      child: FilledButton(
                        onPressed: onExit, child: Text('Exit')),),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: MainMenu(
          onStart: () {
            print('Game Started!'); // Substituir pela lógica de iniciar o jogo
          },
          onExit: () {
            print('Game Exited!'); // Implementar saída do jogo
          },
        ),
      ),
    ),
  );
}
