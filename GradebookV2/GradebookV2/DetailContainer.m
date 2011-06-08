//
//  DetailContainer.m
//  Gradebook
//
//  Created by John Bellardo on 5/21/11.
//  Copyright 2011 California State Polytechnic University, San Luis Obispo. All rights reserved.
//

#import "DetailContainer.h"

@implementation DetailContainer
@synthesize toolbar = toolbar_;
@synthesize viewController = viewController_;
@synthesize childView = childView_;
@synthesize titleItem = titleItem_;

- (void) viewDidLoad
{
    if (!self.viewController)
        [self setViewController:nil];
    
    [super viewDidLoad];
}

- (void) setViewController:(UIViewController *)viewController
{
    if (self.viewController) {
        [self.viewController.view removeFromSuperview];
        [viewController_ release];
    }
    if (!viewController)
        viewController_ = viewController = [[UIViewController alloc] init];
    else
        viewController_ = [viewController retain];
    
    self.viewController.view.frame = self.childView.bounds;
    [self.childView addSubview:self.viewController.view];
    self.titleItem.title = self.viewController.title;
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    UINavigationController *navCtl = [svc.viewControllers objectAtIndex:0];
    if ([navCtl isKindOfClass:[UINavigationController class]]) {
        barButtonItem.title = [[[navCtl viewControllers] lastObject] title];
    }
    else
        barButtonItem.title = navCtl.title;

    NSMutableArray *items = [self.toolbar.items mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    //    self.mainPopoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {    
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    //    self.mainPopoverController = nil;
}


// Called when the hidden view controller is about to be displayed in a popover.
- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController {
	// Check to see if the popover presented from the "Tap" UIBarButtonItem is visible.
	// if ([barButtonItemPopover isPopoverVisible]) {
		// Dismiss the popover.
        // [barButtonItemPopover dismissPopoverAnimated:YES];
    // } 
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [toolbar_ release];
    [viewController_ release];
    [childView_ release];
    [titleItem_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidUnload
{
    self.viewController = nil;
    [self setToolbar:nil];
    [self setChildView:nil];
    [self setTitleItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
