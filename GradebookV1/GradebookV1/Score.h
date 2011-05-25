//
//  Score.h
//  GradebookV1
//
//  Created by lokistudios on 5/25/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Score : NSObject {
    NSString *name;
}

@property(nonatomic, copy) NSString *name;
- (id)initWithName:(NSString*)n;
@end
