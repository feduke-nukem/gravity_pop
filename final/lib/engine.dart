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

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'data/game.dart';
import 'data/input.dart';
import 'data/tetrinimo.dart';
import 'data/utils.dart';

class Engine {
  static const int COL_COUNT = 20;
  final double boardWidth, boardHeight;
  int extent = 0, effectiveWidth = 0, effectiveHeight = 0;
  final List<Color> _setPieces = [];

  int _itemCount = 0;
  int getGridItemCount() => _itemCount;

  final StreamController<Tetrimino> _playerController = StreamController();
  final StreamController<UserInput> _inputController =
      StreamController.broadcast();
  final StreamController<GameData> _gameController =
      BehaviorSubject.seeded(GameData(state: GameState.Start, pieces: []));

  Engine({required this.boardWidth, required this.boardHeight}) {
    effectiveWidth = (boardWidth / COL_COUNT).floor() * COL_COUNT;
    extent = effectiveWidth ~/ COL_COUNT;
    effectiveHeight = (boardHeight / extent).floor() * extent;
    _itemCount = COL_COUNT * (effectiveHeight ~/ extent);
    _setPieces.addAll(List.filled(_itemCount, Colors.white));
  }

  Stream<Tetrimino> get blankPlayerStream {
    return Stream.value(Tetrimino(current: Piece.I, origin: const Point(0, 0)));
  }

  Stream<Tetrimino> staticPlayerStream() {
    return RangeStream(0, effectiveHeight ~/ extent - 1).map((value) =>
        Tetrimino(
            current: Piece.I, origin: Point(0, value * extent.toDouble())));
  }

  Stream<Tetrimino> animatingPlayerStream() {
    return RangeStream(0, effectiveHeight ~/ extent - 1)
        .interval(const Duration(milliseconds: 500))
        .map((value) => Tetrimino(
            current: Piece.I, origin: Point(0, value * extent.toDouble())));
  }

  Stream<Tetrimino> animatingPlayerWithCompletionStream() {
    return animatingPlayerStream()
        .takeWhile((_transformedPiece) => _canTetriminoMove(_transformedPiece))
        .doOnDone(() {
      _onTetriminoSet(Tetrimino(
          current: Piece.I,
          yOffset: (effectiveHeight ~/ extent - 1).toDouble(),
          origin: const Point(0, 0)));
    });
  }

  Stream<Tetrimino> infiniteAnimatingPlayerWithCompletionStream() {
    return _playerController.stream.switchMap((value) {
      var _current = value;
      return RangeStream(0, effectiveHeight ~/ extent - 1)
          .interval(const Duration(milliseconds: 500))
          .map(
            (value) => Tetrimino(
              angle: 0.0,
              current: _current.current,
              origin: const Point(0, 0),
              yOffset: value.toDouble(),
              xOffset: 0,
            ),
          )
          .takeWhile(
            (_transformedPiece) => _canTetriminoMove(_transformedPiece),
          )
          .doOnData((_validTransformedPiece) {
        _current = _validTransformedPiece;
      }).doOnDone(() {
        _onTetriminoSet(_current);
      });
    });
  }

  Stream<Tetrimino> infiniteAnimatingPlayerWithCompletionStreamWithInput() {
    return _playerController.stream.switchMap((value) {
      var _current = value;
      return CombineLatestStream.combine2<UserInput, int, Tetrimino>(
        _inputController.stream
            .debounceTime(const Duration(seconds: 1))
            .startWith(UserInput(angle: 0, xOffset: 0, yOffset: 0))
            .map((input) => _offsetUserInput(input, _current)),
        RangeStream(0, effectiveHeight ~/ extent - 1)
            .interval(const Duration(milliseconds: 500)),
        (userInput, yOffset) =>
            _transformedTetrimino(_current, userInput, yOffset),
      )
          .takeWhile(
              (_transformedPiece) => _canTetriminoMove(_transformedPiece))
          .doOnData((_validTransformedPiece) {
        _current = _validTransformedPiece;
      }).doOnDone(() {
        _onTetriminoSet(_current);
      });
    });
  }

