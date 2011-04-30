//
//  TetrisEngine.m
//  R1
//
//  Created by John Bellardo on 3/8/11.
//  Copyright 2011 California State Polytechnic University, San Luis Obispo. All rights reserved.
//

#import "TetrisEngine.h"

#define TetrisPieceBlocks 4
#define TetrisPieceRotations 4
struct TetrisPiece {
	int name;
	struct {
		int colOff, rowOff;
	} offsets[TetrisPieceRotations][TetrisPieceBlocks];
};

// Static array that defines all rotations for every piece.
// Each <x,y> point is an offset from the center of the piece.
#define TetrisNumPieces 7
static struct TetrisPiece pieces[TetrisNumPieces] = {
	{ ITetromino,	{
						{ {-2, 0}, { -1, 0}, { 0, 0 }, {1, 0} },  // 0 deg.
						{ {0, 0}, { 0, 1}, { 0, 2 }, {0, 3} },  // 90 deg.
						{ {-2, 0}, { -1, 0}, { 0, 0 }, {1, 0} },  // 180 deg.
						{ {0, 0}, { 0, 1}, { 0, 2 }, {0, 3} },  // 270 deg.
					} },
	{ JTetromino,	{
						{ {-1, 0}, { 0, 0}, { 1, 0 }, {-1, 1} }, // 0 deg.
						{ {0, 0}, { 0, 1}, { 0, 2 }, {1, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 1}, { 1, 1 }, {1, 0} }, // 180 deg.
						{ {-1, 0}, { 0, 0}, { 0, 1 }, {0, 2} }, // 270 deg.
					} },
	{ LTetromino,	{
						{ {-1, 0}, { 0, 0}, { 1, 0 }, {1, 1} }, // 0 deg.
						{ {0, 0}, { 1, 0}, { 0, 1 }, {0, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 1}, { 1, 1 }, {-1, 0} }, // 180 deg.
						{ {-1, 2}, { 0, 2}, { 0, 1 }, {0, 0} }, // 270 deg.
					} },
	{ OTetromino,	{
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 0 deg.
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 90 deg.
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 180 deg.
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 270 deg.
					} },
	{ STetromino,	{
						{ {-1, 0}, { 0, 0}, { 0, 1 }, {1, 1} }, // 0 deg.
						{ {1, 0}, { 0, 1}, { 1, 1 }, {0, 2} }, // 90 deg.
						{ {-1, 0}, { 0, 0}, { 0, 1 }, {1, 1} }, // 180 deg.
						{ {1, 0}, { 0, 1}, { 1, 1 }, {0, 2} }, // 270 deg.
					} },
	{ TTetromino,	{
						{ {-1, 0}, { 0, 0}, { 1, 0 }, {0, 1} }, // 0 deg.
						{ {0, 0}, { 0, 1}, { 1, 1 }, {0, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 1}, { 1, 1 }, {0, 0} }, // 180 deg.
						{ {0, 1}, { 1, 0}, { 1, 1 }, {1, 2} }, // 270 deg.
					} },
	{ ZTetromino,	{
						{ {-1, 1}, { 0, 0}, { 1, 0 }, {0, 1} }, // 0 deg.
						{ {0, 0}, { 0, 1}, { 1, 1 }, {1, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 0}, { 1, 0 }, {0, 1} }, // 180 deg.
						{ {0, 0}, { 0, 1}, { 1, 1 }, {1, 2} }, // 270 deg.
					} }
};

@implementation TetrisEngine

- (id) init
{
	return [self initWithHeight: 20];
}

- (id) initWithHeight: (int) h
{
	self = [super init];
	if (self) {
		srandom(time(0));
		self->height = h;
		self->grid = malloc(sizeof(int) * TetrisArrSize(self->height));
	}
    [self reset];
	return self;
}

// Add the next floating piece to the game board
- (void) nextPiece
{
	currPiece = &pieces[ ((random() % (TetrisNumPieces * 113)) + 3) % TetrisNumPieces];
	pieceCol = [self width] / 2;
	pieceRow = [self height] - 1;
	pieceRotation = 0;
}

