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

import 'tetrinimo.dart';

int getMaxExtentByPiece(Tetrimino tetrimino) {
  switch (tetrimino.current) {
    case Piece.I:
    case Piece.J:
    case Piece.L:
    case Piece.S:
    case Piece.T:
    case Piece.Z:
      return _getBlockExtent(tetrimino.angle) - 1;
    case Piece.O:
      return 1;
    default:
      return 0;
  }
}

int _getBlockExtent(double angle) {
  if (angle == 90 || angle == 270) return 4;
  return 2;
}

bool isSetPieceAtTheTop(List<Color> setPieces, int colCount) {
  for (var i = 0; i < colCount; i++) {
    if (setPieces[i] != Colors.white) return true;
  }
  return false;
}

int _getBlockWidthByAngle(Tetrimino piece) {
  switch (piece.current) {
    case Piece.I:
      return piece.angle == 90 || piece.angle == 270 ? 1 : 4;
    case Piece.J:
    case Piece.L:
    case Piece.S:
    case Piece.T:
    case Piece.Z:
      return piece.angle == 90 || piece.angle == 270 ? 2 : 3;
    case Piece.O:
      return 2;
    default:
      return 0;
  }
}

bool isPieceHorizontallyInside(
    Tetrimino piece, int xOffset, int extent, int colCount) {
  final _leftLimit =
      ((piece.xOffset + xOffset) * extent + piece.origin.x) ~/ extent;
  final _rightLimit = _leftLimit + _getBlockWidthByAngle(piece);
  return _leftLimit < 0 || _rightLimit > colCount;
}

List<int> mapToGridIndex(Tetrimino piece, int extent, int colCount) {
  final _horizontalNormal = (piece.xOffset * extent + piece.origin.x) ~/ extent;
  final _startIndex = colCount * piece.yOffset.toInt() + _horizontalNormal;
  switch (piece.current) {
    case Piece.I:
      return _mapIBlock(_startIndex, colCount, piece.angle);
    case Piece.J:
      return _mapJBlock(_startIndex, colCount, piece.angle);
    case Piece.L:
      return _mapLBlock(_startIndex, colCount, piece.angle);
    case Piece.O:
      return _mapOBlock(_startIndex, colCount, piece.angle);
    case Piece.S:
      return _mapSBlock(_startIndex, colCount, piece.angle);
    case Piece.T:
      return _mapTBlock(_startIndex, colCount, piece.angle);
    case Piece.Z:
      return _mapZBlock(_startIndex, colCount, piece.angle);
    default:
      return [];
  }
}

List<int> getFilledRowIndexes(List<Color> setPieces, int colCount) {
  final _rowIndexes = <int>[];
  for (var i = 0; i < setPieces.length; i++) {
    if (setPieces[i] != Colors.white && i % colCount == 0) {
      var _rowSet = true;
      for (var incr = 1; incr < colCount; incr++) {
        if (setPieces[i + incr] == Colors.white) _rowSet = false;
      }
      if (_rowSet) _rowIndexes.add(i);
    }
  }
  return _rowIndexes;
}

List<int> _mapIBlock(int startIndex, int colCount, double angle) {
  if (angle == 90 || angle == 270) {
    return [
      startIndex,
      startIndex + colCount,
      startIndex + 2 * colCount,
      startIndex + 3 * colCount
    ];
  } else {
    return [startIndex, startIndex + 1, startIndex + 2, startIndex + 3];
  }
}

List<int> _mapJBlock(int startIndex, int colCount, double angle) {
  if (angle == 90)
    return [
      startIndex,
      startIndex + 1,
      startIndex + colCount,
      startIndex + 2 * colCount
    ];
  if (angle == 180)
    return [
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + colCount + 2,
      startIndex + 2 * colCount + 2
    ];
  if (angle == 270)
    return [
      startIndex + 1,
      startIndex + colCount + 1,
      startIndex + 2 * colCount + 1,
      startIndex + 2 * colCount,
    ];
  return [
    startIndex,
    startIndex + colCount,
    startIndex + colCount + 1,
    startIndex + colCount + 2,
  ];
}

List<int> _mapLBlock(int startIndex, int colCount, double angle) {
  if (angle == 90)
    return [
      startIndex,
      startIndex + 1,
      startIndex + colCount,
      startIndex + 2 * colCount
    ];
  if (angle == 180)
    return [
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + colCount + 2,
      startIndex + 2 * colCount + 2
    ];
  if (angle == 270)
    return [
      startIndex + 1,
      startIndex + colCount + 1,
      startIndex + 2 * colCount + 1,
      startIndex + 2 * colCount,
    ];
  return [
    startIndex,
    startIndex + colCount,
    startIndex + colCount + 1,
    startIndex + colCount + 2,
  ];
}

List<int> _mapOBlock(int startIndex, int colCount, double angle) {
  return [
    startIndex,
    startIndex + 1,
    startIndex + colCount + 1,
    startIndex + colCount
  ];
}

List<int> _mapSBlock(int startIndex, int colCount, double angle) {
  if (angle == 90)
    return [
      startIndex,
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + 2 * colCount + 1
    ];
  if (angle == 180)
    return [
      startIndex + colCount + 1,
      startIndex + colCount + 2,
      startIndex + 2 * colCount + 1,
      startIndex + 2 * colCount
    ];
  if (angle == 270)
    return [
      startIndex,
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + 2 * colCount + 2,
    ];
  return [
    startIndex + 1,
    startIndex + 2,
    startIndex + colCount,
    startIndex + colCount + 1,
  ];
}

List<int> _mapTBlock(int startIndex, int colCount, double angle) {
  if (angle == 90)
    return [
      startIndex,
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + 2 * colCount
    ];
  if (angle == 180)
    return [
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + colCount + 2,
      startIndex + 2 * colCount + 1
    ];
  if (angle == 270)
    return [
      startIndex + 1,
      startIndex + colCount + 1,
      startIndex + colCount,
      startIndex + 2 * colCount + 1,
    ];
  return [
    startIndex + 1,
    startIndex + colCount,
    startIndex + colCount + 1,
    startIndex + colCount + 2,
  ];
}

List<int> _mapZBlock(int startIndex, int colCount, double angle) {
  if (angle == 90)
    return [
      startIndex + 1,
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + 2 * colCount
    ];
  if (angle == 180)
    return [
      startIndex + colCount,
      startIndex + colCount + 1,
      startIndex + 2 * colCount + 1,
      startIndex + 2 * colCount + 2
    ];
  if (angle == 270)
    return [
      startIndex + 1,
      startIndex + colCount + 1,
      startIndex + 2 * colCount + 1,
      startIndex + 2 * colCount,
    ];
  return [
    startIndex,
    startIndex + 1,
    startIndex + colCount + 1,
    startIndex + colCount + 2,
  ];
}
