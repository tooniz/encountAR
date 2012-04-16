//
//  SnapViewController.m
//  encountAR
//
//  Created by Ming Zhou on 12-03-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SnapViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
//#import "CommentViewController.h"
#import "TZGradientButton.h"
#import "ActionViewController.h"
#import "ThreadsTableViewController.h"
#import "PostCommentViewController.h"
#import "IADisquser.h"

@implementation SnapViewController
@synthesize encountarImg;
@synthesize encountarBtn;
@synthesize historyBtn;
@synthesize toggleBtn;
@synthesize backwardBtn;
@synthesize forwardBtn;
@synthesize addBtn;
@synthesize replyBackground;
@synthesize replyPoster;
@synthesize replyDate;
@synthesize replyPosterPicture;
@synthesize encountARView;
@synthesize indicator;
@synthesize templateNumMax, templateNumMin, templateNumOffset;

@synthesize s0V, s1V, s2V, s3V;
@synthesize lblComment, lblTitle;
@synthesize threadID;
int counter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [historyBtn setHighColor:[UIColor whiteColor]];
    [historyBtn setLowColor:[UIColor brownColor]];
    [toggleBtn setHighColor:[UIColor whiteColor]];
    [toggleBtn setLowColor:[UIColor brownColor]];
    
    //Aestheics - Dropshadow
    lblTitle.layer.shadowOffset = CGSizeMake(0, 0);
    lblTitle.layer.shadowRadius = 2;
    lblTitle.layer.shadowColor = [UIColor blackColor].CGColor;
    lblTitle.layer.shadowOpacity = 0.8;
    
    //Aesthetics - round edges
    //lblComment.layer.cornerRadius=15.0f;
    //lblComment.layer.masksToBounds=YES;
    //lblComment.layer.borderColor=[[[UIColor alloc] initWithWhite:0.2 alpha:0.8] CGColor];
    //lblComment.layer.borderWidth= 1.0f;
    
    //s0V = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topleftzoom.png"]];//[[UIView alloc] initWithFrame:frame];
    //s1V = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomleftzoom.png"]];//[[UIView alloc] initWithFrame:frame];
    //s2V = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomrightzoom.png"]]; //[[UIView alloc] initWithFrame:frame];
    //s3V = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toprightzoom.png"]]; //[[UIView alloc] initWithFrame:frame];
    
    counter = 2;
    [self.view addSubview:s0V];
    [self.view addSubview:s1V];
    [self.view addSubview:s2V];
    [self.view addSubview:s3V];
    [self.view addSubview:historyBtn];
    [self.view addSubview:toggleBtn];
    // for this demo update the target corners on a simple timer 
    [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(moveObjects:) userInfo:NULL repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (app.artNum == 1) {
        templateNumOffset = 0;
        templateNumMin = 2;
        templateNumMax = 4;
    }
    else {
        templateNumOffset = 3;
        templateNumMin = 2;
        templateNumMax = 4;
    }
    encountarImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"encountAR%d.png", counter+templateNumOffset]];
    [self refreshMostRecentCommentAndAvatar:counter];
    
}

- (void)viewDidUnload
{
    [self setLblComment:nil];
    [self setLblTitle:nil];
    [self setView:nil];
    [self setHistoryBtn:nil];
    [self setToggleBtn:nil];
    [self setEncountarBtn:nil];
    [self setEncountarImg:nil];
    [self setBackwardBtn:nil];
    [self setForwardBtn:nil];
    [self setReplyBackground:nil];
    [self setReplyPoster:nil];
    [self setReplyDate:nil];
    [self setReplyPosterPicture:nil];
    [self setAddBtn:nil];
    [self setAddBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    s0V = nil;
    s1V = nil;
    s2V = nil;
    s3V = nil;
}

- (void) viewDidAppear:(BOOL)animated {
    // retrive comments for display
    //lblTitle.text = app.tempTitle;
    if (app.tempComment.length > 0) {
    lblComment.text = app.tempComment;    
    }
    // Do any additional setup after loading the view from its nib.

    CGPoint pos;
    CGRect screenBounds = [self.view.superview bounds];
    //CGRect frame = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
    pos.x = screenBounds.size.width / 2;
    pos.y = screenBounds.size.height / 2;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(90 * M_PI  / 180);
    //self.view.frame = frame;
    //self.view.layer.position = pos;
    self.view.transform = rotate;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft )
        return YES;
    
    return NO;
}

