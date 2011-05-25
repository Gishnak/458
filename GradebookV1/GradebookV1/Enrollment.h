//
//  Enrollment.h
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Assignment.h"


@interface Enrollment : NSObject {
    NSString *name;
    NSMutableArray * assignments;
}

@property(nonatomic, copy) NSString *name;

- (id)initWithName:(NSString*)n;
@property (nonatomic, retain) NSMutableArray *assignments;

@end
