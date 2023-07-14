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

import 'dart:math';

import 'package:flutter/material.dart';

enum Piece { I, L, J, S, T, Z, O, Empty }

class Tetrimino {
  final Piece current;
  final Point<double> origin;
  final double angle, xOffset, yOffset;
  Color? color;

  Tetrimino(
      {required this.current,
      required this.origin,
      this.angle = 0,
      this.xOffset = 0,
      this.yOffset = 0}) {
    if (current == Piece.I) color = Colors.teal;
    if (current == Piece.J) color = Colors.green;
    if (current == Piece.L) color = Colors.blue;
    if (current == Piece.S) color = Colors.pinkAccent;
    if (current == Piece.T) color = Colors.red;
    if (current == Piece.Z) color = Colors.blue;
    if (current == Piece.O) color = Colors.yellow;
  }
}

class TetrisUnit {
  final int index;
  final Color color;

  TetrisUnit({required this.index, required this.color});
}
