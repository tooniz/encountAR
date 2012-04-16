//
//  ThreadsTableViewController.h
//  Disquser
//
//  Created by Sheng Xu on 12-03-17.
// 


#import <UIKit/UIKit.h>

@interface ThreadsTableViewController : UITableViewController{
    NSArray *threads;
    UIActivityIndicatorView *indicator;
}
@property (strong, nonatomic) NSArray *threads;
@property (nonatomic, copy) NSString *categoryID;

@end