#pragma mark - Other Utility Fns
- (void)moveObjects:(NSTimer*)theTimer
{
    CGFloat encountar_to_box_x_offset = 96;
    CGFloat encountar_to_box_y_offset = 90;
    
    CGFloat frame_width;
    CGFloat frame_height;
    
    CGFloat frame_x;
    CGFloat frame_y;
    
    // TOP LEFT CORNER
    frame_x = app.s0.x - 100; //app.artCoord.x;
    frame_y = app.s0.y - 50; //app.artCoord.y;

    // ENCOUNTAR TEMPLATE
    frame_width = encountarImg.frame.size.width;
    frame_height = encountarImg.frame.size.height;
    CGRect frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    encountarImg.frame = frame;
    encountarImg.alpha = ENCOUNTAR_ALPHA;

    // COMMENT BOX
    frame_x += encountar_to_box_x_offset;
    frame_y += encountar_to_box_y_offset;
    frame_width = lblComment.frame.size.width;
    frame_height = lblComment.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    lblComment.frame = frame;

    // THE INVISIBLE ENCOUNTAR BTN
    frame_width = encountarBtn.frame.size.width;
    frame_height = encountarBtn.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    encountarBtn.frame = frame;
    
    // COMMENT TITLE
    //frame_x = frame_x +10;
    //frame_y = frame_y - 40;
    //frame_width = lblTitle.frame.size.width;
    //frame_height = lblTitle.frame.size.height;
    //frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    //lblTitle.frame = frame;
    lblTitle.alpha = 0;
    
    // REPLY FRAMES
    frame_x = app.s0.x - 100 + 194;
    frame_y = app.s0.y - 50 + 168;
    frame_width = replyBackground.frame.size.width;
    frame_height = replyBackground.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    replyBackground.frame = frame;
    replyBackground.alpha = ENCOUNTAR_ALPHA;

    frame_width = replyPoster.frame.size.width;
    frame_height = replyPoster.frame.size.height;
    frame = CGRectMake(frame_x+78, frame_y-3, frame_width, frame_height);
    replyPoster.frame = frame;
    replyPoster.alpha = ENCOUNTAR_ALPHA;

    frame_width = replyPosterPicture.frame.size.width;
    frame_height = replyPosterPicture.frame.size.height;
    frame = CGRectMake(frame_x+108, frame_y-27, frame_width, frame_height);
    replyPosterPicture.frame = frame;
    replyPosterPicture.alpha = ENCOUNTAR_ALPHA;

    frame_width = replyDate.frame.size.width;
    frame_height = replyDate.frame.size.height;
    frame = CGRectMake(frame_x+151, frame_y-3, frame_width, frame_height);
    replyDate.frame = frame;
    replyDate.alpha = ENCOUNTAR_ALPHA;

    // TOGGLE BTN
    frame_x = app.s2.x - toggleBtn.frame.size.width + 50;
    frame_y = app.s2.y;
    frame_width = toggleBtn.frame.size.width;
    frame_height = toggleBtn.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    toggleBtn.frame = frame;
    
    // HISTORY BTN
    frame_x = frame_x - historyBtn.frame.size.width - 10;
    frame_y = frame_y;
    frame_width = historyBtn.frame.size.width;
    frame_height = historyBtn.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    historyBtn.frame = frame;
    
    // FORWARD BTN
    frame_x = frame_x - forwardBtn.frame.size.width - 15;
    frame_y = frame_y;
    frame_width = forwardBtn.frame.size.width;
    frame_height = forwardBtn.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    forwardBtn.frame = frame;
    forwardBtn.alpha = 0.6;
    
    // BACKWARD BTN
    frame_x = frame_x - backwardBtn.frame.size.width - 15;
    frame_y = frame_y;
    frame_width = backwardBtn.frame.size.width;
    frame_height = backwardBtn.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    backwardBtn.frame = frame;
    backwardBtn.alpha = 0.6;
    
    // BACKWARD BTN
    frame_x = frame_x - addBtn.frame.size.width - 15;
    frame_y = frame_y;
    frame_width = addBtn.frame.size.width;
    frame_height = addBtn.frame.size.height;
    frame = CGRectMake(frame_x, frame_y, frame_width, frame_height);
    addBtn.frame = frame;
    addBtn.alpha = 0.6;

    // CORNERS
    CGRect cornerframe = CGRectMake(app.s0.x, app.s0.y, 20, 20);
    s0V.frame = cornerframe;
    cornerframe = CGRectMake(app.s1.x, app.s1.y, 20, 20);
    s1V.frame = cornerframe;
    cornerframe = CGRectMake(app.s2.x, app.s2.y, 20, 20);
    s2V.frame = cornerframe;
    cornerframe = CGRectMake(app.s3.x, app.s3.y, 20, 20);
    s3V.frame = cornerframe;
    
}

