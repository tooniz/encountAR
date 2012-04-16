//
//  ActionViewController.m
//  ImageTargets
//
//  Created by Alexander Sommer on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionViewController.h"
#import "CommentViewController.h"
#import "TZGradientButton.h"
#import "AppDelegate.h"
#import "SnapViewController.h"
#import "ThreadsTableViewController.h"

@implementation ActionViewController
@synthesize snapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) hideView {
}
- (void) showView {
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    snapView = [[SnapViewController alloc] initWithNibName:@"SnapViewController" bundle:[NSBundle mainBundle]];
    //snapView.encountARView.transform = rotate;
    CGPoint pos;
    CGRect screenBounds = [self.view bounds];
    CGRect frame = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
    pos.x = screenBounds.size.width / 2;
    pos.y = screenBounds.size.height / 2;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(90 * M_PI  / 180);
    snapView.view.frame = frame;
    snapView.view.layer.position = pos;
    snapView.view.transform = rotate;
    [self.view addSubview:snapView.view];

    //[self initARView];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setSnapView:nil];
    [self setArView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
/*
    snapView.lblTitle.text = app.tempTitle;
    snapView.lblComment.text = app.tempComment;
    if (snapView.lblComment.text.length == 0) {
        snapView.lblComment.hidden = YES;
        snapView.lblTitle.hidden = YES;
    }
    else {
        snapView.lblComment.hidden = NO;
        snapView.lblTitle.hidden = NO;
    }
*/
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)dealloc {
    [snapView release];
    [super dealloc];
}

@end
