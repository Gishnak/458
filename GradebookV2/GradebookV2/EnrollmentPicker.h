//
//  EnrollmentPicker.h
//  GradebookV1
//
//  Created by lokistudios on 5/24/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section.h"
#import "Enrollment.h"


@interface EnrollmentPicker : UITableViewController {
    Section* section;
}

@property (nonatomic, assign) Section* section;


@end
