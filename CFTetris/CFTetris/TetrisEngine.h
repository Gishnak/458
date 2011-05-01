//
//  TetrisEngine.h
//  R1
//
//  Created by John Bellardo on 3/8/11.
//  Copyright 2011 California State Polytechnic University, San Luis Obispo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NoTetromino 0
#define ITetromino 1
#define JTetromino 2
#define LTetromino 3
#define OTetromino 4
#define STetromino 5
#define TTetromino 6
#define ZTetromino 7

#define TetrisNumCols 10
#define TetrisArrSize(rows) ( (rows) * TetrisNumCols )
#define TetrisArrIdx(row, col) ( (row) * TetrisNumCols + (col) )

@interface TetrisEngine : NSObject {
    @private
	struct TetrisPiece *currPiece;
	int pieceRow, pieceCol, pieceRotation;
	BOOL gameOver;
    NSMutableArray* grid;
}

- (id) init;
- (id) initWithHeight: (int) height;
- (id) initWithState: (NSDictionary *) state;
- (NSDictionary*) currentState;

@property (readonly, nonatomic) BOOL running;
@property (readonly, nonatomic) int height;
@property (readonly, nonatomic) int width;
@property (readonly, nonatomic) int timeStep;
@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) int gridVersion;
@property (retain, readonly, nonatomic) NSTimer* stepTimer;
@property (readwrite, nonatomic) BOOL antiGrav;


- (void) slideLeft;
- (void) slideRight;
- (void) rotateCW;
- (void) rotateCCW;
- (void) pieceDown;
- (void) pieceUp;


- (void) start;
- (void) stop;
- (void) reset;
- (BOOL) running;

- (int) pieceAtRow: (int) row column: (int)col;
- (void) nextPiece;
- (void) commitCurrPiece;
- (BOOL) currPieceWillCollideAtRow: (int) row col: (int) col rotation: (int) rot;
- (BOOL) currPieceOffGrid;



- (void) saveState;
- (void) restoreState;

@end
