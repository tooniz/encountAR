//
//  ActionViewController.h
//  ImageTargets
//
//  Created by Alexander Sommer on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnapViewController;

@interface ActionViewController : UIViewController {    
}

- (void) hideView;
- (void) showView;

@property (retain, nonatomic) IBOutlet SnapViewController *snapView;

@end
