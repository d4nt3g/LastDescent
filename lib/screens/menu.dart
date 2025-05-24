import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:io';


class HoverButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const HoverButton({
    required this.imagePath,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: Duration(milliseconds: 150),
          scale: _isHovered ? 1.1 : 1.0,
          child: Image.asset(
            widget.imagePath,
            width: 200,
          ),
        ),
      ),
    );
  }
}

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
              Image.asset(
                'assets/images/logo.png',
                width: 450,
              ),
              const SizedBox(height: 30),
              HoverButton(imagePath: 'assets/images/start_button.png',
               onTap: onStart,
              ),
              
              const SizedBox(height: 30),
              HoverButton(imagePath: 'assets/images/exit_button.png',
               onTap: onExit,
              ),
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
            if (Platform.isWindows || Platform.isLinux || Platform.isMacOS){
              exit(0);
            }
            else{
              print('Saída do jogo');
            }
          },
        ),
      ),
    ),
  );
}
