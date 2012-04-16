/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/
/*
 
 The QCAR sample apps are organised to work with standard iOS view
 controller life cycles.
 
 * QCARutils contains all the code that initialises and manages the QCAR
 lifecycle plus some useful functions for accessing targets etc. This is a
 singleton class that makes QCAR accessible from anywhere within the app.
 
 * AR_EAGLView is a superclass that contains the OpenGL setup for its
 sub-class, EAGLView.
 
 Other classes and view hierarchy exists to establish a robust view life
 cycle:
 
 * ARParentViewController provides a root view for inclusion in other view
 hierarchies  presentModalViewController can present this VC safely. All
 associated views are included within it; it also handles the auto-rotate
 and resizing of the sub-views.
 
 * ARViewController manages the lifecycle of the Camera and Augmentations,
 calling QCAR:createAR, QCAR:destroyAR, QCAR:pauseAR and QCAR:resumeAR
 where required. It also manages the data for the view, such as loading
 textures.
 
 This configuration has been shown to work for iOS Modal and Tabbed views.
 It provides a model for re-usability where you want to produce a
 number of applications sharing code.
 
 --------------------------------------------------------------------------------*/


#import "AppDelegate.h"
#import "ARParentViewController.h"
#import "ActionViewController.h"
#import "QCARutils.h"
#import "IADisquser.h"
#import "PostCommentViewController.h"
#import "ThreadsTableViewController.h"
#import "HelpViewController.h"
#import "TZGradientButton.h"
static NSString* kAppId = @"276219952455194";

@implementation AppDelegate

@synthesize window;
@synthesize actionViewController;
@synthesize cameraZoom;
@synthesize cameraLabel;
@synthesize artPieces;
@synthesize comments;
@synthesize tempComment, tempTitle;
@synthesize artCoord;
@synthesize s0,s1,s2,s3;
@synthesize facebook;
@synthesize isUsingFacebook;
@synthesize isPaused;
@synthesize isScanningOn;
@synthesize needRefreshMostRecentComment;
@synthesize helpBtn;
@synthesize artNum;
static BOOL firstTime = YES;

// test to see if the screen has hi-res mode
- (BOOL) isRetinaEnabled
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
            &&
            ([UIScreen mainScreen].scale == 2.0));
}

// Setup a continuation of the splash screen until the camera is initialised
- (void) setupSplashContinuation
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    // first get the splash screen continuation in place
    NSString *splashImageName = @"Default.png";
    if ((screenBounds.size.width == 320) && [self isRetinaEnabled])
        splashImageName = @"Default@2x.png";
    
    UIImage *image = [UIImage imageNamed:splashImageName];
    splashV = [[UIImageView alloc] initWithImage:image];
    splashV.frame = screenBounds;
    [window addSubview:splashV];
    
    // poll to see if the camera video stream has started and if so remove the splash screen.
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(removeSplash:) userInfo:nil repeats:YES];
}


- (void)prsHelpBtn:(UIControl *)c withEvent:ev {
    cameraZoom.hidden = YES;
}

// this is the application entry point
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize facebook
    
    
    // COMMENT TEST
    //[IADisquser getThreadsFromCategoryID:@"1358702" success:^(NSArray *_comments){} fail:^(NSError *error) {}];
    //[IADisquser getMostRecentCommentsFromThreadID:@"609046425" success:^(NSArray *_comments){} fail:^(NSError *error) {}];
    
    QCARutils *qUtils = [QCARutils getInstance];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    window = [[UIWindow alloc] initWithFrame: screenBounds];
    
    [self setupSplashContinuation];
    
    // Provide a list of targets we're expecting - the first in the list is the default
    [qUtils addTargetName:@"encountAR_poitras" atPath:@"encountAR_poitras.xml"];
    //[qUtils addTargetName:@"whereiswaldo" atPath:@"whereiswaldo.xml"];
    [qUtils addTargetName:@"Stones & Chips" atPath:@"StonesAndChips.xml"];
    [qUtils addTargetName:@"Tarmac" atPath:@"Tarmac.xml"];
    //[qUtils addTargetName:@"Poitras" atPath:@"Poitras.xml"];
    
    cameraZoom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camerazoom"]];
    CGRect frame = {screenBounds.size.width/2 - cameraZoom.image.size.width/2,
                    screenBounds.size.height/2 - cameraZoom.image.size.height/2,
                    cameraZoom.image.size.width,cameraZoom.image.size.height};
    cameraZoom.frame = frame;
    cameraZoom.alpha = 0.5;
    
    artPieces = [[NSMutableArray alloc] init];
    // Add the EAGLView and the overlay view to the window
    arParentViewController = [[ARParentViewController alloc] init];
    arParentViewController.arViewRect = screenBounds;
    [window insertSubview:arParentViewController.view atIndex:0];
    
    actionViewController = [[ActionViewController alloc] initWithNibName:@"ActionViewController" bundle:[NSBundle mainBundle]];
    [window insertSubview:actionViewController.view atIndex:1];
    [window makeKeyAndVisible];
    
    isPaused = 0;
    
    // Help button
    helpBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question"]];
    //helpBtn = [UIButton buttonWithType:UIButtonTypeCustom]; //initWithImage:[UIImage imageNamed:@"question"]];
    //[helpBtn setBackgroundImage:[UIImage imageNamed:@"question"] forState:UIControlStateNormal];
    CGRect helpFrame = {50, screenBounds.size.height - 24 - 50, 24, 24};
    helpBtn.frame = helpFrame;
    helpBtn.alpha = 0.6;
    //helpBtn.userInteractionEnabled = YES;
    //[helpBtn addTarget:self action:@selector(prsHelpBtn:withEvent:) forControlEvents: UIControlEventTouchDown];
    
    return YES;
}


