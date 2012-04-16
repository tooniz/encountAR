//
//  HistoryViewController.h
//  trackfriend
//
//  Created by Ming Zhou on 12-02-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)prsBack:(id)sender;

@end
