//
//  DetailViewController.h
//  GradebookV2
//
//  Created by lokistudios on 6/6/11.
//  Copyright 2011 Loki Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {

}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;

@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@end
