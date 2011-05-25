//
//  InfoGrabber.h
//  GradebookV1
//
//  Created by lokistudios on 5/25/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InfoGrabber : NSObject {
    
}

@property(nonatomic, copy) NSString *authHead;

- (id)initWithAuthenticationHeader: (NSString*)aHead;
- (NSDictionary*) getDictFromURL: (NSString*) url;


@end
