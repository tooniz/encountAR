/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


#import <UIKit/UIKit.h>
#import "ActionViewController.h"
#import "FBConnect.h"

#define app ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kDataKey @"Data"
#define kDataPath @"~/Documents/images.dat"

@class ARParentViewController;
//@class TZGradientButton;

@interface AppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate> {
    ARParentViewController* arParentViewController;
    UIImageView *splashV;
    ActionViewController * actionViewController;
    Facebook *facebook;
    bool isUsingFacebook;
    // used to notify the view to refresh the comment
    bool needRefreshMostRecentComment;
}

- (void) hideView;
- (void) showView;
- (void) showHelp;

+ (AppDelegate *) appDelegate;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ActionViewController * actionViewController;
@property (nonatomic, retain) UIImageView *cameraZoom;
@property (nonatomic, retain) UILabel *cameraLabel;
//@property (nonatomic, retain) UIButton *helpBtn;
@property (nonatomic, retain) UIImageView *helpBtn;

@property (strong, nonatomic) NSMutableArray *artPieces;
@property (strong, nonatomic) NSMutableArray *comments;

@property (strong, nonatomic) NSString *tempTitle;
@property (strong, nonatomic) NSString *tempComment;
@property (nonatomic) int artNum;
@property (nonatomic) bool isUsingFacebook;
@property (nonatomic) bool isPaused;
@property (nonatomic) bool isScanningOn;
@property (nonatomic) bool needRefreshMostRecentComment;

@property CGPoint artCoord;

@property CGPoint s0;
@property CGPoint s1;
@property CGPoint s2;
@property CGPoint s3;

@property (nonatomic, retain) Facebook *facebook;

@end