- (void)dealloc {
    [lblComment release];
    [lblTitle release];
    [s0V release];
    [s1V release];
    [s2V release];
    [s3V release];
    [encountARView release];
    [historyBtn release];
    [toggleBtn release];
    [encountarBtn release];
    [encountarImg release];
    [backwardBtn release];
    [forwardBtn release];
    [replyBackground release];
    [replyPoster release];
    [replyDate release];
    [replyPosterPicture release];
    [addBtn release];
    [super dealloc];
}

- (IBAction)tapEncountar:(id)sender {
    /*CommentViewController *commentView = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:commentView animated:YES];
    commentView = nil;*/
    PostCommentViewController *pcvc = [[PostCommentViewController alloc] init];
    pcvc.title = @"Post Your Comment";
    if (counter == 2) {
        if (app.artNum == 1) {
            pcvc.threadID = @"625370257";
        }
        else {
            pcvc.threadID = @"634456427";
        }
    }
    else if (counter == 3) {
        if (app.artNum == 1) {
            pcvc.threadID = @"625370808";
        }
        else {
            pcvc.threadID = @"634457055";
        }
    }
    else if (counter == 4) {
        if (app.artNum == 1) {
            pcvc.threadID = @"625371049";
        }
        else {
            pcvc.threadID = @"634460216";
        }
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pcvc];
    
    app.isPaused = 1;
    [self presentModalViewController:navigationController animated:YES];
    [pcvc release];
    [navigationController release];
    
}

- (void) refreshMostRecentCommentAndAvatar: (int) counter{
    [[self indicator] startAnimating];
    
    if (counter == 2) {
        if (app.artNum == 1) {
            threadID = [NSString stringWithString:@"625370257"];
        }
        else {
            threadID = [NSString stringWithString:@"634456427"];
        }
    }
    else if (counter == 3) {
        if (app.artNum == 1) {
            threadID = [NSString stringWithString:@"625370808"];
        }
        else {
            threadID = [NSString stringWithString:@"634457055"];
        }
    }
    else if (counter == 4) {
        if (app.artNum == 1) {
            threadID = [NSString stringWithString:@"625371049"];
        }
        else {
            threadID = [NSString stringWithString:@"634460216"];
        }
    }
    // fire the request
    [IADisquser getMostRecentCommentsFromThreadID:threadID 
                                    success:^(NSArray *_comments) {
                                    // get the array of comments, reverse it (oldest comment on top) 
                                    self.lblComment.text = [[_comments lastObject] rawMessage];
                                    NSArray* wholeName = [[[_comments lastObject] authorName] componentsSeparatedByString: @" "];
                                    self.replyPoster.text = [wholeName objectAtIndex: 0];
                                    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                                    [dateFormatter setDateFormat:@"MM.dd.yy HH:mm:ss"];
                                    self.replyDate.text = [dateFormatter stringFromDate:[[_comments lastObject] date]];
                                    [self.replyPosterPicture setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[_comments lastObject] authorURL]]]]];
                                     // stop activity indicator
                                    [[self indicator] stopAnimating];

                                } fail:^(NSError *error) {
                                    // start activity indicator
                                    [[self indicator] stopAnimating];
                                    
                                    // alert the error
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Occured" 
                                                                                    message:[error localizedDescription] 
                                                                                   delegate:nil 
                                                                          cancelButtonTitle:@"OK" 
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }];
}

