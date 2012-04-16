//
// PostCommentViewController.m
// 

#import "PostCommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IADisquser.h"
static NSString* kAppId = @"276219952455194";
@interface PostCommentViewController (PrivateMethods)
- (void)alertMessage:(NSString *)message;
- (void)postTheComment:(IADisqusComment *)comment;
- (void)startLoading;
- (void)stopLoading;
@end

@implementation PostCommentViewController

@synthesize threadID, facebook, permissions, isUsingFacebook,avatarURL;

//lazy instantiation
/*
- avatarURL {
    if (!avatarURL) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"url"]) {
            avatarURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
        }
    }
    return avatarURL;
}
*/
- (void)dealloc {
    [threadID release];
    [usernameField release];
    [emailField release];
    [commentField release];
    [indicator release];
    [facebook release];
    
    [avatar release];
    [avatarURL release];
    [super dealloc];
}
#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

#pragma mark - Login and Logout Views
- (void)showLoggedIn {
    // show a different view if logged in
    [self apiFQLIMe];
    usernameField.hidden = YES;
    emailField.hidden = YES;
    self.isUsingFacebook = YES;
    avatar.hidden = NO;
    userNameLabel.hidden = NO;
    login.hidden = YES;
    logout.hidden = NO;
    
} 

- (void)showLoggedOut {
    // show a different view if logged in
    usernameField.hidden = NO;
    emailField.hidden = NO;
    self.isUsingFacebook = NO;
    avatar.hidden = YES;
    userNameLabel.hidden = YES;
    logout.hidden = YES;
    login.hidden = NO;
    
} 
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isUsingFacebook = NO;
    avatar.hidden = YES;
    userNameLabel.hidden = YES;
    logout.hidden = YES;
    // Initialize Facebook
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.facebook = facebook;
    
    // Initialize permissions
    // ask for user's email and offline access
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email", nil];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Initialize API data (for views, etc.)
    //apiData = [[DataSet alloc] init];
    
    // Initialize user permissions
    //userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];

    
    // make a border for text view
    [commentField.layer setBorderWidth:3.0];
    [commentField.layer setBorderColor:[UIColor grayColor].CGColor];
    [commentField.layer setCornerRadius:8.0];
    
    // make a bar button item for post and dismiss
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)] autorelease];
    UIBarButtonItem *postButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(post)] autorelease];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [self.navigationItem setRightBarButtonItem:postButton];
    
    if ([[delegate facebook] isSessionValid]) {
        //if the user is already logged in as facebook, then we show his or her profile
        //and remove the need to enter email and name
        [self showLoggedIn];
    }
}

/**
 * Show the authorization dialog.
 */
- (IBAction) login: (id)sender {
    NSLog(@"login pressed");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // check if the user's current session is valid
    if (![[delegate facebook] isSessionValid]) {
        [[delegate facebook] authorize:permissions];
    } else {
        NSLog(@"User Already Logged in");
        [self showLoggedIn];
    }
}

- (IBAction)logout:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout];
}
#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    //save the access token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}

- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

- (void)viewDidUnload {
    [usernameField release];
    usernameField = nil;
    [emailField release];
    emailField = nil;
    [commentField release];
    commentField = nil;
    [indicator release];
    indicator = nil;
    [userNameLabel release];
    userNameLabel = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load user's default data
    [usernameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [emailField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
    
    // show up the keyboard
    if ([usernameField.text isEqualToString:@""]) {
        [usernameField becomeFirstResponder];
    } else if ([emailField.text isEqualToString:@""]) {
        [emailField becomeFirstResponder];
    } else {
        [commentField becomeFirstResponder];
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        [self showLoggedOut];
    } else {
        [self showLoggedIn];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Class Methods

- (void)startLoading {
    // set view to loading
    [indicator startAnimating];
    [self.view setAlpha:.5];
    [self.view setUserInteractionEnabled:NO];
}

- (void)stopLoading {
    // stop loading
    [indicator stopAnimating];
    [self.view setAlpha:1.0];
    [self.view setUserInteractionEnabled:YES];
}

- (void)alertMessage:(NSString *)message {
    // helper for alerting message
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't post" 
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Oh, okay" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)post {
    // user input basic validation
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // check if the user is using facebook or not
    if (![[delegate facebook] isSessionValid]) {
        if ([usernameField.text isEqualToString:@""]) {
            [self alertMessage:@"Empty username"];
            return;
        } else if ([emailField.text isEqualToString:@""]) {
            [self alertMessage:@"Empty email"];
            return;
        } else if ([commentField.text isEqualToString:@""]) {
            [self alertMessage:@"Empty comment"];
            return;
        }
    
        [self startLoading];
    
        IADisqusComment *aComment = [[[IADisqusComment alloc] init] autorelease];
        aComment.authorName = usernameField.text;
        aComment.authorEmail = emailField.text;
        aComment.rawMessage = commentField.text;
        aComment.threadID = [NSNumber numberWithInteger:[self.threadID integerValue]];
        // lets send it!
        [self postTheComment:aComment];
    }
    else {
        if ([commentField.text isEqualToString:@""]) {
            [self alertMessage:@"Empty comment"];
            return;
        }
        [self startLoading];
        IADisqusComment *aComment = [[[IADisqusComment alloc] init] autorelease];
        aComment.authorName = userNameLabel.text;
        aComment.authorEmail = @"none@none.com";
        aComment.rawMessage = commentField.text;
        aComment.authorURL = [avatarURL absoluteString];
        aComment.threadID = [NSNumber numberWithInteger:[self.threadID integerValue]];
        // lets send it!
        [self postTheComment:aComment];
    }
}


- (void)postTheComment:(IADisqusComment *)comment {
    // post the comment!
    [IADisquser postComment:comment 
                    success:^ {
                        // i don't know why, but it seems that we have to wait a while before the API loads the new comments
                        
                        // [self stopLoading];
                        // [self dismiss];
                        
                        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3.0];
                        [self performSelector:@selector(dismiss) withObject:nil afterDelay:3.1];
                    } fail:^ (NSError *error) {
                        [self stopLoading];
                        
                        NSLog(@"error : %@", [error localizedDescription]);
                        [self alertMessage:@"Error on posting comment"];
                    }];
}

- (void)dismiss {
    // save the username & email
    [[NSUserDefaults standardUserDefaults] setValue:usernameField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:emailField.text forKey:@"email"];
    
    // dismiss me
    [self dismissModalViewControllerAnimated:YES];
    app.isPaused = 0;
}


#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        // If basic information callback, set the UI objects to
        // display this.
        userNameLabel.text = [result objectForKey:@"name"];
        // Get the profile image
        self.avatarURL = [NSURL URLWithString:[result objectForKey:@"pic"]];
        //[[NSUserDefaults standardUserDefaults] setValue:avatarURL forKey:@"url"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
        float ratio;
        float delta;
        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        CGPoint offset;
        CGSize size = image.size;
        if (size.width > size.height) {
            ratio = px / size.width;
            delta = (ratio*size.width - ratio*size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = px / size.height;
            delta = (ratio*size.height - ratio*size.width);
            offset = CGPointMake(0, delta/2);
        }
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * size.width) + delta,
                                     (ratio * size.height) + delta);
        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // set the avatar's image
        [avatar setImage:imgThumb];
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}

@end
