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

@interface TetrisEngine()
@property (nonatomic) int height;
@property (nonatomic) int timeStep;
@property (nonatomic) int score;
@property (nonatomic) int gridVersion;
@property (retain, nonatomic) NSTimer* stepTimer;
@end

@implementation TetrisEngine

@synthesize height = height_;
@synthesize timeStep = timeStep_;
@synthesize score = score_;
@synthesize gridVersion = gridVersion_;
@synthesize stepTimer = stepTimer_;
@synthesize antiGrav = antiGrav_;

- (id) init
{
	return [self initWithHeight: 20];
}

- (id) initWithHeight: (int) h
{	
	self = [super init];
	if (self) {
		srandom(time(0));
		self.height = h;

        grid = [[[NSMutableArray alloc] init] retain];
	}
    
    [self reset];
	return self;
}
- (id) initWithState:(NSDictionary *)state
{
    self = [self initWithHeight: [(NSNumber*)[state valueForKey: @"height"] intValue]];
    [grid setArray: (NSMutableArray*)[state valueForKey: @"grid"]];
    
    int pieceNum = [(NSNumber*)[state valueForKey: @"currPieceName"] intValue] - 1 % TetrisNumPieces;  
    if (pieceNum >= 0) {
        currPiece = &pieces[pieceNum];
    }
    pieceRow = [(NSNumber*)[state valueForKey: @"pieceRow"] intValue];
    pieceCol = [(NSNumber*)[state valueForKey: @"pieceCol"] intValue];
    pieceRotation = [(NSNumber*)[state valueForKey: @"pieceRotation"] intValue];
    
    self.score = [((NSNumber*)[state valueForKey: @"score"]) intValue];
    self.timeStep = [(NSNumber*)[state valueForKey: @"timeStep"] intValue];
    
    
    return self;
}

- (NSDictionary*) currentState
{
    NSMutableDictionary* state = [[[NSMutableDictionary alloc] init] autorelease];
    [state setValue: grid forKey: @"grid"];
    [state setValue: [NSNumber numberWithInt: self.height] forKey: @"height"];
    
    [state setValue: [NSNumber numberWithInt: pieceRow] forKey: @"pieceRow"];
    [state setValue: [NSNumber numberWithInt: pieceCol] forKey: @"pieceCol"];
    [state setValue: [NSNumber numberWithInt: pieceRotation] forKey: @"pieceRotation"];
    if (currPiece) {
    [state setValue: [NSNumber numberWithInt: currPiece->name] forKey: @"currPieceName"];
    }
    else {    
        [state setValue: [NSNumber numberWithInt: NoTetromino] forKey: @"currPieceName"];
    }
    
    
    [state setValue:[NSNumber numberWithInt: self.score] forKey: @"score"];
    [state setValue:[NSNumber numberWithInt: self.timeStep] forKey: @"timeStep"];

    return state;
}


// Add the next floating piece to the game board
- (void) nextPiece
{
	currPiece = &pieces[ ((random() % (TetrisNumPieces * 113)) + 3) % TetrisNumPieces];
	pieceCol = self.width / 2;
	pieceRow = self.height - 1;
	pieceRotation = 0;
    self.gridVersion++;
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
		
		if (checkRow < 0 || checkCol < 0 || checkCol >= self.width)
			return YES;

		// Enables the board to extend upwards past the screen.  Useful
		// when rotating pieces very early in their fall.
		if (checkRow >= self.height)
			continue;
		if ([(NSNumber*)[grid objectAtIndex: TetrisArrIdx(checkRow, checkCol)] intValue] != NoTetromino)
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
		
		if (checkRow < 0 || checkRow >= self.height ||
			checkCol < 0 || checkCol >= self.width)
			return YES;
	}
	
	return NO;
}


- (int) width
{
	return TetrisNumCols;
}

- (BOOL) running
{
    return (self.stepTimer != nil);
}

- (void) pieceDown
{
    if ([self running]) {
        if (![self currPieceWillCollideAtRow: pieceRow - 1 col: pieceCol rotation: pieceRotation])
		pieceRow--;
        self.gridVersion++;
    }
}
- (void) pieceUp
{
    if ([self running]) {
        if (self.antiGrav){
            if (![self currPieceWillCollideAtRow: pieceRow + 1 col: pieceCol rotation: pieceRotation])
                pieceRow++;
                self.gridVersion++;
        }
    }
}

- (void) slideLeft
{
    if ([self running]) {
        if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol - 1 rotation: pieceRotation])
            pieceCol--;
            self.gridVersion++;
    }
}

- (void) slideRight
{
    if ([self running]) {
        if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol + 1 rotation: pieceRotation])
		pieceCol++;
        self.gridVersion++;
    }
}