  Stream<GameData> get gridStateStream {
    return _gameController.stream.flatMap((data) {
      if (data.state == GameState.End)
        return TimerStream(data, const Duration(seconds: 2));

      final _filledGridPieces = getFilledRowIndexes(_setPieces, COL_COUNT);
      if (_filledGridPieces.isEmpty) return _gameController.stream;
      return Stream.fromIterable(_filledGridPieces).map((index) {
        _setPieces.removeRange(index, index + COL_COUNT);
        _setPieces.insertAll(
            0, List.generate(COL_COUNT, (index) => Colors.white));
        return GameData(state: data.state, pieces: _setPieces);
      });
    });
  }

  void _spawn() {
    final _availablePieces = [
      Piece.I,
      Piece.J,
      Piece.T,
      Piece.S,
      Piece.Z,
      Piece.O,
      Piece.L,
    ];

    _playerController.add(
      Tetrimino(
        current: _availablePieces[Random().nextInt(7)],
        angle: 0,
        origin: Point<double>(
            Random().nextInt(COL_COUNT - 4).toDouble() * extent, 0),
      ),
    );
  }

  void spawn() {
    _gameController.add(GameData(state: GameState.Play, pieces: []));
    _spawn();
  }

  void moveLeft() {
    _inputController.add(UserInput(angle: 0, xOffset: -1, yOffset: 0));
  }

  void moveRight() {
    _inputController.add(UserInput(angle: 0, xOffset: 1, yOffset: 0));
  }

  void rotatePiece() {
    _inputController.add(UserInput(angle: 90, xOffset: 0, yOffset: 0));
  }

  bool _canTetriminoMove(Tetrimino piece) {
    final _nextIndexes = mapToGridIndex(piece, extent, COL_COUNT);
    final _isPieceInsideTheBoard =
        !_nextIndexes.any((index) => index > _itemCount);
    final _isNextPositionCollisionFree =
        !_nextIndexes.any((item) => _setPieces[item] != Colors.white);
    return _isPieceInsideTheBoard && _isNextPositionCollisionFree;
  }

  void _onTetriminoSet(Tetrimino piece) {
    final _indexes = mapToGridIndex(piece, extent, COL_COUNT);
    _setPieces[_indexes[0]] = piece.color!;
    _setPieces[_indexes[1]] = piece.color!;
    _setPieces[_indexes[2]] = piece.color!;
    _setPieces[_indexes[3]] = piece.color!;
    if (isSetPieceAtTheTop(_setPieces, COL_COUNT)) {
      _gameController.add(GameData(state: GameState.End, pieces: []));
    } else {
      _gameController.add(GameData(state: GameState.Play, pieces: _setPieces));
      _spawn();
    }
  }

  UserInput _offsetUserInput(UserInput input, Tetrimino piece) {
    final _isPieceOutsideBoundary =
        isPieceHorizontallyInside(piece, input.xOffset, extent, COL_COUNT);
    return UserInput(
        angle: piece.angle.toInt() + input.angle,
        xOffset: piece.xOffset.toInt() +
            (_isPieceOutsideBoundary ? 0 : input.xOffset),
        yOffset: piece.yOffset.toInt() + input.yOffset);
  }

  Tetrimino _transformedTetrimino(
          Tetrimino piece, UserInput userInput, int yOffset) =>
      Tetrimino(
        angle: (userInput.angle).toDouble(),
        current: piece.current,
        origin: Point(piece.origin.x, piece.origin.y),
        yOffset: yOffset.toDouble(),
        xOffset: (userInput.xOffset).toDouble(),
      );

  void resetGame() {
    _setPieces.clear();
    _setPieces.addAll(List.filled(_itemCount, Colors.white));
    spawn();
  }
}
