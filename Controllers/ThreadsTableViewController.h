//
//  ThreadsTableViewController.h
//  Disquser
//
//  Created by Sheng Xu on 12-03-17.
//  Copyright (c) 2012 Beetlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadsTableViewController : UITableViewController{
    NSArray *threads;
    UIActivityIndicatorView *indicator;
}
@property (strong, nonatomic) NSArray *threads;
@property (nonatomic, copy) NSString *categoryID;

@end
