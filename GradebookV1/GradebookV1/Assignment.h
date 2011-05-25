//
//  Assignment.h
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Score.h"


@interface Assignment : NSObject {
    NSString *name;
    NSMutableArray *scores;
    
}

@property(nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSMutableArray *scores;

- (id)initWithName:(NSString*)n;

@end

