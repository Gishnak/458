//
//  Enrollment.m
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import "Enrollment.h"


@implementation Enrollment

@synthesize name = _name;
@synthesize assignments = _assignments;

- (id)initWithName: (NSString*)n {
    self.name = n;
    return self;
}

- (void) dealloc {
    [super dealloc];
    [_assignments release];
    [_name release];
}
@end
