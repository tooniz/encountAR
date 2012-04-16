//
// TableVommentsViewController.h
// Disquser
// 



#import <UIKit/UIKit.h>

@interface TableCommentsViewController : UITableViewController {
    NSArray *comments;
    UIActivityIndicatorView *indicator;
}

@property (strong, nonatomic) NSArray *comments;
@property (nonatomic, copy) NSString *threadID;

@end
