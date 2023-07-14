// Copyright (c) 2022 Razeware LLC
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the 'Software'), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical
// or instructional purposes related to programming, coding, application
// development, or information technology.  Permission for such use, copying,
// modification, merger, publication, distribution, sublicensing, creation
// of derivative works, or sale is expressly withheld.
// THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import 'package:flutter/material.dart';

import 'data/game.dart';
import 'tetris.dart';

class GameLayer extends StatelessWidget {
  const GameLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _engine = TetrisController.of(context);
    return StreamBuilder<GameData>(
      stream: _engine.gridStateStream,
      builder: (_, data) {
        if (data.data == null || data.data!.state == GameState.Start) {
          return const _TitleScreen();
        } else if (data.data!.state == GameState.Play) {
          return const _GamePlayScreen();
        } else {
          return const _TitleScreen();
        }
      },
    );
  }
}

class _TitleScreen extends StatelessWidget {
  const _TitleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _engine = TetrisController.of(context);
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Image(
              width: 400,
              image: AssetImage(
                'images/tetristitle.png',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
                child: const Icon(Icons.play_arrow),
                onPressed: () {
                  _engine.spawn();
                }),
            alignment: Alignment.bottomRight,
          )
        ],
      ),
    );
  }
}

class _GamePlayScreen extends StatelessWidget {
  const _GamePlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _engine = TetrisController.of(context);
    return SizedBox(
      height: _engine.effectiveHeight.toDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton.small(
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                _engine.moveLeft();
              }),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.small(
                  child: const Icon(Icons.change_circle),
                  onPressed: () {
                    _engine.rotatePiece();
                  }),
              FloatingActionButton.small(
                  child: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    _engine.moveRight();
                  }),
            ],
          )
        ],
      ),
    );
  }
}