- (void) rotateCW
{
    if ([self running]) {
        if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol
								rotation: (pieceRotation + 1) % TetrisPieceRotations])
            pieceRotation = (pieceRotation + 1) % TetrisPieceRotations;
            self.gridVersion++;
    }
        
}

- (void) rotateCCW
{
    if ([self running]) {
        int newRot = pieceRotation - 1;
        while (newRot < 0)
		newRot += TetrisPieceRotations;
        if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol
								rotation: newRot])
		pieceRotation = newRot;
        self.gridVersion++;
    }
}

- (int) pieceAtRow: (int) row column: (int)col
{
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		if (row == (currPiece->offsets[pieceRotation][blk].rowOff + pieceRow) &&
			col == (currPiece->offsets[pieceRotation][blk].colOff + pieceCol) )
			return currPiece->name;
	}
    return [(NSNumber*)[grid objectAtIndex:TetrisArrIdx(row, col) ] intValue];
}

- (void) commitCurrPiece
{
	// Copy current floating piece into grid state
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
        [grid replaceObjectAtIndex:TetrisArrIdx(currPiece->offsets[pieceRotation][blk].rowOff + pieceRow,
                                                       currPiece->offsets[pieceRotation][blk].colOff + pieceCol) withObject:[NSNumber numberWithInt:currPiece->name]];
	}

	currPiece = NULL;
	
	// Check for lines that can be eliminated from grid
	int elimRowCnt = 0;
	for (int dstRow = 0; dstRow < self.height; dstRow++) {
		int checkCol = 0;
        for (; checkCol < TetrisNumCols && [(NSNumber*)[grid objectAtIndex:TetrisArrIdx(dstRow, checkCol)] intValue] != NoTetromino; checkCol++)
                                            ;
		if (checkCol < TetrisNumCols)
			continue;
		
		// Copy grid state into board
		elimRowCnt++;
		for (int srcRow = dstRow + 1; srcRow < self.height; srcRow++)
			for (int srcCol = 0; srcCol < TetrisNumCols; srcCol++)
                [grid replaceObjectAtIndex:TetrisArrIdx(srcRow - 1, srcCol) withObject: [grid objectAtIndex:TetrisArrIdx(srcRow, srcCol)]];

		for (int col = 0; col < TetrisNumCols; col++)
            [grid replaceObjectAtIndex:TetrisArrIdx(self.height -1, col) withObject:[NSNumber numberWithInt:NoTetromino]];
		dstRow--;
	}
    if (elimRowCnt == 1)
    {
        self.score+=100;
    }
    else if (elimRowCnt == 2)
    {
        self.score+=250;
    }
    else if (elimRowCnt == 3)
    {
        self.score+=450;
    }
    else if (elimRowCnt == 4)
    {
        self.score+=700;
    }
    else if (elimRowCnt >= 5)
    {
        self.score+=1000;
    }
    self.gridVersion++;
}

- (void) advance
{
	if (gameOver)
		return;
	
	self.timeStep++;
	if (!currPiece)
		[self nextPiece];
	else if (![self currPieceWillCollideAtRow: pieceRow - 1 col: pieceCol  rotation: pieceRotation])
		pieceRow--;
	else if (![self currPieceOffGrid])
		[self commitCurrPiece];
	else
		gameOver = YES;
    self.gridVersion++;
}
- (void) start
{
    if (!self.stepTimer) {
              NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0.0];
            self.stepTimer = [[NSTimer alloc] initWithFireDate:fireDate
                                               interval:1.0
                                               target:self
                                           selector:@selector(advance)
                                         userInfo:nil
                                        repeats:YES];
     NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
     [runLoop addTimer:self.stepTimer forMode:NSDefaultRunLoopMode];
    
    }
    
}

- (void) stop
{
    [self.stepTimer invalidate];
    [self.stepTimer release];
    self.stepTimer = nil;
}
- (void) reset
{
    if (gameOver)
    {
        gameOver = NO;
    }
    self.timeStep = 0;
    self.score = 0;
    currPiece = 0;
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:TetrisArrSize(self.height)]; 
    for (int i = 0; i < TetrisArrSize([self height]); i++) 
    {
        [temp addObject: [NSNumber numberWithInt: 0]];
    }
    [grid setArray: temp];
    self.gridVersion++;
    
}





- (void) saveState 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id state = [self currentState];
    [defaults setObject:state forKey: @"gameState"];
    [defaults synchronize];
    
}

- (void) restoreState
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *state = (NSDictionary*)[defaults objectForKey: @"gameState"];
    if (state) {
        [self initWithState: state];
        //engine = [[TetrisEngine alloc] initWithHeight:10];
    }
    
}

- (void)dealloc
{
    [grid release];
    [super dealloc];
}




@end
