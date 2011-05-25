//
//  Score.m
//  GradebookV1
//
//  Created by lokistudios on 5/25/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import "Score.h"


@implementation Score

@synthesize name = _name;

- (id)initWithName: (NSString*)n {
    self.name = n;
    return self;
}

- (void) dealloc {
    [super dealloc];
    [_name release];
}
@end
