//
//  SnapViewController.h
//  encountAR
//
//  Created by Ming Zhou on 12-03-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define TEMPLATE_NUM_MAX 7
//#define TEMPLATE_NUM_MIN 2

#define ENCOUNTAR_ALPHA 0.9

@class TZGradientButton;

@interface SnapViewController : UIViewController
@property (nonatomic, retain) UIImageView *s0V;
@property (nonatomic, retain) UIImageView *s1V;
@property (nonatomic, retain) UIImageView *s2V;
@property (nonatomic, retain) UIImageView *s3V;

@property (retain, nonatomic) IBOutlet UIView *encountARView;
@property (retain, nonatomic) IBOutlet UITextView *lblComment;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *encountarImg;


- (IBAction)tapEncountar:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *encountarBtn;

- (IBAction)prsHistoryBtn:(id)sender;
- (IBAction)prsToggleBtn:(id)sender;
- (IBAction)prsAddBtn:(id)sender;
- (IBAction)prsBackwardBtn:(id)sender;
- (IBAction)prsForwardBtn:(id)sender;

@property (nonatomic) int templateNumMax;
@property (nonatomic) int templateNumMin;
@property (nonatomic) int templateNumOffset;

@property (retain, nonatomic) IBOutlet TZGradientButton *historyBtn;
@property (retain, nonatomic) IBOutlet TZGradientButton *toggleBtn;

@property (retain, nonatomic) IBOutlet UIButton *backwardBtn;
@property (retain, nonatomic) IBOutlet UIButton *forwardBtn;
@property (retain, nonatomic) IBOutlet UIButton *addBtn;

@property (retain, nonatomic) IBOutlet UIImageView *replyBackground;
@property (retain, nonatomic) IBOutlet UILabel *replyPoster;
@property (retain, nonatomic) IBOutlet UILabel *replyDate;
@property (retain, nonatomic) IBOutlet UIImageView *replyPosterPicture;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (retain, nonatomic) NSString *threadID;




@end
