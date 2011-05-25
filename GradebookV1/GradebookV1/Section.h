//
//  Section.h
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Section : NSObject {
    NSString *name;
    NSString *term;
    NSMutableArray * enrollments;
}

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *term;
@property (nonatomic, retain) NSMutableArray *enrollments;

- (id)initWithNameAndTerm: (NSString*)n term: (NSString*)t;

@end
