//
//  DetailContainer.h
//  Gradebook
//
//  Created by John Bellardo on 5/21/11.
//  Copyright 2011 California State Polytechnic University, San Luis Obispo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailContainer : UIViewController <UISplitViewControllerDelegate> {    
}
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) IBOutlet UIView *childView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *titleItem;
@end
