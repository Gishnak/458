//
//  AssignmentPicker.h
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enrollment.h"

@interface AssignmentPicker : UITableViewController {
    Enrollment* enrollment;
    
}

@property (nonatomic, assign) Enrollment* enrollment;
@end
