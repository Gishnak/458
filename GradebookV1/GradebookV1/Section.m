//
//  Section.m
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import "Section.h"

@implementation Section

@synthesize name = _name;
@synthesize enrollments = _enrollments;
@synthesize term = _term;

- (id)initWithNameAndTerm: (NSString*)n term: (NSString*)t{
    self.term = t;
    self.name = n;
    return self;
}

- (void) dealloc {
    [super dealloc];
    [_enrollments release];
    [_name release];
}

@end