// this is the application entry point
- (BOOL)applicationOld:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    QCARutils *qUtils = [QCARutils getInstance];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    window = [[UIWindow alloc] initWithFrame: screenBounds];
    
    //[self setupSplashContinuation];
    
    // Provide a list of targets we're expecting - the first in the list is the default
    [qUtils addTargetName:@"encountar_poitras" atPath:@"encountar_poitras.xml"];
    [qUtils addTargetName:@"Stones & Chips" atPath:@"StonesAndChips.xml"];
    [qUtils addTargetName:@"Tarmac" atPath:@"Tarmac.xml"];
    //[qUtils addTargetName:@"Poitras" atPath:@"Poitras.xml"];
    
    // Add the EAGLView and the overlay view to the window
    arParentViewController = [[ARParentViewController alloc] init];
    arParentViewController.arViewRect = screenBounds;
    // [window insertSubview:arParentViewController.view atIndex:0];  
    isScanningOn = 1;
    
    return YES;
}

- (void) hideView {
    if (isPaused == 0) {
        [actionViewController.view removeFromSuperview];
        [window addSubview:cameraZoom];
        [window addSubview:helpBtn];
        [window reloadInputViews];
        [window makeKeyAndVisible];
        isScanningOn = 1;
    }
}
- (void) showView {
    if (isPaused == 0) {
        [actionViewController.view setNeedsDisplay];
        
        [window insertSubview:actionViewController.view atIndex:1];
        [window reloadInputViews];
        [window makeKeyAndVisible];
        [cameraZoom removeFromSuperview];
        [helpBtn removeFromSuperview];
        isScanningOn = 0;
    }
}

- (void) showHelp {
    HelpViewController *hvc = [[HelpViewController alloc] init];
    hvc.title = @"User Help";
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:hvc];
    [hvc release];                                            
    [arParentViewController presentModalViewController:navigationController animated:YES];
    cameraZoom.hidden = YES;
    helpBtn.hidden = YES;
}

- (void) removeSplash:(NSTimer *)theTimer
{
    // poll to see if the camera video stream has started and if so remove the splash screen.
    if ([QCARutils getInstance].videoStreamStarted == YES)
    {
        [splashV removeFromSuperview];
        [theTimer invalidate];
        [window addSubview:cameraZoom];
    }
}

+ (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // don't do this straight after startup - the view controller will do it
    if (firstTime == NO)
    {
        // do the same as when the view is shown
        [arParentViewController viewDidAppear:NO];
    }
    
    firstTime = NO;
    
    // extend the facebook access token time
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // retrieve previously saved access token if exists
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
            [[self facebook] extendAccessTokenIfNeeded];  
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // do the same as when the view has dissappeared
    [arParentViewController viewDidDisappear:NO];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // AR-specific actions
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Handle any foreground procedures not related to animation here.
}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    if (newStatusBarOrientation == UIInterfaceOrientationLandscapeLeft) {        
        cameraZoom.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        helpBtn.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    }
    else if (newStatusBarOrientation == UIInterfaceOrientationLandscapeRight){
        cameraZoom.transform = CGAffineTransformMakeRotation(+M_PI / 2);
        helpBtn.transform = CGAffineTransformMakeRotation(+M_PI / 2);
    }
    else {
        cameraZoom.transform = CGAffineTransformMakeRotation(0.0);
        helpBtn.transform = CGAffineTransformMakeRotation(0.0);
    }
}

///////////////////////////////////
//open facebook app for sign in////
///////////////////////////////////
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (void)dealloc
{
    [arParentViewController release];
    [window release];
    [artPieces release];
    [tempComment release];
    [comments release];
    [cameraZoom release];
    [cameraLabel release];
    [facebook release];
    [super dealloc];
}

//NOT USED
- (void)storeData {
    NSString *filepath = [[[NSString alloc] initWithFormat:kDataPath] stringByExpandingTildeInPath];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:artPieces forKey:kDataKey];
    [archiver finishEncoding];
    
    [data writeToFile:filepath atomically:YES];
}

//NOT USED
- (void)loadData {
    NSString *filepath = [[[NSString alloc] initWithFormat:kDataPath] stringByExpandingTildeInPath];
    NSData *data = [[NSMutableData alloc]
                    initWithContentsOfFile:filepath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]
                                     initForReadingWithData:data];
    NSMutableArray *loaddata = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    [artPieces removeAllObjects];
    if (loaddata.count > 0) {
        artPieces = loaddata;
    }
}

@end
