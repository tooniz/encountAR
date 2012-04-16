#import <UIKit/UIKit.h>
// import the facebook connect header
#import "FBConnect.h"
#import "AppDelegate.h"

@interface PostCommentViewController : UIViewController 
<FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate,
UITableViewDataSource,
UITableViewDelegate>{
    NSArray *permissions;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *emailField;
    IBOutlet UITextView *commentField;
    IBOutlet UIActivityIndicatorView *indicator;
    bool isUsingFacebook;
    IBOutlet UIImageView *avatar;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UIButton *login;
    IBOutlet UIButton *logout;
    Facebook *facebook;
    NSURL *avatarURL;
}

@property (nonatomic, copy) NSString *threadID;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic) bool isUsingFacebook;
@property (nonatomic, retain) NSURL *avatarURL;

- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (void)post;
- (void)dismiss;

@end
