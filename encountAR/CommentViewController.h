//
//  CommentViewController.h
//  ImageTargets
//
//  Created by Sheng Xu on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController{
    IBOutlet UITextField *commentTextField;
    UITapGestureRecognizer *tap;
    NSString *comment;
}

@property (nonatomic, retain) UITextField *commentTextField;
@property (nonatomic, retain) UITextField *titleTextField;
@property (nonatomic, retain) UITapGestureRecognizer *tap;
@property (nonatomic, retain) NSString *comment;
@property BOOL terminate;

- (IBAction)commentDidEnd:(id)sender;

- (IBAction) done;
- (IBAction) cancel;

@end
