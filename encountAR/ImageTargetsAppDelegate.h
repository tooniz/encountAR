/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/


#import <UIKit/UIKit.h>
#import "ActionViewController.h"

@class ARParentViewController;


@interface ImageTargetsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow* window;
    ARParentViewController* arParentViewController;
    UIImageView *splashV;
    ActionViewController * actionViewController;
    CGRect imageRect;
    
    CGRect imageRect1;
    CGRect imageRect2;
    CGRect imageRect3;
    CGRect imageRect4;
}

- (void) hideView;
- (void) showView;

+ (ImageTargetsAppDelegate *) appDelegate;

@property (nonatomic, retain) ActionViewController * actionViewController;
@property (nonatomic, readwrite) CGRect imageRect;
@property (nonatomic, readwrite) CGRect imageRect1;
@property (nonatomic, readwrite) CGRect imageRect2;
@property (nonatomic, readwrite) CGRect imageRect3;
@property (nonatomic, readwrite) CGRect imageRect4;
@end
