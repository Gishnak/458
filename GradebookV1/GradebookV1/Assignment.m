//
//  Assignment.m
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import "Assignment.h"


@implementation Assignment

@synthesize name = _name;
@synthesize scores =_scores;

- (id)initWithName: (NSString*)n {
    self.name = n;
    return self;
}

- (void) dealloc {
    [super dealloc];
    [_scores release];
    [_name release];
}

@end
