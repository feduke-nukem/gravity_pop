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
import 'package:flutter/widgets.dart';

import 'data/tetrinimo.dart';
import 'tetris.dart';
import 'tetromino/i_block.dart';
import 'tetromino/j_block.dart';
import 'tetromino/l_block.dart';
import 'tetromino/o_block.dart';
import 'tetromino/s_block.dart';
import 'tetromino/t_block.dart';
import 'tetromino/z_block.dart';

class Player extends StatelessWidget {
  const Player({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _engine = TetrisController.of(context);
    return Center(
      //1
      child: StreamBuilder<Tetrimino>(
        //2
        stream: _engine.infiniteAnimatingPlayerWithCompletionStreamWithInput(),
        //3
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.current == Piece.Empty)
              return const SizedBox.shrink();

            return ClipRect(
              child: CustomPaint(
                painter:
                    _getNextPiece(snapshot.data!, _engine.extent.toDouble()),
                child: SizedBox(
                  width: _engine.effectiveWidth.toDouble(),
                  height: _engine.effectiveHeight.toDouble(),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  CustomPainter? _getNextPiece(Tetrimino nextPiece, double extent) {
    if (nextPiece.current == Piece.I)
      return IBlock(
        width: extent,
        angle: nextPiece.angle,
        yOffset: nextPiece.yOffset,
        xOffset: nextPiece.xOffset,
        origin: nextPiece.origin,
      );
    if (nextPiece.current == Piece.J)
      return JBlock(
        width: extent,
        angle: nextPiece.angle,
        yOffset: nextPiece.yOffset,
        xOffset: nextPiece.xOffset,
        origin: nextPiece.origin,
      );
    if (nextPiece.current == Piece.T)
      return TBlock(
        width: extent,
        angle: nextPiece.angle,
        yOffset: nextPiece.yOffset,
        xOffset: nextPiece.xOffset,
        origin: nextPiece.origin,
      );
    if (nextPiece.current == Piece.S)
      return SBlock(
        width: extent,
        angle: nextPiece.angle,
        yOffset: nextPiece.yOffset,
        xOffset: nextPiece.xOffset,
        origin: nextPiece.origin,
      );
    if (nextPiece.current == Piece.Z)
      return ZBlock(
        width: extent,
        angle: nextPiece.angle,
        yOffset: nextPiece.yOffset,
        xOffset: nextPiece.xOffset,
        origin: nextPiece.origin,
      );
    if (nextPiece.current == Piece.O)
      return OBlock(
        width: extent,
        yOffset: nextPiece.yOffset,
        xOffset: nextPiece.xOffset,
        origin: nextPiece.origin,
      );
    if (nextPiece.current == Piece.L)
      return LBlock(
        width: extent,
        angle: nextPiece.angle,
        yOffset: nextPiece.yOffset,
        xOffset: nextPiece.xOffset,
        origin: nextPiece.origin,
      );
    return null;
  }
}
