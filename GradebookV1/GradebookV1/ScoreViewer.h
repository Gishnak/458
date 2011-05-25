//
//  ScoreViewer.h
//  GradebookV1
//
//  Created by lokistudios on 5/25/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"


@interface ScoreViewer : UITableViewController {
    
    Assignment *assignment;
}
@property (nonatomic, assign) Assignment* assignment;
@end