- (IBAction)prsToggleBtn:(id)sender {
    if (lblComment.hidden == YES) {
        lblComment.hidden = NO;
        lblTitle.hidden = NO;
        encountarImg.hidden = NO;
        replyBackground.hidden = NO;
        replyDate.hidden = NO;
        replyPoster.hidden = NO;
        replyPosterPicture.hidden = NO;
    }
    else {
        lblComment.hidden = YES;
        lblTitle.hidden = YES;
        encountarImg.hidden = YES;
        replyBackground.hidden = YES;
        replyDate.hidden = YES;
        replyPoster.hidden = YES;
        replyPosterPicture.hidden = YES;
    }
}

- (IBAction)prsAddBtn:(id)sender {
}

- (IBAction)prsBackwardBtn:(id)sender {
    counter--;
    if (counter < templateNumMin) {
        counter = templateNumMax;
    }
    [self refreshMostRecentCommentAndAvatar:counter];
    [UIView beginAnimations:@"disappear" context:nil];
    encountarImg.alpha = 0.3;
    replyBackground.alpha = 0.3;
    replyDate.alpha = 0.3;
    replyPoster.alpha = 0.3;
    replyPosterPicture.alpha = 0.3;

    [UIView commitAnimations];
    encountarImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"encountAR%d.png", counter+templateNumOffset]];
    [UIView beginAnimations:@"appear" context:nil];
    encountarImg.alpha = 1;
    replyBackground.alpha = 1;
    replyDate.alpha = 1;
    replyPoster.alpha = 1;
    replyPosterPicture.alpha = 1;
    [UIView commitAnimations];
}

- (IBAction)prsForwardBtn:(id)sender {
    counter++;
    if (counter > templateNumMax) {
        counter = templateNumMin;
    }
    [self refreshMostRecentCommentAndAvatar:counter];
    [UIView beginAnimations:@"disappear" context:nil];
    encountarImg.alpha = 0.3;
    replyBackground.alpha = 0.3;
    replyDate.alpha = 0.3;
    replyPoster.alpha = 0.3;
    replyPosterPicture.alpha = 0.3;
    [UIView commitAnimations];
    encountarImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"encountAR%d.png", counter+templateNumOffset]];
    [UIView beginAnimations:@"appear" context:nil];
    encountarImg.alpha = 1;
    replyBackground.alpha = 1;
    replyDate.alpha = 1;
    replyPoster.alpha = 1;
    replyPosterPicture.alpha = 1;
    [UIView commitAnimations];
}

- (IBAction)prsHistoryBtn:(id)sender {
    ThreadsTableViewController *ttvc = [[ThreadsTableViewController alloc] init];
    ttvc.title = @"EncountARs";
    if (app.artNum == 1) {
         NSLog(@"category 1");
        ttvc.categoryID = @"1358702";
    }
    else {
        NSLog(@"category 2");
        ttvc.categoryID = @"1393712";
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:ttvc];
    [ttvc release];                                            
    [self presentModalViewController:navigationController animated:YES];
    app.isPaused = 1;
}
@end