// Returns YES if the current floating piece will colide with another game board object or
//  edge given a new row / column / rotation value
- (BOOL) currPieceWillCollideAtRow: (int) row col: (int) col rotation: (int) rot
{
	if (!currPiece)
		return NO;
	
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		int checkRow = row + currPiece->offsets[rot][blk].rowOff;
		int checkCol = col + currPiece->offsets[rot][blk].colOff;
		
		if (checkRow < 0 || checkCol < 0 || checkCol >= [self width])
			return YES;

		// Enables the board to extend upwards past the screen.  Useful
		// when rotating pieces very early in their fall.
		if (checkRow >= self.height)
			continue;
		
		if (self->grid[TetrisArrIdx(checkRow, checkCol)] != NoTetromino)
			return YES;
	}

	return NO;
}

// Returns YES if any part of the current piece is off the grid
- (BOOL) currPieceOffGrid
{
	if (!currPiece)
		return NO;
	
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		int checkRow = pieceRow + currPiece->offsets[pieceRotation][blk].rowOff;
		int checkCol = pieceCol + currPiece->offsets[pieceRotation][blk].colOff;
		
		if (checkRow < 0 || checkRow >= [self height] ||
			checkCol < 0 || checkCol >= [self width])
			return YES;
	}
	
	return NO;
}

- (int) height
{
	return height;
}

- (int) width
{
	return TetrisNumCols;
}

- (int) timeStep
{
	return timeStep;
}

- (int) score
{
    return score;
}

- (void) slideLeft
{
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol - 1 rotation: pieceRotation])
		pieceCol--;
}

- (void) slideRight
{
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol + 1 rotation: pieceRotation])
		pieceCol++;
}

- (void) rotateCW
{
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol
								rotation: (pieceRotation + 1) % TetrisPieceRotations])
		pieceRotation = (pieceRotation + 1) % TetrisPieceRotations;
}

- (void) rotateCCW
{
	int newRot = pieceRotation - 1;
	while (newRot < 0)
		newRot += TetrisPieceRotations;
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol
								rotation: newRot])
		pieceRotation = newRot;
}

- (int) pieceAtRow: (int) row column: (int)col
{
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		if (row == (currPiece->offsets[pieceRotation][blk].rowOff + pieceRow) &&
			col == (currPiece->offsets[pieceRotation][blk].colOff + pieceCol) )
			return currPiece->name;
	}
	return self->grid[TetrisArrIdx(row, col)];
}

- (void) commitCurrPiece
{
	// Copy current floating piece into grid state
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		self->grid[TetrisArrIdx(currPiece->offsets[pieceRotation][blk].rowOff + pieceRow,
								currPiece->offsets[pieceRotation][blk].colOff + pieceCol)] =
		currPiece->name;
	}

	currPiece = NULL;
	
	// Check for lines that can be eliminated from grid
	int elimRowCnt = 0;
	for (int dstRow = 0; dstRow < [self height]; dstRow++) {
		int checkCol = 0;
		for (; checkCol < TetrisNumCols &&
			 self->grid[TetrisArrIdx(dstRow, checkCol)] != NoTetromino; checkCol++)
			;
		if (checkCol < TetrisNumCols)
			continue;
		
		// Copy grid state into board
		elimRowCnt++;
		for (int srcRow = dstRow + 1; srcRow < [self height]; srcRow++)
			for (int srcCol = 0; srcCol < TetrisNumCols; srcCol++)
				self->grid[TetrisArrIdx(srcRow - 1, srcCol)] =
					self->grid[TetrisArrIdx(srcRow, srcCol)];

		for (int col = 0; col < TetrisNumCols; col++)
			self->grid[TetrisArrIdx([self height] - 1, col)] = NoTetromino;
		dstRow--;
	}
    if (elimRowCnt == 1)
    {
        score+=100;
    }
    else if (elimRowCnt == 2)
    {
        score+=250;
    }
    else if (elimRowCnt == 3)
    {
        score+=450;
    }
    else if (elimRowCnt == 4)
    {
        score+=700;
    }
    else if (elimRowCnt >= 5)
    {
        score+=1000;
    }
}

- (void) advance
{
	if (gameOver)
		return;
	
	timeStep++;
	if (!currPiece)
		[self nextPiece];
	else if (![self currPieceWillCollideAtRow: pieceRow - 1 col: pieceCol  rotation: pieceRotation])
		pieceRow--;
	else if (![self currPieceOffGrid])
		[self commitCurrPiece];
	else
		gameOver = YES;
}

- (void) reset
{
    if (gameOver)
    {
        gameOver = NO;
    }
    timeStep = 0;
    score = 0;
    currPiece = 0;
    for (int gridSpot = 0; gridSpot < TetrisArrSize([self height]); gridSpot++)
    {
        grid[gridSpot] = 0;
    }
    
}

@end
